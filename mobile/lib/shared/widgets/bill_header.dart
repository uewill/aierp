import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 单据表头字段配置
class BillHeaderField {
  final String key;
  final String label;
  final BillHeaderFieldType type;
  final bool required;
  final bool editable;
  final String? placeholder;
  final List<dynamic>? options; // 选择器的选项
  final Widget Function(BuildContext, dynamic)? customBuilder;

  BillHeaderField({
    required this.key,
    required this.label,
    this.type = BillHeaderFieldType.text,
    this.required = false,
    this.editable = true,
    this.placeholder,
    this.options,
    this.customBuilder,
  });
}

/// 表头字段类型
enum BillHeaderFieldType {
  text,       // 文本输入
  number,     // 数字输入
  select,     // 下拉选择
  date,       // 日期选择
  customer,   // 客户选择
  supplier,   // 供应商选择
  warehouse,  // 仓库选择
  salesman,   // 业务员选择
  custom,     // 自定义
}

/// 单据表头组件
/// 用于销售单、采购单、入库单、出库单等单据的表头区域
class BillHeader extends StatelessWidget {
  /// 字段配置列表
  final List<BillHeaderField> fields;
  
  /// 字段值
  final Map<String, dynamic> values;
  
  /// 字段变更回调
  final void Function(String key, dynamic value)? onChanged;
  
  /// 选择器点击回调
  final void Function(String key, BillHeaderFieldType type)? onSelectorTap;

  const BillHeader({
    super.key,
    required this.fields,
    required this.values,
    this.onChanged,
    this.onSelectorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgContainer,
      child: Column(
        children: fields.map((field) => _buildField(context, field)).toList(),
      ),
    );
  }

  Widget _buildField(BuildContext context, BillHeaderField field) {
    final value = values[field.key];
    
    return TDCell(
      title: field.label,
      required: field.required,
      note: _getDisplayValue(field, value),
      arrow: _shouldShowArrow(field),
      onClick: field.editable ? (_) => _handleTap(context, field) : null,
    );
  }

  String _getDisplayValue(BillHeaderField field, dynamic value) {
    if (value == null) return field.placeholder ?? '';
    
    switch (field.type) {
      case BillHeaderFieldType.select:
        if (field.options != null) {
          final option = field.options!.firstWhere(
            (o) => o['value'] == value,
            orElse: () => {'label': value.toString()},
          );
          return option['label'].toString();
        }
        return value.toString();
      case BillHeaderFieldType.date:
        // 格式化日期
        if (value is String) {
          return value.split('T').first;
        }
        return value.toString();
      default:
        return value.toString();
    }
  }

  bool _shouldShowArrow(BillHeaderField field) {
    return field.type == BillHeaderFieldType.select ||
           field.type == BillHeaderFieldType.date ||
           field.type == BillHeaderFieldType.customer ||
           field.type == BillHeaderFieldType.supplier ||
           field.type == BillHeaderFieldType.warehouse ||
           field.type == BillHeaderFieldType.salesman;
  }

  void _handleTap(BuildContext context, BillHeaderField field) {
    switch (field.type) {
      case BillHeaderFieldType.select:
        _showPicker(context, field);
        break;
      case BillHeaderFieldType.date:
        _showDatePicker(context, field);
        break;
      case BillHeaderFieldType.customer:
      case BillHeaderFieldType.supplier:
      case BillHeaderFieldType.warehouse:
      case BillHeaderFieldType.salesman:
        onSelectorTap?.call(field.key, field.type);
        break;
      default:
        _showInputDialog(context, field);
    }
  }

  void _showPicker(BuildContext context, BillHeaderField field) {
    if (field.options == null || field.options!.isEmpty) return;
    
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('选择${field.label}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...field.options!.map((option) => ListTile(
              title: Text(option['label'].toString()),
              trailing: values[field.key] == option['value'] 
                ? const Icon(Icons.check, color: AppTheme.brandColor) 
                : null,
              onTap: () {
                onChanged?.call(field.key, option['value']);
                Navigator.pop(ctx);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, BillHeaderField field) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((selected) {
      if (selected != null) {
        onChanged?.call(field.key, selected.toIso8601String().split('T').first);
      }
    });
  }

  void _showInputDialog(BuildContext context, BillHeaderField field) {
    final controller = TextEditingController(text: values[field.key]?.toString() ?? '');
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('输入${field.label}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: field.placeholder ?? '请输入${field.label}',
          ),
          keyboardType: field.type == BillHeaderFieldType.number 
              ? TextInputType.number 
              : TextInputType.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              onChanged?.call(field.key, controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

/// 预设的表头配置
class BillHeaderPresets {
  /// 销售单表头
  static List<BillHeaderField> salesOrder() => [
    BillHeaderField(
      key: 'customer',
      label: '客户',
      type: BillHeaderFieldType.customer,
      required: true,
    ),
    BillHeaderField(
      key: 'deliveryDate',
      label: '交货日期',
      type: BillHeaderFieldType.date,
    ),
    BillHeaderField(
      key: 'salesman',
      label: '业务员',
      type: BillHeaderFieldType.salesman,
    ),
    BillHeaderField(
      key: 'warehouse',
      label: '出货仓库',
      type: BillHeaderFieldType.warehouse,
      required: true,
    ),
    BillHeaderField(
      key: 'remark',
      label: '备注',
      type: BillHeaderFieldType.text,
    ),
  ];

  /// 采购单表头
  static List<BillHeaderField> purchaseOrder() => [
    BillHeaderField(
      key: 'supplier',
      label: '供应商',
      type: BillHeaderFieldType.supplier,
      required: true,
    ),
    BillHeaderField(
      key: 'warehouse',
      label: '入库仓库',
      type: BillHeaderFieldType.warehouse,
      required: true,
    ),
    BillHeaderField(
      key: 'billDate',
      label: '采购日期',
      type: BillHeaderFieldType.date,
    ),
    BillHeaderField(
      key: 'remark',
      label: '备注',
      type: BillHeaderFieldType.text,
    ),
  ];
}