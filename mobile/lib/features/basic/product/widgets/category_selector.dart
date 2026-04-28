import 'package:flutter/material.dart';
import 'package:aierp_mobile/models/category.dart';

/// 商品分类选择组件
class CategorySelector extends StatefulWidget {
  final int? selectedCategoryId;
  final ValueChanged<int?>? onCategorySelected;
  
  const CategorySelector({
    super.key,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<Category> _categories = [];
  bool _isLoading = false;
  String _selectedCategoryName = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    
    // 模拟数据 - 扁平结构
    await Future.delayed(const Duration(milliseconds: 300));
    
    final mockCategories = [
      Category(
        id: 1,
        name: '饮料',
        code: 'YL',
        parentId: null,
        level: 1,
        hasChildren: true,
        createdAt: DateTime.now(),
      ),
      Category(
        id: 3,
        name: '碳酸饮料',
        code: 'TQYL',
        parentId: 1,
        level: 2,
        hasChildren: false,
        createdAt: DateTime.now(),
      ),
      Category(
        id: 4,
        name: '果汁饮料',
        code: 'GZYL',
        parentId: 1,
        level: 2,
        hasChildren: false,
        createdAt: DateTime.now(),
      ),
      Category(
        id: 2,
        name: '方便食品',
        code: 'FFSP',
        parentId: null,
        level: 1,
        hasChildren: true,
        createdAt: DateTime.now(),
      ),
      Category(
        id: 5,
        name: '方便面',
        code: 'FFM',
        parentId: 2,
        level: 2,
        hasChildren: false,
        createdAt: DateTime.now(),
      ),
      Category(
        id: 6,
        name: '速食米饭',
        code: 'SSMF',
        parentId: 2,
        level: 2,
        hasChildren: false,
        createdAt: DateTime.now(),
      ),
    ];
    
    setState(() {
      _categories = mockCategories;
      _isLoading = false;
      
      // 设置已选分类名称
      if (widget.selectedCategoryId != null) {
        final selected = mockCategories.firstWhere(
          (cat) => cat.id == widget.selectedCategoryId!,
          orElse: () => mockCategories[0],
        );
        _selectedCategoryName = selected.name ?? '';
      }
    });
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择商品分类'),
          content: SizedBox(
            width: 300,
            height: 400,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildCategoryList(_categories),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    final topLevelCategories = categories.where((cat) => cat.parentId == null).toList();
    
    return ListView.builder(
      itemCount: topLevelCategories.length,
      itemBuilder: (context, index) {
        final category = topLevelCategories[index];
        final children = categories
            .where((cat) => cat.parentId == category.id)
            .toList();
            
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(category.name ?? ''),
              onTap: () {
                setState(() {
                  _selectedCategoryName = category.name ?? '';
                });
                widget.onCategorySelected?.call(category.id);
                Navigator.pop(context);
              },
            ),
            if (children.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: children.map((child) {
                    return ListTile(
                      title: Text(child.name ?? ''),
                      onTap: () {
                        setState(() {
                          _selectedCategoryName = child.name ?? '';
                        });
                        widget.onCategorySelected?.call(child.id);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('商品分类 *', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showCategoryDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedCategoryName.isEmpty 
                        ? '请选择商品分类' 
                        : _selectedCategoryName,
                    style: TextStyle(
                      color: _selectedCategoryName.isEmpty 
                          ? Colors.grey 
                          : Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}