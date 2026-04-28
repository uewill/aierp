import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 销售单列表页面
/// 支持查看、编辑、侧滑删除

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:aierp_mobile/data/services/data_service.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key});

  @override
  State<SalesListPage> createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  @override
  void initState() {
    super.initState();
    context.read<BillProvider>().loadBills(type: BillType.salesOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TDNavBar(
        title: '销售管理',
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
        onTap: () => Navigator.pushNamed(context, '/sales/create'),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(TDIcons.cart, size: 64, color: AppTheme.textPlaceholder),
          const SizedBox(height: 16),
          Text('暂无销售单', style: TextStyle(fontSize: 16, color: AppTheme.textPlaceholder)),
          const SizedBox(height: 24),
          TDButton(
            text: '新建销售单',
            theme: TDButtonTheme.primary,
            onTap: () => Navigator.pushNamed(context, '/sales/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Bill bill) {
    return Dismissible(
      key: Key(bill.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // 已审核的单据不能删除
        if (bill.status == BillStatus.approved) {
          TDToast.showFail('已审核单据不能删除', context: context);
          return false;
        }
        // 确认删除
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('确认删除'),
            content: Text('确定要删除销售单 ${bill.billNo} 吗？'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('删除', style: TextStyle(color: Color(0xFFFF4D4F))),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) async {
        await dataService.deleteBill(bill.id);
        TDToast.showSuccess('已删除', context: context);
        context.read<BillProvider>().loadBills(type: BillType.salesOrder);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: const Color(0xFFFF4D4F),
        child: const Icon(TDIcons.delete, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/sales/detail', arguments: bill.id),
        onLongPress: () => _showActionMenu(bill),
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
      ),
    );
  }

  void _showActionMenu(Bill bill) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TDButton(
              text: '查看详情',
              icon: TDIcons.browse,
              theme: TDButtonTheme.light,
              size: TDButtonSize.large,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/sales/detail', arguments: bill.id);
              },
            ),
            const SizedBox(height: 8),
            TDButton(
              text: '编辑',
              icon: TDIcons.edit,
              theme: TDButtonTheme.light,
              size: TDButtonSize.large,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/sales/edit', arguments: bill.id);
              },
            ),
            const SizedBox(height: 8),
            TDButton(
              text: '删除',
              icon: TDIcons.delete,
              theme: TDButtonTheme.danger,
              size: TDButtonSize.large,
              onTap: () async {
                Navigator.pop(ctx);
                await dataService.deleteBill(bill.id);
                TDToast.showSuccess('已删除', context: context);
                context.read<BillProvider>().loadBills(type: BillType.salesOrder);
              },
            ),
          ],
        ),
      ),
    );
  }
}