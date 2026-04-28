/// 采购入库页面
/// 与销售开单类似，逻辑复用

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:aierp_mobile/data/mock/mock_data.dart';
import 'package:aierp_mobile/data/services/data_service.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

class PurchaseCreatePage extends StatefulWidget {
  const PurchaseCreatePage({super.key});

  @override
  State<PurchaseCreatePage> createState() => _PurchaseCreatePageState();
}

class _PurchaseCreatePageState extends State<PurchaseCreatePage> {
  Partner? _selectedSupplier;
  Warehouse? _selectedWarehouse;
  List<BillDetail> _details = [];
  double _paidAmount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<WarehouseProvider>().loadWarehouses();
    await context.read<PartnerProvider>().loadSuppliers();
    _selectedWarehouse = context.read<WarehouseProvider>().defaultWarehouse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: TDNavBar(
        title: '采购入库',
        backgroundColor: AppTheme.brandColor,
        leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSupplierSelector(context),
              const SizedBox(height: 12),
              _buildWarehouseSelector(context),
              const SizedBox(height: 16),
              _buildGoodsSection(context),
              const SizedBox(height: 16),
              _buildAmountSection(context),
            ],
          ),
        ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildSupplierSelector(BuildContext context) {
    return Consumer<PartnerProvider>(
      builder: (context, partnerProvider, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: TDCell(
            title: '供应商',
            required: true,
            note: _selectedSupplier?.name ?? '请选择',
            arrow: true,
            onClick: (cell) => _showSupplierPicker(context, partnerProvider.suppliers),
          ),
        );
      },
    );
  }

  void _showSupplierPicker(BuildContext context, List<Partner> suppliers) {
    final supplierNames = [suppliers.map((s) => s.name).toList()];
    TDPicker.showMultiPicker(
      context,
      title: '选择供应商',
      data: supplierNames,
      onConfirm: (selected) {
        if (selected.isNotEmpty && selected[0] < suppliers.length) {
          setState(() => _selectedSupplier = suppliers[selected[0]]);
        }
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildWarehouseSelector(BuildContext context) {
    return Consumer<WarehouseProvider>(
      builder: (context, warehouseProvider, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: TDCell(
            title: '入库仓库',
            required: true,
            note: _selectedWarehouse?.name ?? '请选择',
            arrow: true,
            onClick: (cell) => _showWarehousePicker(context, warehouseProvider.warehouses),
          ),
        );
      },
    );
  }

  void _showWarehousePicker(BuildContext context, List<Warehouse> warehouses) {
    final warehouseNames = [warehouses.map((w) => w.name).toList()];
    TDPicker.showMultiPicker(
      context,
      title: '选择仓库',
      data: warehouseNames,
      onConfirm: (selected) {
        if (selected.isNotEmpty && selected[0] < warehouses.length) {
          setState(() => _selectedWarehouse = warehouses[selected[0]]);
        }
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildGoodsSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('商品明细', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                TDButton(
                  text: '添加',
                  icon: TDIcons.add,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.small,
                  onTap: () => Navigator.pushNamed(context, '/products/select').then((r) {
                    if (r != null && r is Map) {
                      final product = r['product'] as Product;
                      final sku = r['sku'] as ProductSku?;
                      final detail = BillDetail(
                        id: 'd${DateTime.now().millisecondsSinceEpoch}',
                        productId: product.id,
                        productSkuId: sku?.id ?? product.id,
                        productName: product.name,
                        skuName: sku?.specName ?? '',
                        unitId: product.unitId ?? 'unit_001',
                        unitName: MockData.units.where((u) => u.id == product.unitId).firstOrNull?.name ?? '个',
                        quantity: 1,
                        price: sku?.costPrice ?? product.costPrice ?? 0,
                        amount: sku?.costPrice ?? product.costPrice ?? 0,
                      );
                      setState(() => _details.add(detail));
                    }
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_details.isEmpty)
              Container(height: 80, alignment: Alignment.center, child: const Text('请添加商品'))
            else
              ..._details.map((d) => TDCell(
                title: d.productName,
                note: '${d.quantity} ${d.unitName}',
                description: '¥${d.amount.toStringAsFixed(2)}',
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    final total = _details.fold(0.0, (s, d) => s + d.amount);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: TDCell(title: '合计金额', note: '¥${total.toStringAsFixed(2)}'),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final total = _details.fold(0.0, (s, d) => s + d.amount);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text('¥${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.errorColor)),
          const Spacer(),
          TDButton(
            text: '保存',
            theme: TDButtonTheme.primary,
            size: TDButtonSize.large,
            onTap: () => _save(context),
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    if (_selectedWarehouse == null || _details.isEmpty) {
      TDToast.showFail('请完善信息', context: context);
      return;
    }
    setState(() => _isLoading = true);
    final billNo = await dataService.generateBillNo(BillType.purchaseOrder);
    final bill = Bill(
      id: 'b${DateTime.now().millisecondsSinceEpoch}',
      billNo: billNo,
      type: BillType.purchaseOrder,
      status: BillStatus.pending,
      partnerId: _selectedSupplier?.id,
      partnerName: _selectedSupplier?.name,
      warehouseId: _selectedWarehouse!.id,
      warehouseName: _selectedWarehouse!.name,
      billDate: DateTime.now(),
      details: _details,
      totalAmount: _details.fold(0.0, (s, d) => s + d.amount),
      createTime: DateTime.now(),
    );
    await dataService.saveBill(bill);
    setState(() => _isLoading = false);
    TDToast.showSuccess('保存成功', context: context);
    Navigator.pop(context, true);
  }
}