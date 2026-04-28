import 'package:flutter/material.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';
import 'package:aierp_mobile/models/product.dart';

/// 商品库存页面
class ProductInventoryPage extends StatefulWidget {
  final String productId;
  
  const ProductInventoryPage({super.key, required this.productId});

  @override
  State<ProductInventoryPage> createState() => _ProductInventoryPageState();
}

class _ProductInventoryPageState extends State<ProductInventoryPage> {
  late Product _product;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
    });
    
    // 模拟加载商品数据
    await Future.delayed(const Duration(milliseconds: 500));
    
    _product = Product(
      id: int.parse(widget.productId),
      name: '可口可乐',
      code: 'KKKL001',
      specification: '500ml',
      baseUnit: '瓶',
      retailPrice: 3.0,
      purchasePrice: 2.0,
      barcode: '6921234567890',
      description: '经典碳酸饮料',
      categoryId: 1,
      categoryName: '饮料',
    );
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品库存'),
        backgroundColor: AppTheme.brandColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品基本信息卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('商品名称', _product.name),
                      _buildInfoRow('商品编码', _product.code ?? ''),
                      _buildInfoRow('规格', _product.specification ?? ''),
                      _buildInfoRow('单位', _product.baseUnit ?? ''),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 库存信息卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('当前库存', '50 ${_product.baseUnit ?? ''}'),
                      _buildInfoRow('安全库存', '10 ${_product.baseUnit ?? ''}'),
                      _buildInfoRow('最大库存', '100 ${_product.baseUnit ?? ''}'),
                      _buildInfoRow('库存状态', '正常', color: Colors.green),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 库存操作按钮
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 入库操作
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('入库'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 出库操作
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('出库'),
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

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(color: color ?? Colors.black),
          ),
        ],
      ),
    );
  }
}