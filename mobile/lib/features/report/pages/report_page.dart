/// 报表统计页面 - 使用真实 API
/// 功能：今日统计、本月统计、库存概况、商品销售排行

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/api/report_api.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 报表数据 Provider
class ReportDataProvider extends ChangeNotifier {
  final _api = ReportApi();
  
  ReportStatistics? _statistics;
  ReportStatistics? get statistics => _statistics;
  
  List<SalesRankItem> _salesRank = [];
  List<SalesRankItem> get salesRank => _salesRank;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  /// 加载所有报表数据
  Future<void> loadData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // 并行加载统计数据和销售排行
      final results = await Future.wait([
        _api.getStatistics(),
        _api.getSalesRankTop10(),
      ]);
      
      _statistics = results[0] as ReportStatistics;
      _salesRank = results[1] as List<SalesRankItem>;
    } catch (e) {
      debugPrint('加载报表数据失败: $e');
      _statistics = ReportStatistics.empty();
      _salesRank = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// 刷新数据
  Future<void> refresh() async {
    await loadData();
  }
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late ReportDataProvider _reportProvider;
  
  @override
  void initState() {
    super.initState();
    _reportProvider = ReportDataProvider();
    _reportProvider.loadData();
  }
  
  @override
  void dispose() {
    _reportProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: TDNavBar(
        title: '报表统计',
        backgroundColor: AppTheme.brandColor,
        leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))],
      ),
      body: ChangeNotifierProvider.value(
        value: _reportProvider,
        child: Consumer<ReportDataProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.statistics == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final stats = provider.statistics ?? ReportStatistics.empty();
            final salesRank = provider.salesRank;

            return RefreshIndicator(
              onRefresh: () => provider.refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 今日统计
                    _buildTodayStats(context, stats),
                    const SizedBox(height: 16),
                    // 本月统计
                    _buildMonthStats(context, stats),
                    const SizedBox(height: 16),
                    // 库存概况
                    _buildInventoryOverview(context, stats),
                    const SizedBox(height: 16),
                    // 商品销售排行 TOP10
                    if (salesRank.isNotEmpty) _buildSalesRank(context, salesRank),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 今日统计卡片
  Widget _buildTodayStats(BuildContext context, ReportStatistics stats) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('今日统计', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  DateTime.now().toString().substring(0, 10),
                  style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatItem(context, '销售额', '¥${stats.todaySales.toStringAsFixed(2)}', AppTheme.errorColor)),
                Expanded(child: _buildStatItem(context, '采购额', '¥${stats.todayPurchase.toStringAsFixed(2)}', AppTheme.successColor)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatItem(context, '销售单', '${stats.todaySalesCount}笔', AppTheme.textPrimary)),
                Expanded(child: _buildStatItem(context, '采购单', '${stats.todayPurchaseCount}笔', AppTheme.textPrimary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 本月统计卡片
  Widget _buildMonthStats(BuildContext context, ReportStatistics stats) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('本月统计', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  '${DateTime.now().year}年${DateTime.now().month}月',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatItem(context, '销售额', '¥${(stats.monthSales / 10000).toStringAsFixed(2)}万', AppTheme.errorColor)),
                Expanded(child: _buildStatItem(context, '采购额', '¥${(stats.monthPurchase / 10000).toStringAsFixed(2)}万', AppTheme.successColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 库存概况卡片
  Widget _buildInventoryOverview(BuildContext context, ReportStatistics stats) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('库存概况', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          TDCell(
            title: '库存总值',
            note: '¥${(stats.totalInventoryValue / 10000).toStringAsFixed(2)}万',
            leftIcon: TDIcons.money,
          ),
          TDCell(
            title: '待审核单据',
            note: '${stats.pendingBills}笔',
            leftIcon: TDIcons.pending,
          ),
          TDCell(
            title: '库存不足商品',
            note: '${stats.lowStockCount}种',
            leftIcon: TDIcons.error_circle,
          ),
        ],
      ),
    );
  }

  /// 商品销售排行 TOP10
  Widget _buildSalesRank(BuildContext context, List<SalesRankItem> rankItems) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('商品销售排行 TOP10', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                TDTag('今日', theme: TDTagTheme.primary, size: TDTagSize.small),
              ],
            ),
            const SizedBox(height: 16),
            ...rankItems.take(10).map((item) => _buildRankItem(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildRankItem(BuildContext context, SalesRankItem item) {
    final rankColor = item.rank <= 3 ? AppTheme.errorColor : AppTheme.textPrimary;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          // 排名
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: item.rank <= 3 ? AppTheme.errorColor.withOpacity(0.1) : AppTheme.bgPage,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.rank}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: rankColor),
            ),
          ),
          const SizedBox(width: 12),
          // 商品名称
          Expanded(
            child: Text(item.productName, style: const TextStyle(fontSize: 14)),
          ),
          // 销售数量
          Text(
            '${item.salesQuantity.toStringAsFixed(0)}件',
            style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder),
          ),
          const SizedBox(width: 12),
          // 销售金额
          Text(
            '¥${item.salesAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.errorColor),
          ),
        ],
      ),
    );
  }

  /// 统计项组件
  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgPage,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder)),
        ],
      ),
    );
  }
}