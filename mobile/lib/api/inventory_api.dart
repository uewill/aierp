/// 库存相关 API
import 'api_client.dart';

/// 库存 API 服务
class InventoryApi {
  final ApiClient _client = ApiClient();
  
  /// 获取库存分页列表
  Future<InventoryPageResult> getInventoryPage({
    int page = 1,
    int size = 20,
    int? warehouseId,
    int? productId,
    String? keyword,
  }) async {
    final response = await _client.get('/api/inventory/stock/page', queryParameters: {
      'pageNum': page,
      'pageSize': size,
      if (warehouseId != null) 'warehouseId': warehouseId,
      if (productId != null) 'productId': productId,
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
    });
    
    if (response.isSuccess && response.data != null) {
      return InventoryPageResult.fromJson(response.data as Map<String, dynamic>);
    }
    
    // 网络失败时返回空数据
    return InventoryPageResult.empty();
  }
}

/// 库存分页结果
class InventoryPageResult {
  final List<InventoryItem> records;
  final int total;
  final int size;
  final int current;
  final int pages;
  
  InventoryPageResult({
    required this.records,
    required this.total,
    required this.size,
    required this.current,
    this.pages = 0,
  });
  
  factory InventoryPageResult.fromJson(Map<String, dynamic> json) {
    return InventoryPageResult(
      records: (json['records'] as List?)
          ?.map((e) => InventoryItem.fromJson(e))
          .toList() ?? [],
      total: json['total'] as int? ?? 0,
      size: json['size'] as int? ?? 20,
      current: json['current'] as int? ?? 1,
      pages: json['pages'] as int? ?? 0,
    );
  }
  
  factory InventoryPageResult.empty() => InventoryPageResult(
    records: [],
    total: 0,
    size: 20,
    current: 1,
    pages: 0,
  );
  
  bool get hasMore => current < pages;
}

/// 库存项（从后端返回的结构）
class InventoryItem {
  final int id;
  final int productId;
  final String productName;
  final int? productSkuId;
  final String? skuName;
  final int warehouseId;
  final String warehouseName;
  final double quantity;
  final double availableQuantity;
  
  InventoryItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productSkuId,
    this.skuName,
    required this.warehouseId,
    required this.warehouseName,
    required this.quantity,
    required this.availableQuantity,
  });
  
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as int? ?? 0,
      productId: json['productId'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      productSkuId: json['productSkuId'] as int?,
      skuName: json['skuName'] as String?,
      warehouseId: json['warehouseId'] as int? ?? 0,
      warehouseName: json['warehouseName'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      availableQuantity: (json['availableQuantity'] as num?)?.toDouble() ?? 0,
    );
  }
}