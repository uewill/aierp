import 'api_client.dart';

/// 商品API
class ProductApi {
  final ApiClient _client = ApiClient();

  /// 获取商品列表（分页）
  Future<Map<String, dynamic>> getProductList({
    int page = 1,
    int pageSize = 20,
    String? keyword,
    int? categoryId,
  }) async {
    final response = await _client.get('/api/basic/product/page', queryParameters: {
      'pageNum': page,
      'pageSize': pageSize,
      if (keyword != null) 'keyword': keyword,
      if (categoryId != null) 'categoryId': categoryId,
    });
    
    // 返回分页数据，包含 records, total, size, current, pages
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    // 返回空分页结构
    return {
      'records': [],
      'total': 0,
      'size': pageSize,
      'current': page,
      'pages': 0,
    };
  }

  /// 获取商品详情
  Future<Map<String, dynamic>?> getProduct(int id) async {
    final response = await _client.get('/api/basic/product/$id');
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 创建商品
  Future<Map<String, dynamic>?> createProduct(Map<String, dynamic> data) async {
    final response = await _client.post('/api/basic/product', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 更新商品
  Future<Map<String, dynamic>?> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await _client.put('/api/basic/product/$id', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  
  /// 删除商品
  Future<bool> deleteProduct(int id) async {
    final response = await _client.delete('/api/basic/product/$id');
    return response.isSuccess;
  }

  /// 获取商品分类树
  Future<List<Map<String, dynamic>>> getCategoryTree() async {
    final response = await _client.get('/api/basic/category/tree');
    if (response.isSuccess && response.data != null) {
      // 后端返回 {data: [...]}，ApiResponse 已提取 data 字段
      final data = response.data;
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }
}