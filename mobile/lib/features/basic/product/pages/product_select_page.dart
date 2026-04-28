/// 商品选择页面 - 用于开单时选择商品
/// 支持搜索、快速选择

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:aierp_mobile/data/mock/mock_data.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

class ProductSelectPage extends StatefulWidget {
  const ProductSelectPage({super.key});

  @override
  State<ProductSelectPage> createState() => _ProductSelectPageState();
}

class _ProductSelectPageState extends State<ProductSelectPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  Product? _selectedProduct;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<ProductProvider>().loadProducts();
    await context.read<InventoryProvider>().loadInventory();
    _filteredProducts = context.read<ProductProvider>().products;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(child: _buildProductList(context)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return TDNavBar(
      title: '选择商品',
      titleFontWeight: FontWeight.w600,
      backgroundColor: AppTheme.brandColor,
      leftBarItems: [
        TDNavBarItem(
          icon: TDIcons.chevron_left,
          action: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TDSearchBar(
        placeHolder: '搜索商品名称/条码',
        controller: _searchController,
        onTextChanged: (keyword) {
          if (keyword.isEmpty) {
            setState(() => _filteredProducts = context.read<ProductProvider>().products);
          } else {
            setState(() {
              _filteredProducts = context.read<ProductProvider>().products.where((p) =>
                p.name.contains(keyword) || (p.barCode?.contains(keyword) ?? false)
              ).toList();
            });
          }
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text('未找到商品', style: TextStyle(fontSize: 16, color: AppTheme.textPlaceholder)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductItem(context, product);
      },
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => product.hasSpec ? _showSkuPicker(context, product) : _selectProduct(context, product, null),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(TDIcons.cart, color: AppTheme.brandColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        Text('¥${product.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.errorColor)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.barCode ?? '',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textPlaceholder),
                    ),
                    if (product.hasSpec) ...[
                      const SizedBox(height: 4),
                      TDTag('多规格', theme: TDTagTheme.primary, size: TDTagSize.small),
                    ],
                  ],
                ),
              ),
              const Icon(TDIcons.chevron_right, color: AppTheme.textPlaceholder),
            ],
          ),
        ),
      ),
    );
  }

  /// 多规格商品选择
  void _showSkuPicker(BuildContext context, Product product) {
    if (product.skus == null || product.skus!.isEmpty) {
      TDToast.showFail('商品规格数据异常', context: context);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(TDIcons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: product.skus!.length,
                itemBuilder: (context, index) {
                  final sku = product.skus![index];
                  return _buildSkuItem(context, product, sku);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkuItem(BuildContext context, Product product, ProductSku sku) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _selectProduct(context, product, sku);
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(TDIcons.cart, color: AppTheme.brandColor, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(sku.specName, style: const TextStyle(fontSize: 14)),
              ),
              Text('¥${sku.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.errorColor)),
            ],
          ),
        ),
      ),
    );
  }

  /// 选择商品返回
  void _selectProduct(BuildContext context, Product product, ProductSku? sku) {
    Navigator.pop(context, {'product': product, 'sku': sku});
  }
}