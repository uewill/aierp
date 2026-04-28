import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 商品详情页面
/// 展示商品完整信息

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:aierp_mobile/data/services/data_service.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    if (productId == null) {
      Navigator.pop(context);
      return;
    }

    _product = await dataService.getProduct(productId);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('商品详情'),
          backgroundColor: AppTheme.brandColor7,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('商品详情')),
        body: Center(child: Text('商品不存在', style: TextStyle(color: Colors.grey[600]))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(_product!.name),
        backgroundColor: AppTheme.brandColor7,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/products/edit', arguments: _product!.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfo(context),
            const SizedBox(height: 16),
            _buildPriceInfo(context),
            if (_product!.hasSpec && _product!.skus != null) ...[
              const SizedBox(height: 16),
              _buildSkuList(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return _buildSectionCard('基本信息', [
      TDCell(title: '商品名称', note: _product!.name),
      TDCell(title: '条码', note: _product!.barCode ?? '-'),
      TDCell(title: '品牌', note: _product!.brand ?? '-'),
      TDCell(title: '描述', note: _product!.description ?? '-'),
    ]);
  }

  Widget _buildPriceInfo(BuildContext context) {
    return _buildSectionCard('价格信息', [
      TDCell(
        title: '售价',
        note: '¥${_product!.price.toStringAsFixed(2)}',
      ),
      TDCell(title: '成本价', note: '¥${_product!.costPrice.toStringAsFixed(2)}'),
    ]);
  }

  Widget _buildSkuList(BuildContext context) {
    return _buildSectionCard('规格列表', [
      ..._product!.skus!.map((sku) => TDCell(
        title: sku.specName,
        note: '¥${sku.price.toStringAsFixed(2)}',
      )),
    ]);
  }
}