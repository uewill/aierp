import 'api_client.dart';

/// 公司API
class CompanyApi {
  final ApiClient _client = ApiClient();

  /// 获取公司列表（分页）
  Future<Map<String, dynamic>> getCompanyList({
    int page = 1,
    int pageSize = 20,
    String? keyword,
  }) async {
    final response = await _client.get('/api/company/page', queryParameters: {
      'pageNum': page,
      'pageSize': pageSize,
      if (keyword != null) 'keyword': keyword,
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

  /// 创建公司
  Future<Map<String, dynamic>?> createCompany(Map<String, dynamic> data) async {
    final response = await _client.post('/api/company', data: data);
    if (response.isSuccess && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }
}