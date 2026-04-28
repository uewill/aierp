import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 商品列表页面 - 移动端优先设计
/// 支持下拉刷新、加载更多、搜索筛选

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryId;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productProvider = context.read<ProductProvider>();
    await productProvider.loadProducts();
    
    final categoryProvider = context.read<CategoryProvider>();
    await categoryProvider.loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('商品管理'),
        backgroundColor: AppTheme.brandColor7,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildCategoryFilter(context),
          Expanded(child: _buildProductList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/products/create'),
        backgroundColor: AppTheme.brandColor7,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 搜索栏
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索商品名称/条码',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: (keyword) {
          context.read<ProductProvider>().loadProducts(
            categoryId: _selectedCategoryId,
            keyword: keyword,
          );
        },
      ),
    );
  }

  /// 分类筛选 - 标签形式（参考图片样式）
  Widget _buildCategoryFilter(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return const SizedBox(height: 48, child: Center(child: CircularProgressIndicator()));
        }

        final categories = categoryProvider.categories.where((c) => c.level == 1).toList();
        
        return Container(
          height: 48,
          margin: const EdgeInsets.only(left: 16, bottom: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterTag(context, '全部', _selectedCategoryId == null, () {
                  setState(() => _selectedCategoryId = null);
                  context.read<ProductProvider>().loadProducts(keyword: _searchController.text);
                }),
                const SizedBox(width: 8),
                ...categories.map((c) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterTag(
                    context, 
                    c.name, 
                    _selectedCategoryId == c.id, 
                    () {
                      setState(() => _selectedCategoryId = c.id);
                      context.read<ProductProvider>().loadProducts(
                        categoryId: c.id,
                        keyword: _searchController.text,
                      );
                    },
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 筛选标签 - 参考图片样式
  Widget _buildFilterTag(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.brandColor8 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// 商品列表
  Widget _buildProductList(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading && productProvider.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.products.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () async => await productProvider.loadProducts(
            categoryId: _selectedCategoryId,
            keyword: _searchController.text,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return _buildProductItem(context, product);
            },
          ),
        );
      },
    );
  }

  /// 商品卡片 - 参考图片样式
  Widget _buildProductItem(BuildContext context, Product product) {
    final categoryProvider = context.read<CategoryProvider>();
    final categoryName = product.getCategoryName(categoryProvider.categories);
    
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/products/detail', arguments: product.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品图标
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.brandColor1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.inventory_2, color: AppTheme.brandColor8, size: 32),
              ),
              const SizedBox(width: 12),
              // 商品信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 商品名称 + 标签
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (product.hasSpec) 
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF2F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('多规格', style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 11)),
                          ),
                        if (product.units != null && product.units!.length > 1)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.brandColor1,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('多单位', style: TextStyle(color: AppTheme.brandColor8, fontSize: 11)),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // 分类名称
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(categoryName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 价格行
                    Row(
                      children: [
                        Text('¥${product.price.toStringAsFixed(2)}', 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFFF4D4F))),
                        const SizedBox(width: 12),
                        Text('成本 ¥${product.costPrice.toStringAsFixed(2)}', 
                          style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 库存信息
                    Row(
                      children: [
                        Icon(Icons.inventory, color: Colors.grey.shade500, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '库存: 0', // TODO: 后端API需要返回库存数量
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 操作按钮
              Column(
                children: [
                  // 编辑按钮
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/products/edit', arguments: product.id),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.brandColor1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.edit_outlined, color: AppTheme.brandColor8, size: 18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 删除按钮
                  GestureDetector(
                    onTap: () => _showDeleteConfirm(context, product),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline, color: Color(0xFFFF4D4F), size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('暂无商品数据', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 24),
          TDButton(
            text: '添加商品',
            theme: TDButtonTheme.primary,
            size: TDButtonSize.large,
            onTap: () => Navigator.pushNamed(context, '/products/create'),
          ),
        ],
      ),
    );
  }

  /// 删除确认
  void _showDeleteConfirm(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('是否删除商品「${product.name}」？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await context.read<ProductProvider>().deleteProduct(product.id);
              if (result) {
                TDToast.showSuccess('删除成功', context: context);
              }
            },
            child: const Text('删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }
}