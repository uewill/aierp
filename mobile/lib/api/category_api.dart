import 'api_client.dart';

/// 商品分类API
class CategoryApi {
  final ApiClient _client = ApiClient();

  /// 获取分类树
  Future<List<Map<String, dynamic>>> getCategoryTree() async {
    final response = await _client.get('/api/basic/category/tree');
    
    if (response.isSuccess && response.data != null) {
      // ApiResponse 已提取 data 字段
      final data = response.data;
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    
    // 请求失败时返回空列表（移除了模拟数据）
    return [];
  }

  /// 创建分类
  Future<Map<String, dynamic>?> createCategory(Map<String, dynamic> data) async {
    final response = await _client.post('/api/basic/category', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 更新分类
  Future<Map<String, dynamic>?> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await _client.put('/api/basic/category/$id', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 删除分类
  Future<bool> deleteCategory(int id) async {
    final response = await _client.delete('/api/basic/category/$id');
    return response.isSuccess;
  }
}