import 'package:equatable/equatable.dart';
import 'unit_conversion.dart';
import 'product_sku.dart';

/// 商品模型
class Product extends Equatable {
  final int? id;
  final String name; // 商品名称
  final String? code; // 商品编码
  final String? specification; // 基础规格型号
  final String? baseUnit; // 基础单位
  final double? purchasePrice; // 进价
  final double? retailPrice; // 零售价
  final double? wholesalePrice; // 批发价
  final int? categoryId; // 分类ID
  final String? categoryName; // 分类名称
  final String? barcode; // 条形码
  final String? description; // 描述
  final bool? enabled; // 是否启用
  final DateTime? createTime; // 创建时间
  final DateTime? updateTime; // 更新时间
  
  // 新增字段：多单位换算
  final List<UnitConversion> unitConversions;
  
  // 新增字段：SKU 规格列表
  final List<ProductSku> skus;

  const Product({
    this.id,
    required this.name,
    this.code,
    this.specification,
    this.baseUnit,
    this.purchasePrice,
    this.retailPrice,
    this.wholesalePrice,
    this.categoryId,
    this.categoryName,
    this.barcode,
    this.description,
    this.enabled = true,
    this.createTime,
    this.updateTime,
    this.unitConversions = const [],
    this.skus = const [],
  });

  /// 从JSON创建商品实例
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
      specification: json['specification'] as String?,
      baseUnit: json['baseUnit'] as String?,
      purchasePrice: json['purchasePrice'] as double?,
      retailPrice: json['retailPrice'] as double?,
      wholesalePrice: json['wholesalePrice'] as double?,
      categoryId: json['categoryId'] as int?,
      categoryName: json['categoryName'] as String?,
      barcode: json['barcode'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool?,
      createTime: json['createTime'] != null 
          ? DateTime.parse(json['createTime'] as String) 
          : null,
      updateTime: json['updateTime'] != null 
          ? DateTime.parse(json['updateTime'] as String) 
          : null,
      unitConversions: (json['unitConversions'] as List?)
          ?.map((e) => UnitConversion.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      skus: (json['skus'] as List?)
          ?.map((e) => ProductSku.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (code != null) 'code': code,
      if (specification != null) 'specification': specification,
      if (baseUnit != null) 'baseUnit': baseUnit,
      if (purchasePrice != null) 'purchasePrice': purchasePrice,
      if (retailPrice != null) 'retailPrice': retailPrice,
      if (wholesalePrice != null) 'wholesalePrice': wholesalePrice,
      if (categoryId != null) 'categoryId': categoryId,
      if (barcode != null) 'barcode': barcode,
      if (description != null) 'description': description,
      if (enabled != null) 'enabled': enabled,
      'unitConversions': unitConversions.map((e) => e.toJson()).toList(),
      'skus': skus.map((e) => e.toJson()).toList(),
    };
  }

  /// 创建空商品实例（用于新建）
  static Product empty() {
    return const Product(name: '');
  }

  /// 复制并更新部分字段
  Product copyWith({
    int? id,
    String? name,
    String? code,
    String? specification,
    String? baseUnit,
    double? purchasePrice,
    double? retailPrice,
    double? wholesalePrice,
    int? categoryId,
    String? categoryName,
    String? barcode,
    String? description,
    bool? enabled,
    DateTime? createTime,
    DateTime? updateTime,
    List<UnitConversion>? unitConversions,
    List<ProductSku>? skus,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      specification: specification ?? this.specification,
      baseUnit: baseUnit ?? this.baseUnit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      retailPrice: retailPrice ?? this.retailPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      unitConversions: unitConversions ?? this.unitConversions,
      skus: skus ?? this.skus,
    );
  }

  /// 获取基础单位（别名）
  String? get unit => baseUnit;
  
  /// 获取零售价（别名）
  double? get salePrice => retailPrice;
  
  @override
  List<Object?> get props => [
        id,
        name,
        code,
        specification,
        baseUnit,
        purchasePrice,
        retailPrice,
        wholesalePrice,
        categoryId,
        categoryName,
        barcode,
        description,
        enabled,
        createTime,
        updateTime,
        unitConversions,
        skus,
      ];
}