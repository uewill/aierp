import 'api_client.dart';

/// 往来单位API（客户/供应商）
class PartnerApi {
  final ApiClient _client = ApiClient();

  /// 获取客户列表
  Future<List<Map<String, dynamic>>> getCustomerList({String? keyword}) async {
    final response = await _client.get('/api/basic/partner', queryParameters: {
      'type': 'customer',
      if (keyword != null) 'keyword': keyword,
    });
    
    if (response.isSuccess && response.data != null) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// 获取供应商列表
  Future<List<Map<String, dynamic>>> getSupplierList({String? keyword}) async {
    final response = await _client.get('/api/basic/partner', queryParameters: {
      'type': 'supplier',
      if (keyword != null) 'keyword': keyword,
    });
    
    if (response.isSuccess && response.data != null) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// 获取往来单位详情
  Future<Map<String, dynamic>?> getPartner(int id) async {
    final response = await _client.get('/api/basic/partner/$id');
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 创建往来单位
  Future<Map<String, dynamic>?> createPartner(Map<String, dynamic> data) async {
    final response = await _client.post('/api/basic/partner', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 更新往来单位
  Future<Map<String, dynamic>?> updatePartner(int id, Map<String, dynamic> data) async {
    final response = await _client.put('/api/basic/partner/$id', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 删除往来单位
  Future<bool> deletePartner(int id) async {
    final response = await _client.delete('/api/basic/partner/$id');
    return response.isSuccess;
  }
}