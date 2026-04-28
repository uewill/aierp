import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 采购单列表页面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage({super.key});

  @override
  State<PurchaseListPage> createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage> {
  @override
  void initState() {
    super.initState();
    context.read<BillProvider>().loadBills(type: BillType.purchaseOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TDNavBar(
        title: '采购管理',
        backgroundColor: AppTheme.brandColor,
        leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))],
      ),
      body: Consumer<BillProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: TDLoading(size: TDLoadingSize.large));
          if (provider.bills.isEmpty) return _buildEmpty(context);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.bills.length,
            itemBuilder: (context, index) => _buildItem(provider.bills[index]),
          );
        },
      ),
      floatingActionButton: TDButton(
        text: '开单',
        icon: TDIcons.add,
        theme: TDButtonTheme.primary,
        shape: TDButtonShape.circle,
        onTap: () => Navigator.pushNamed(context, '/purchase/create'),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(TDIcons.shop, size: 64, color: AppTheme.textPlaceholder),
          const SizedBox(height: 16),
          Text('暂无采购单', style: TextStyle(fontSize: 16, color: AppTheme.textPlaceholder)),
          const SizedBox(height: 24),
          TDButton(text: '新建采购单', theme: TDButtonTheme.primary, onTap: () => Navigator.pushNamed(context, '/purchase/create')),
        ],
      ),
    );
  }

  Widget _buildItem(Bill bill) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/purchase/detail', arguments: bill.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TDCell(
          title: bill.billNo,
          note: bill.partnerName ?? '-',
          description: '¥${bill.totalAmount.toStringAsFixed(2)}',
          arrow: true,
        ),
      ),
    );
  }
}