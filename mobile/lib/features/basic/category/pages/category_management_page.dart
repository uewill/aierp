import 'package:flutter/material.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';
import 'package:aierp_mobile/models/category.dart';
import 'package:aierp_mobile/features/basic/category/pages/category_edit_page.dart';

/// 商品分类管理页面
class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  List<Category> _categories = [];
  bool _isLoading = false;
  
  // 模拟数据 - 扁平结构
  final List<Category> _mockCategories = [
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    
    // 模拟网络请求延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _categories = _mockCategories;
      _isLoading = false;
    });
  }

  void _createCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryEditPage(),
      ),
    ).then((_) {
      _loadCategories(); // 刷新列表
    });
  }

  void _editCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryEditPage(category: category),
      ),
    ).then((_) {
      _loadCategories(); // 刷新列表
    });
  }

  Future<void> _deleteCategory(Category category) async {
    // 显示确认对话框
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除分类 "${category.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      // 模拟删除操作
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('分类删除成功')),
        );
        _loadCategories();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品分类管理'),
        backgroundColor: AppTheme.brandColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createCategory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCategoryList(),
    );
  }

  Widget _buildCategoryList() {
    // 分组显示：一级分类和其子分类
    final topLevelCategories = _categories.where((cat) => cat.parentId == null).toList();
    
    return ListView.builder(
      itemCount: topLevelCategories.length,
      itemBuilder: (context, index) {
        final topLevel = topLevelCategories[index];
        final children = _categories
            .where((cat) => cat.parentId == topLevel.id)
            .toList();
            
        return Column(
          children: [
            _buildCategoryItem(topLevel, isTopLevel: true),
            if (children.isNotEmpty)
              Column(
                children: children.map((child) => _buildCategoryItem(child)).toList(),
              ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }

  Widget _buildCategoryItem(Category category, {bool isTopLevel = false}) {
    final indent = isTopLevel ? 0.0 : 24.0;
    
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.brandColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.category,
          color: AppTheme.brandColor,
          size: 20,
        ),
      ),
      title: Text(
        category.name ?? '',
        style: TextStyle(
          fontWeight: isTopLevel ? FontWeight.bold : FontWeight.normal,
          fontSize: isTopLevel ? 16 : 14,
        ),
      ),
      subtitle: Text('编码: ${category.code ?? ''}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _editCategory(category),
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18),
            onPressed: () => _deleteCategory(category),
            padding: EdgeInsets.zero,
            color: Colors.red,
          ),
        ],
      ),
      contentPadding: EdgeInsets.only(left: 16 + indent, right: 16),
    );
  }
}