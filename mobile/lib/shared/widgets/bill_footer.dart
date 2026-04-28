import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 单据表尾组件
/// 包含支付方式、优惠、金额汇总、提交按钮等
class BillFooter extends StatelessWidget {
  /// 合计金额
  final double totalAmount;
  
  /// 优惠金额
  final double discountAmount;
  
  /// 实付金额
  final double payableAmount;
  
  /// 商品总数量
  final int totalQuantity;
  
  /// 商品种类数
  final int itemCount;
  
  /// 支付方式
  final String? paymentMethod;
  
  /// 备注
  final String? remark;
  
  /// 支付方式变更回调
  final void Function(String? value)? onPaymentChanged;
  
  /// 优惠变更回调
  final void Function(double value)? onDiscountChanged;
  
  /// 备注变更回调
  final void Function(String? value)? onRemarkChanged;
  
  /// 提交回调
  final VoidCallback? onSubmit;
  
  /// 是否正在提交
  final bool isSubmitting;

  const BillFooter({
    super.key,
    required this.totalAmount,
    this.discountAmount = 0,
    required this.payableAmount,
    required this.totalQuantity,
    required this.itemCount,
    this.paymentMethod,
    this.remark,
    this.onPaymentChanged,
    this.onDiscountChanged,
    this.onRemarkChanged,
    this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 支付方式选择
          _buildPaymentSelector(context),
          
          // 优惠方式
          _buildDiscountSelector(context),
          
          // 备注
          _buildRemarkInput(context),
          
          // 金额汇总
          _buildSummary(),
          
          // 提交按钮
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  /// 支付方式选择
  Widget _buildPaymentSelector(BuildContext context) {
    return TDCell(
      title: '支付方式',
      note: paymentMethod ?? '请选择',
      arrow: true,
      onClick: (_) => _showPaymentPicker(context),
    );
  }

  void _showPaymentPicker(BuildContext context) {
    final options = [['现金', '赊账', '微信', '支付宝', '银行转账']];
    TDPicker.showMultiPicker(
      context,
      title: '选择支付方式',
      data: options,
      onConfirm: (selected) {
        if (selected.isNotEmpty && selected[0] < options[0].length) {
          onPaymentChanged?.call(options[0][selected[0]]);
        }
        Navigator.of(context).pop();
      },
    );
  }

  /// 优惠选择器
  Widget _buildDiscountSelector(BuildContext context) {
    return TDCell(
      title: '优惠',
      note: discountAmount > 0 ? '-¥${discountAmount.toStringAsFixed(2)}' : '¥0.00',
      arrow: true,
      onClick: (_) => _showDiscountPicker(context),
    );
  }

  void _showDiscountPicker(BuildContext context) {
    final options = [['无优惠', '抹零', '整单折扣', '整单减额', '优惠券']];
    TDPicker.showMultiPicker(
      context,
      title: '选择优惠方式',
      data: options,
      onConfirm: (selected) {
        if (selected.isNotEmpty) {
          onDiscountChanged?.call(0);
        }
        Navigator.of(context).pop();
      },
    );
  }

  /// 备注输入
  Widget _buildRemarkInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacer4),
      child: TDInput(
        hintText: '备注信息',
        onChanged: onRemarkChanged,
      ),
    );
  }

  /// 金额汇总
  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacer4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '共$itemCount种商品，$totalQuantity件',
                style: const TextStyle(
                  fontSize: AppTheme.fontSizeXs,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacer2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '合计',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeS,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '¥${payableAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: AppTheme.fontSizeXl,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 提交按钮
  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacer4),
      child: TDButton(
        text: isSubmitting ? '提交中...' : '提交订单',
        theme: TDButtonTheme.primary,
        size: TDButtonSize.large,
        isBlock: true,
        onTap: isSubmitting ? null : onSubmit,
      ),
    );
  }
}

/// 商品明细组件
class BillDetailList extends StatelessWidget {
  /// 商品明细列表
  final List<BillDetailItem> items;
  
  /// 数量变更回调
  final void Function(int index, int quantity)? onQuantityChanged;
  
  /// 删除回调
  final void Function(int index)? onDelete;
  
  /// 添加商品回调
  final VoidCallback? onAdd;

  const BillDetailList({
    super.key,
    required this.items,
    this.onQuantityChanged,
    this.onDelete,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            padding: const EdgeInsets.all(AppTheme.spacer4),
            child: const Text(
              '商品明细',
              style: TextStyle(
                fontSize: AppTheme.fontSizeS,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // 商品列表
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildDetailItem(context, index, item);
          }),
          
          // 添加按钮
          TDCell(
            title: '+ 添加商品',
            onClick: (_) => onAdd?.call(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, int index, BillDetailItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacer4, vertical: AppTheme.spacer3),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // 商品信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeS,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '¥${item.price.toStringAsFixed(2)}/${item.unit}',
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeXs,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // 金额
          Text(
            '¥${item.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: AppTheme.fontSizeS,
              fontWeight: FontWeight.w600,
              color: AppTheme.errorColor,
            ),
          ),
          
          const SizedBox(width: AppTheme.spacer3),
          
          // 步进器
          TDStepper(
            value: item.quantity,
            min: 0,
            onChange: (value) => onQuantityChanged?.call(index, value),
          ),
          
          // 删除按钮
          if (onDelete != null)
            GestureDetector(
              onTap: () => onDelete?.call(index),
              child: const Padding(
                padding: EdgeInsets.only(left: AppTheme.spacer2),
                child: Icon(Icons.close, size: 20, color: AppTheme.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

/// 商品明细项
class BillDetailItem {
  final String productId;
  final String productName;
  final String unit;
  final double price;
  final int quantity;
  final double amount;

  BillDetailItem({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.price,
    required this.quantity,
    required this.amount,
  });

  BillDetailItem copyWith({
    String? productId,
    String? productName,
    String? unit,
    double? price,
    int? quantity,
    double? amount,
  }) {
    return BillDetailItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
    );
  }
}