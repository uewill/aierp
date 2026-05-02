import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../models/field_config.dart';
import '../services/field_config_service.dart';
import 'card_input_field.dart';

/// 配置化表单组件 - 卡片式风格
/// 根据字段配置动态渲染表单项
class ConfigFormView extends StatelessWidget {
  /// 模块编码
  final String module;
  
  /// 字段分组
  final String group;
  
  /// 表单数据
  final Map<String, dynamic> model;
  
  /// 字段配置服务
  final FieldConfigService configService;
  
  /// 选择器选项（按字段编码提供）
  final Map<String, List<Map<String, dynamic>>>? selectOptions;
  
  /// 表单Key
  final GlobalKey<FormState>? formKey;
  
  /// 数据变更回调
  final void Function(String fieldCode, dynamic value)? onChanged;
  
  /// 选择器回调（按字段编码）
  final Map<String, VoidCallback>? onSelectTap;

  const ConfigFormView({
    Key? key,
    required this.module,
    required this.group,
    required this.model,
    required this.configService,
    this.selectOptions,
    this.formKey,
    this.onChanged,
    this.onSelectTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FieldConfig>>(
      future: configService.getVisibleFields(module, group: group),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: TDLoading(size: TDLoadingSize.large));
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        
        final fields = snapshot.data!;
        
        return Form(
          key: formKey,
          child: Column(
            children: fields.map((f) => _buildFormField(context, f)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFormField(BuildContext context, FieldConfig field) {
    final value = model[field.fieldCode];
    
    switch (field.fieldType) {
      case 'select':
        return CardSelectField(
          title: field.fieldName,
          hint: '请选择${field.fieldName}',
          displayValue: _formatSelectValue(value),
          required: field.required,
          onTap: onSelectTap?[field.fieldCode] ?? () => _showSelectHint(context, field),
        );
        
      case 'number':
        return CardInputField(
          title: field.fieldName,
          hint: '请输入${field.fieldName}',
          value: value?.toString() ?? '',
          required: field.required,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) {
            final numValue = num.tryParse(v);
            if (onChanged != null) {
              onChanged!(field.fieldCode, numValue);
            }
          },
        );
        
      case 'date':
        return CardDateField(
          title: field.fieldName,
          displayValue: _formatDateValue(value),
          required: field.required,
          onTap: onSelectTap?[field.fieldCode] ?? () => _showDateHint(context, field),
        );
        
      case 'textarea':
        return CardInputField(
          title: field.fieldName,
          hint: '请输入${field.fieldName}',
          value: value?.toString() ?? '',
          required: field.required,
          maxLines: 3,
          onChanged: (v) {
            if (onChanged != null) {
              onChanged!(field.fieldCode, v);
            }
          },
        );
        
      default:
        return CardInputField(
          title: field.fieldName,
          hint: '请输入${field.fieldName}',
          value: value?.toString() ?? '',
          required: field.required,
          onChanged: (v) {
            if (onChanged != null) {
              onChanged!(field.fieldCode, v);
            }
          },
        );
    }
  }

  String? _formatSelectValue(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return value['name']?.toString();
    }
    if (value is String && value.isNotEmpty) {
      // 尝试从selectOptions中查找显示名称
      return value;
    }
    return null;
  }

  String? _formatDateValue(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      // 格式化日期字符串
      if (value.contains('T')) {
        return value.split('T').first;
      }
      return value;
    }
    if (value is DateTime) {
      return '${value.year}-${value.month}-${value.day}';
    }
    return value.toString();
  }

  void _showSelectHint(BuildContext context, FieldConfig field) {
    TDToast.showText('请配置选择器回调: onSelectTap["${field.fieldCode}"]', context: context);
  }

  void _showDateHint(BuildContext context, FieldConfig field) {
    TDToast.showText('请配置日期选择回调: onSelectTap["${field.fieldCode}"]', context: context);
  }
}