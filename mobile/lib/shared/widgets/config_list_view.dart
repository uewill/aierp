import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../models/field_config.dart';
import '../services/field_config_service.dart';

/// 配置化列表组件
/// 根据字段配置动态渲染列表项
class ConfigListView extends StatelessWidget {
  /// 模块编码
  final String module;
  
  /// 字段分组（默认body）
  final String group;
  
  /// 数据列表
  final List<Map<String, dynamic>> data;
  
  /// 字段配置服务
  final FieldConfigService configService;
  
  /// 点击回调
  final void Function(Map<String, dynamic> item)? onTap;

  const ConfigListView({
    Key? key,
    required this.module,
    required this.data,
    required this.configService,
    this.group = 'body',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FieldConfig>>(
      future: configService.getVisibleFields(module, group: group),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }
        
        final fields = snapshot.data!;
        
        return RefreshIndicator(
          onRefresh: () async {
            configService.clearCache();
          },
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _buildItem(context, data[index], fields);
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, Map<String, dynamic> item, List<FieldConfig> fields) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap != null ? () => onTap!(item) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fields.map((f) => _buildFieldRow(item, f)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldRow(Map<String, dynamic> item, FieldConfig field) {
    final value = item[field.fieldCode];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // 字段名称
          Text(
            '${field.fieldName}: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          // 字段值
          Expanded(
            child: Text(
              _formatValue(value, field),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue(dynamic value, FieldConfig field) {
    if (value == null) return '-';
    
    switch (field.fieldType) {
      case 'number':
        if (value is num) {
          return value.toStringAsFixed(2);
        }
        return value.toString();
      case 'date':
        if (value is String) {
          return value.split('T').first;
        }
        return value.toString();
      case 'select':
        if (value is Map) {
          return value['name']?.toString() ?? '-';
        }
        return value.toString();
      default:
        return value.toString();
    }
  }
}