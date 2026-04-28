import 'api_client.dart';

/// 仓库API
class WarehouseApi {
  final ApiClient _client = ApiClient();

  /// 获取仓库列表
  Future<List<Map<String, dynamic>>> getWarehouseList() async {
    final response = await _client.get('/api/basic/warehouse');
    
    if (response.isSuccess && response.data != null) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// 获取仓库详情
  Future<Map<String, dynamic>?> getWarehouse(int id) async {
    final response = await _client.get('/api/basic/warehouse/$id');
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 创建仓库
  Future<Map<String, dynamic>?> createWarehouse(Map<String, dynamic> data) async {
    final response = await _client.post('/api/basic/warehouse', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 更新仓库
  Future<Map<String, dynamic>?> updateWarehouse(int id, Map<String, dynamic> data) async {
    final response = await _client.put('/api/basic/warehouse/$id', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 删除仓库
  Future<bool> deleteWarehouse(int id) async {
    final response = await _client.delete('/api/basic/warehouse/$id');
    return response.isSuccess;
  }
}