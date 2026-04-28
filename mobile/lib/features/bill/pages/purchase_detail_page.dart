import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 采购单详情页面

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/services/data_service.dart';

class PurchaseDetailPage extends StatefulWidget {
  const PurchaseDetailPage({super.key});

  @override
  State<PurchaseDetailPage> createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<PurchaseDetailPage> {
  Bill? _bill;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    if (id != null) _bill = await dataService.getBill(id);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(appBar: TDNavBar(title: '采购单详情'), body: const Center(child: TDLoading(size: TDLoadingSize.large)));
    if (_bill == null) return Scaffold(appBar: TDNavBar(title: '采购单详情'), body: Center(child: TDText('单据不存在')));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TDNavBar(title: _bill!.billNo, backgroundColor: AppTheme.brandColor, leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard([
              TDCell(title: '供应商', note: _bill!.partnerName ?? '-'),
              TDCell(title: '仓库', note: _bill!.warehouseName ?? '-'),
              TDCell(title: '日期', note: _bill!.billDate.toString().substring(0, 10)),
              TDCell(title: '状态', note: _bill!.statusName),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              Padding(
                padding: const EdgeInsets.all(16),
                child: const Text('商品明细', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              ..._bill!.details.map((d) => TDCell(title: d.productName, note: '${d.quantity} ${d.unitName}', description: '¥${d.amount.toStringAsFixed(2)}')),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              TDCell(title: '合计金额', note: '¥${_bill!.totalAmount.toStringAsFixed(2)}'),
            ]),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: children),
    );
  }
}