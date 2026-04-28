import 'api_client.dart';

/// 销售单API
class SalesApi {
  final ApiClient _client = ApiClient();

  /// 获取销售单列表（分页）
  Future<Map<String, dynamic>> getSalesOrderList({
    int page = 1,
    int pageSize = 20,
    String? orderNo,
    int? status,
  }) async {
    final response = await _client.get('/api/sales/order/page', queryParameters: {
      'pageNum': page,
      'pageSize': pageSize,
      if (orderNo != null) 'orderNo': orderNo,
      if (status != null) 'status': status,
    });
    
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    
    return {
      'records': [],
      'total': 0,
      'size': pageSize,
      'current': page,
      'pages': 0,
    };
  }

  /// 获取销售单详情
  Future<Map<String, dynamic>?> getSalesOrder(int id) async {
    final response = await _client.get('/api/sales/order/$id');
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 创建销售单
  Future<Map<String, dynamic>?> createSalesOrder(Map<String, dynamic> data) async {
    final response = await _client.post('/api/sales/order', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  /// 审核销售单
  Future<bool> approveSalesOrder(int id) async {
    final response = await _client.post('/api/sales/order/$id/approve');
    return response.isSuccess;
  }

  /// 取消销售单
  Future<bool> cancelSalesOrder(int id) async {
    final response = await _client.post('/api/sales/order/$id/cancel');
    return response.isSuccess;
  }
}