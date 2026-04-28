import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../models/field_config.dart';
import '../services/field_config_service.dart';

/// 配置化表单组件
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

  const ConfigFormView({
    Key? key,
    required this.module,
    required this.group,
    required this.model,
    required this.configService,
    this.selectOptions,
    this.formKey,
    this.onChanged,
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
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _buildInput(context, field, value),
    );
  }

  Widget _buildInput(BuildContext context, FieldConfig field, dynamic value) {
    final controller = TextEditingController(text: _formatValue(value, field));
    
    switch (field.fieldType) {
      case 'select':
        return GestureDetector(
          onTap: () => _showSelectSheet(context, field),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: field.fieldName,
                hintText: '请选择${field.fieldName}',
                suffixIcon: const Icon(TDIcons.chevron_right),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        );
        
      case 'number':
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.fieldName,
            hintText: '请输入${field.fieldName}',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            final numValue = num.tryParse(val);
            if (onChanged != null) {
              onChanged!(field.fieldCode, numValue);
            }
          },
        );
        
      case 'date':
        return GestureDetector(
          onTap: () => _showDatePicker(context, field),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: field.fieldName,
                hintText: '请选择${field.fieldName}',
                suffixIcon: const Icon(TDIcons.calendar),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        );
        
      case 'textarea':
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.fieldName,
            hintText: '请输入${field.fieldName}',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 3,
          onChanged: (val) {
            if (onChanged != null) {
              onChanged!(field.fieldCode, val);
            }
          },
        );
        
      default:
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.fieldName,
            hintText: '请输入${field.fieldName}',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (val) {
            if (onChanged != null) {
              onChanged!(field.fieldCode, val);
            }
          },
        );
    }
  }

  String _formatValue(dynamic value, FieldConfig field) {
    if (value == null) return '';
    
    switch (field.fieldType) {
      case 'date':
        if (value is String) {
          return value.split('T').first;
        }
        return value.toString();
      case 'select':
        if (value is Map) {
          return value['name']?.toString() ?? '';
        }
        return value.toString();
      default:
        return value.toString();
    }
  }

  void _showSelectSheet(BuildContext context, FieldConfig field) {
    // TODO: 实现选择器底部弹窗
  }

  void _showDatePicker(BuildContext context, FieldConfig field) {
    // TODO: 实现日期选择器
  }
}