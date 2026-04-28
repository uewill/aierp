import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 首页 - 移动端优先设计
/// 核心功能：快捷操作、今日统计、功能菜单

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final appState = context.read<AppState>();
    await appState.init();
    await appState.refreshStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('进销存'),
        backgroundColor: AppTheme.brandColor7,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async => await appState.refreshStatistics(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 16),
                  _buildTodayStats(context, appState.statistics),
                  const SizedBox(height: 16),
                  _buildMenuGrid(context),
                  const SizedBox(height: 16),
                  _buildPendingBills(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 快捷操作
  Widget _buildQuickActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('快捷操作', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickItem(context, '销售开单', Icons.shopping_cart, const Color(0xFFFF4D4F), '/sales/create'),
              _buildQuickItem(context, '采购入库', Icons.inbox, const Color(0xFF00A870), '/purchase/create'),
              _buildQuickItem(context, '库存查询', Icons.search, const Color(0xFFFFB300), '/inventory'),
              _buildQuickItem(context, '商品管理', Icons.inventory, AppTheme.brandColor7, '/products'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickItem(BuildContext context, String title, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// 今日统计
  Widget _buildTodayStats(BuildContext context, Statistics? stats) {
    if (stats == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: const Center(child: Text('加载统计数据...')),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('今日统计', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(context, '销售额', '¥${stats.todaySales.toStringAsFixed(2)}', const Color(0xFFFF4D4F)),
              const SizedBox(width: 16),
              _buildStatItem(context, '采购额', '¥${stats.todayPurchase.toStringAsFixed(2)}', const Color(0xFF00A870)),
              const SizedBox(width: 16),
              _buildStatItem(context, '销售单', '${stats.todaySalesCount}单', AppTheme.brandColor7),
              const SizedBox(width: 16),
              _buildStatItem(context, '采购单', '${stats.todayPurchaseCount}单', AppTheme.brandColor7),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  /// 功能菜单
  Widget _buildMenuGrid(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('功能菜单', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildMenuItem(context, '商品', Icons.inventory, '/products'),
              _buildMenuItem(context, '客户', Icons.people, '/customers'),
              _buildMenuItem(context, '供应商', Icons.local_shipping, '/suppliers'),
              _buildMenuItem(context, '仓库', Icons.store, '/warehouses'),
              _buildMenuItem(context, '采购', Icons.shopping_bag, '/purchase'),
              _buildMenuItem(context, '销售', Icons.point_of_sale, '/sales'),
              _buildMenuItem(context, '库存', Icons.widgets, '/inventory'),
              _buildMenuItem(context, '报表', Icons.bar_chart, '/reports'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.brandColor7, size: 32),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// 待处理单据
  Widget _buildPendingBills(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final stats = appState.statistics;
        final pendingCount = stats?.pendingBills ?? 0;
        if (pendingCount == 0) return const SizedBox();
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.pending_actions, color: Color(0xFFFFB300)),
              const SizedBox(width: 12),
              Expanded(child: Text('待处理单据 $pendingCount 项', style: const TextStyle(fontSize: 14))),
              TDButton(
                text: '查看',
                theme: TDButtonTheme.primary,
                size: TDButtonSize.small,
                onTap: () => Navigator.pushNamed(context, '/bills/pending'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 设置页面
  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('切换公司'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings/company');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('系统设置'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}