/// 销售开单页面 - 移动端优先设计
/// 核心流程：选择客户 → 添加商品 → 确认提交

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:aierp_mobile/data/mock/mock_data.dart';
import 'package:aierp_mobile/data/services/data_service.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

class SalesCreatePage extends StatefulWidget {
  const SalesCreatePage({super.key});

  @override
  State<SalesCreatePage> createState() => _SalesCreatePageState();
}

class _SalesCreatePageState extends State<SalesCreatePage> {
  // 编辑模式
  Bill? _editBill;
  bool _isEditMode = false;
  
  // 表单数据
  Partner? _selectedCustomer;
  Warehouse? _selectedWarehouse;
  List<BillDetail> _details = [];
  double _discountAmount = 0;
  double _paidAmount = 0;
  String _remark = '';
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<WarehouseProvider>().loadWarehouses();
    await context.read<PartnerProvider>().loadCustomers();
    
    // 检查是否编辑模式
    final billId = ModalRoute.of(context)?.settings.arguments as String?;
    if (billId != null && mounted) {
      _isEditMode = true;
      _editBill = await dataService.getBill(billId);
      if (_editBill != null) {
        _selectedCustomer = await dataService.getPartner(_editBill!.partnerId ?? '');
        _selectedWarehouse = await dataService.getWarehouse(_editBill!.warehouseId);
        _details = List.from(_editBill!.details);
        _discountAmount = _editBill!.discountAmount;
        _paidAmount = _editBill!.paidAmount;
        _remark = _editBill!.remark ?? '';
      }
    } else {
      // 新建模式 - 默认选择主仓库
      final warehouseProvider = context.read<WarehouseProvider>();
      _selectedWarehouse = warehouseProvider.defaultWarehouse;
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: _buildAppBar(context),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerSelector(context),
              const SizedBox(height: 12),
              _buildWarehouseSelector(context),
              const SizedBox(height: 16),
              _buildGoodsSection(context),
              const SizedBox(height: 16),
              _buildAmountSection(context),
              const SizedBox(height: 16),
              _buildRemarkSection(context),
              const SizedBox(height: 100), // 底部按钮空间
            ],
          ),
        ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return TDNavBar(
      title: _isEditMode ? '编辑 ${_editBill?.billNo ?? ""}' : '销售开单',
      titleFontWeight: FontWeight.w600,
      backgroundColor: AppTheme.brandColor,
      leftBarItems: [
        TDNavBarItem(
          icon: TDIcons.chevron_left,
          action: () => Navigator.pop(context),
        ),
      ],
    );
  }

  /// 客户选择器 - 下拉选择
  Widget _buildCustomerSelector(BuildContext context) {
    return Consumer<PartnerProvider>(
      builder: (context, partnerProvider, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: TDCell(
            title: '客户',
            required: true,
            note: _selectedCustomer?.name ?? '请选择',
            arrow: true,
            onClick: (cell) => _showCustomerPicker(context, partnerProvider.customers),
          ),
        );
      },
    );
  }

  void _showCustomerPicker(BuildContext context, List<Partner> customers) {
    final customerNames = [['请选择客户', ...customers.map((c) => c.name)]];
    TDPicker.showMultiPicker(
      context,
      title: '选择客户',
      data: customerNames,
      onConfirm: (selected) {
        if (selected.isNotEmpty && selected[0] > 0) {
          final customer = customers[selected[0] - 1];
          setState(() => _selectedCustomer = customer);
        }
        Navigator.of(context).pop();
      },
    );
  }

  /// 仓库选择器
  Widget _buildWarehouseSelector(BuildContext context) {
    return Consumer<WarehouseProvider>(
      builder: (context, warehouseProvider, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: TDCell(
            title: '出库仓库',
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
        if (selected.isNotEmpty) {
          final warehouse = warehouses[selected[0]];
          setState(() => _selectedWarehouse = warehouse);
        }
        Navigator.of(context).pop();
      },
    );
  }

  /// 商品明细区域
  Widget _buildGoodsSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('商品明细', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                TDButton(
                  text: '添加商品',
                  icon: TDIcons.add,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.small,
                  onTap: () => _showProductPicker(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_details.isEmpty)
              _buildEmptyGoods(context)
            else
              ..._details.map((detail) => _buildDetailItem(context, detail)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyGoods(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: const Text('请添加商品', style: TextStyle(fontSize: 14, color: AppTheme.textPlaceholder)),
    );
  }

  Widget _buildDetailItem(BuildContext context, BillDetail detail) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                if (detail.skuName.isNotEmpty)
                  Text(detail.skuName, style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('数量', style: TextStyle(fontSize: 12, color: AppTheme.textPlaceholder)),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (detail.quantity > 1) {
                              _updateDetailQuantity(detail.id, detail.quantity.toInt() - 1);
                            }
                          },
                        ),
                        Text(detail.quantity.toInt().toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _updateDetailQuantity(detail.id, detail.quantity.toInt() + 1);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(detail.unitName, style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('¥${detail.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.errorColor)),
              Text('单价 ¥${detail.price}', style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder)),
            ],
          ),
          IconButton(
            icon: const Icon(TDIcons.delete, color: AppTheme.errorColor, size: 20),
            onPressed: () => _removeDetail(detail.id),
          ),
        ],
      ),
    );
  }

  /// 商品选择器
  void _showProductPicker(BuildContext context) {
    Navigator.pushNamed(context, '/products/select').then((result) {
      if (result != null && result is Map) {
        final product = result['product'] as Product;
        final sku = result['sku'] as ProductSku?;
        
        _addDetail(product, sku);
      }
    });
  }

  void _addDetail(Product product, ProductSku? sku) {
    final unit = MockData.units.where((u) => u.id == (sku?.unitId ?? product.unitId)).firstOrNull;
    
    final detail = BillDetail(
      id: 'detail_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      productSkuId: sku?.id ?? product.id,
      productName: product.name,
      skuName: sku?.specName ?? '',
      unitId: unit?.id ?? 'unit_001',
      unitName: unit?.name ?? '个',
      quantity: 1,
      price: sku?.price ?? product.price,
      amount: sku?.price ?? product.price,
    );
    
    setState(() => _details.add(detail));
  }

  void _updateDetailQuantity(String detailId, int quantity) {
    final index = _details.indexWhere((d) => d.id == detailId);
    if (index >= 0) {
      final detail = _details[index];
      _details[index] = BillDetail(
        id: detail.id,
        productId: detail.productId,
        productSkuId: detail.productSkuId,
        productName: detail.productName,
        skuName: detail.skuName,
        unitId: detail.unitId,
        unitName: detail.unitName,
        quantity: quantity.toDouble(),
        price: detail.price,
        amount: quantity * detail.price,
      );
      setState(() {});
    }
  }

  void _removeDetail(String detailId) {
    setState(() => _details.removeWhere((d) => d.id == detailId));
  }

  /// 金额区域
  Widget _buildAmountSection(BuildContext context) {
    final totalAmount = _details.fold(0.0, (sum, d) => sum + d.amount);
    final arrearsAmount = totalAmount - _discountAmount - _paidAmount;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          TDCell(title: '合计金额', note: '¥${totalAmount.toStringAsFixed(2)}'),
          TDCell(
            title: '优惠金额',
            note: '¥${_discountAmount.toStringAsFixed(2)}',
            arrow: true,
            onClick: (cell) => _showDiscountInput(context),
          ),
          TDCell(
            title: '实收金额',
            required: true,
            note: '¥${_paidAmount.toStringAsFixed(2)}',
            arrow: true,
            onClick: (cell) => _showPaidInput(context),
          ),
          TDCell(
            title: '欠款金额',
            note: '¥${arrearsAmount.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  void _showDiscountInput(BuildContext context) {
    final totalAmount = _details.fold(0.0, (sum, d) => sum + d.amount);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('输入优惠金额'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '0.00'),
          onSubmitted: (value) {
            final discount = double.tryParse(value) ?? 0;
            setState(() => _discountAmount = discount.clamp(0, totalAmount));
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('取消')),
          TextButton(onPressed: () {
            final controller = (ctx.widget as AlertDialog).content as TextField;
            Navigator.of(ctx).pop();
          }, child: const Text('确定')),
        ],
      ),
    );
  }

  void _showPaidInput(BuildContext context) {
    final totalAmount = _details.fold(0.0, (sum, d) => sum + d.amount);
    final maxPaid = totalAmount - _discountAmount;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('输入实收金额'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '0.00'),
          onSubmitted: (value) {
            final paid = double.tryParse(value) ?? 0;
            setState(() => _paidAmount = paid.clamp(0, maxPaid));
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('确定')),
        ],
      ),
    );
  }

  /// 备注
  Widget _buildRemarkSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          decoration: const InputDecoration(
            hintText: '备注（可选）',
            border: InputBorder.none,
          ),
          onChanged: (value) => _remark = value,
          controller: TextEditingController(text: _remark),
        ),
      ),
    );
  }

  /// 底部操作按钮
  Widget _buildBottomActions(BuildContext context) {
    final totalAmount = _details.fold(0.0, (sum, d) => sum + d.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('合计', style: TextStyle(fontSize: 12, color: AppTheme.textPlaceholder)),
                Text('¥${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.errorColor)),
              ],
            ),
          ),
          TDButton(
            text: '保存草稿',
            theme: TDButtonTheme.defaultTheme,
            size: TDButtonSize.large,
            onTap: () => _saveBill(BillStatus.draft),
          ),
          const SizedBox(width: 12),
          TDButton(
            text: '提交审核',
            theme: TDButtonTheme.primary,
            size: TDButtonSize.large,
            onTap: () => _saveBill(BillStatus.pending),
          ),
        ],
      ),
    );
  }

  /// 保存单据
  Future<void> _saveBill(BillStatus status) async {
    if (_selectedWarehouse == null) {
      TDToast.showFail('请选择出库仓库', context: context);
      return;
    }

    if (_details.isEmpty) {
      TDToast.showFail('请添加商品', context: context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final totalAmount = _details.fold(0.0, (sum, d) => sum + d.amount);
      
      Bill bill;
      
      if (_isEditMode && _editBill != null) {
        // 编辑模式 - 更新现有单据
        bill = Bill(
          id: _editBill!.id,
          billNo: _editBill!.billNo,
          type: _editBill!.type,
          status: status,
          partnerId: _selectedCustomer?.id,
          partnerName: _selectedCustomer?.name,
          warehouseId: _selectedWarehouse!.id,
          warehouseName: _selectedWarehouse!.name,
          billDate: _editBill!.billDate,
          details: _details,
          totalAmount: totalAmount,
          discountAmount: _discountAmount,
          paidAmount: _paidAmount,
          arrearsAmount: totalAmount - _discountAmount - _paidAmount,
          remark: _remark,
          operatorName: _editBill!.operatorName,
          createTime: _editBill!.createTime,
        );
      } else {
        // 新建模式
        final billNo = await dataService.generateBillNo(BillType.salesOrder);
        bill = Bill(
          id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
          billNo: billNo,
          type: BillType.salesOrder,
          status: status,
          partnerId: _selectedCustomer?.id,
          partnerName: _selectedCustomer?.name,
          warehouseId: _selectedWarehouse!.id,
          warehouseName: _selectedWarehouse!.name,
          billDate: DateTime.now(),
          details: _details,
          totalAmount: totalAmount,
          discountAmount: _discountAmount,
          paidAmount: _paidAmount,
          arrearsAmount: totalAmount - _discountAmount - _paidAmount,
          remark: _remark,
          operatorName: '管理员',
          createTime: DateTime.now(),
        );
      }

      final result = await dataService.saveBill(bill);

      setState(() => _isLoading = false);

      if (result) {
        TDToast.showSuccess(_isEditMode ? '修改成功' : (status == BillStatus.draft ? '保存成功' : '提交成功'), context: context);
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      TDToast.showFail('保存失败：$e', context: context);
    }
  }
}