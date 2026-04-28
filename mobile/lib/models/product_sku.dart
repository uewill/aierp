import 'package:equatable/equatable.dart';

/// 商品SKU模型 - 规格型号的具体实例
class ProductSku extends Equatable {
  final String skuCode; // SKU编码
  final Map<String, String> attributes; // 规格属性值对，如 {'颜色': '红色', '尺寸': 'M'}
  final double? purchasePrice; // 进价
  final double? retailPrice; // 零售价
  final double? wholesalePrice; // 批发价
  final int? stockQuantity; // 库存数量
  
  const ProductSku({
    required this.skuCode,
    required this.attributes,
    this.purchasePrice,
    this.retailPrice,
    this.wholesalePrice,
    this.stockQuantity,
  });

  /// 从JSON创建SKU实例
  factory ProductSku.fromJson(Map<String, dynamic> json) {
    return ProductSku(
      skuCode: json['skuCode'] as String? ?? '',
      attributes: Map<String, String>.from(json['attributes'] as Map),
      purchasePrice: json['purchasePrice'] as double?,
      retailPrice: json['retailPrice'] as double?,
      wholesalePrice: json['wholesalePrice'] as double?,
      stockQuantity: json['stockQuantity'] as int?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'skuCode': skuCode,
      'attributes': attributes,
      if (purchasePrice != null) 'purchasePrice': purchasePrice,
      if (retailPrice != null) 'retailPrice': retailPrice,
      if (wholesalePrice != null) 'wholesalePrice': wholesalePrice,
      if (stockQuantity != null) 'stockQuantity': stockQuantity,
    };
  }

  /// 创建副本并更新指定字段
  ProductSku copyWith({
    String? skuCode,
    Map<String, String>? attributes,
    double? purchasePrice,
    double? retailPrice,
    double? wholesalePrice,
    int? stockQuantity,
  }) {
    return ProductSku(
      skuCode: skuCode ?? this.skuCode,
      attributes: attributes ?? this.attributes,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      retailPrice: retailPrice ?? this.retailPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  @override
  List<Object?> get props => [
        skuCode,
        attributes,
        purchasePrice,
        retailPrice,
        wholesalePrice,
        stockQuantity,
      ];
}