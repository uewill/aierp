import 'package:aierp_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/models/spec_attribute.dart';

/// 规格属性编辑器 - 卡片式布局
class SpecAttributeEditor extends StatefulWidget {
  final List<SpecAttribute> attributes;
  final ValueChanged<List<SpecAttribute>> onAttributesChanged;
  
  const SpecAttributeEditor({
    super.key,
    required this.attributes,
    required this.onAttributesChanged,
  });

  @override
  State<SpecAttributeEditor> createState() => _SpecAttributeEditorState();
}

class _SpecAttributeEditorState extends State<SpecAttributeEditor> {
  late List<SpecAttribute> _attributes;

  @override
  void initState() {
    super.initState();
    _attributes = List.from(widget.attributes);
  }

  /// 显示添加/编辑规格弹窗
  void _showAddDialog(int? editIndex) {
    final nameController = TextEditingController(
      text: editIndex != null ? _attributes[editIndex].name : '',
    );
    final valuesController = TextEditingController(
      text: editIndex != null ? _attributes[editIndex].values.join(',') : '',
    );
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(editIndex != null ? '编辑规格' : '添加规格'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 规格名称输入
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '规格名称',
                    hintText: '如：颜色、尺寸、容量',
                    border: OutlineInputBorder(),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 规格值输入（逗号分隔）
                TextField(
                  controller: valuesController,
                  decoration: const InputDecoration(
                    labelText: '规格值',
                    hintText: '多个值用逗号分隔，如：红,蓝,绿',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                
                const SizedBox(height: 8),
                
                // 预览标签
                if (valuesController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: valuesController.text.split(',')
                          .map((v) => v.trim())
                          .where((v) => v.isNotEmpty)
                          .map((v) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF2F0),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFFF4D4F)),
                            ),
                            child: Text(v, style: const TextStyle(color: Color(0xFFFF4D4F), fontSize: 12)),
                          ))
                          .toList(),
                    ),
                  ),
                
                const SizedBox(height: 12),
                
                Text(
                  '添加后将自动生成SKU组合',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final values = valuesController.text
                    .split(',')
                    .map((v) => v.trim())
                    .where((v) => v.isNotEmpty)
                    .toList();
                
                if (name.isEmpty) {
                  TDToast.showText('请输入规格名称', context: ctx);
                  return;
                }
                
                if (values.isEmpty) {
                  TDToast.showText('请输入至少一个规格值', context: ctx);
                  return;
                }
                
                if (editIndex != null) {
                  _updateAttribute(editIndex, name, values);
                } else {
                  _addAttribute(name, values);
                }
                
                Navigator.pop(ctx);
              },
              child: Text(editIndex != null ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }

  void _addAttribute(String name, List<String> values) {
    setState(() {
      _attributes.add(SpecAttribute(name: name, values: values));
    });
    _notifyChange();
  }

  void _updateAttribute(int index, String name, List<String> values) {
    setState(() {
      _attributes[index] = SpecAttribute(name: name, values: values);
    });
    _notifyChange();
  }

  void _removeAttribute(int index) {
    setState(() {
      _attributes.removeAt(index);
    });
    _notifyChange();
  }

  void _notifyChange() {
    widget.onAttributesChanged(_attributes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 添加按钮
        ElevatedButton.icon(
          onPressed: () => _showAddDialog(null),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('添加规格'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.brandColor8,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        
        const SizedBox(height: 12),
        
        if (_attributes.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgPage,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '暂无规格属性',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          // 规格列表 - 卡片式布局
          ..._attributes.asMap().entries.map((entry) {
            final index = entry.key;
            final attribute = entry.value;
            
            return _buildSpecCard(context, index, attribute);
          }),
      ],
    );
  }

  /// 规格卡片 - 参考图片样式
  Widget _buildSpecCard(BuildContext context, int index, SpecAttribute attribute) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.bgPage,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.view_module, color: AppTheme.brandColor8, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    attribute.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                // 编辑按钮
                GestureDetector(
                  onTap: () => _showAddDialog(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.brandColor1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('编辑', style: TextStyle(color: AppTheme.brandColor8, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                // 删除按钮
                GestureDetector(
                  onTap: () => _removeAttribute(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('删除', style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          
          // 规格值标签区域
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: attribute.values.map((v) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F0),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFFF4D4F)),
                ),
                child: Text(v, style: const TextStyle(color: Color(0xFFFF4D4F), fontSize: 12)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}