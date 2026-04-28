import 'package:flutter/material.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';
import 'package:aierp_mobile/models/category.dart';

/// 商品分类创建/编辑页面
class CategoryEditPage extends StatefulWidget {
  final Category? category;
  
  const CategoryEditPage({super.key, this.category});

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _parentIdController = TextEditingController();
  
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.category != null;
    if (_isEditMode) {
      _nameController.text = widget.category!.name;
      _codeController.text = widget.category!.code;
      _parentIdController.text = widget.category!.parentId?.toString() ?? '0';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _parentIdController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_nameController.text.isEmpty || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写完整的分类信息')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // 模拟保存操作
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _isLoading = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditMode ? '分类更新成功' : '分类创建成功')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? '编辑分类' : '新建分类'),
        backgroundColor: AppTheme.brandColor,
        foregroundColor: Colors.white,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveCategory,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('分类名称 *', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: '请输入分类名称',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('分类编码 *', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      hintText: '请输入分类编码',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('父级分类ID', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _parentIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0表示顶级分类',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  if (!_isEditMode)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('说明:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text(
                              '• 分类编码建议使用英文或数字组合\n'
                              '• 父级分类ID为0时表示顶级分类\n'
                              '• 同一级别下分类编码不能重复',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}