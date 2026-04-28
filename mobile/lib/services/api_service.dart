import 'package:dio/dio.dart';

/// API 服务
class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://42.193.169.78:8090/api', // 后端地址
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  /// 发送验证码
  static Future<Map<String, dynamic>> sendCode(String phone) async {
    final response = await _dio.post('/auth/send-code', data: {'phone': phone});
    return response.data;
  }
  
  /// 手机号登录
  static Future<Map<String, dynamic>> login(String phone, String code) async {
    final response = await _dio.post('/auth/login', data: {'phone': phone, 'code': code});
    return response.data;
  }
  
  /// AI 文字解析订单
  static Future<Map<String, dynamic>> aiTextInput(String content, String? orderType) async {
    final response = await _dio.post('/ai/text-input', data: {
      'content': content,
      'orderType': orderType,
    });
    return response.data;
  }
  
  /// 确认订单草稿
  static Future<Map<String, dynamic>> confirmDraft(int draftId) async {
    final response = await _dio.post('/ai/draft/$draftId/confirm');
    return response.data;
  }
  
  /// 获取商品列表
  static Future<Map<String, dynamic>> getProductList() async {
    final response = await _dio.get('/business/product/list');
    return response.data;
  }
  
  /// 获取销售单列表
  static Future<Map<String, dynamic>> getSalesOrderPage(int pageNum, int pageSize) async {
    final response = await _dio.get('/business/sales-order/page', 
      queryParameters: {'pageNum': pageNum, 'pageSize': pageSize});
    return response.data;
  }
}