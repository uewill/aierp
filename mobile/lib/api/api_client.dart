import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API 客户端 - 真实HTTP调用实现
/// 
/// 使用方式:
/// ```dart
/// final client = ApiClient();
/// final response = await client.get('/api/xxx');
/// ```
/// 
/// Token管理:
/// - 登录后调用 saveToken() 保存token
/// - 之后所有请求自动携带 Authorization: Bearer {token}
/// - 401响应时自动清除token
class ApiClient {
  static const String baseUrl = 'http://42.193.169.78:8090/api';
  static const String _tokenKey = 'auth_token';
  
  // 单例Dio实例
  static Dio? _dio;
  static SharedPreferences? _prefs;
  static bool _initialized = false;
  
  /// 确保初始化完成
  Future<void> _ensureInitialized() async {
    if (_initialized && _dio != null) return;
    
    _prefs = await SharedPreferences.getInstance();
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // 添加拦截器
    _dio!.interceptors.clear();
    _dio!.interceptors.add(AuthInterceptor());
    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    
    _initialized = true;
  }
  
  /// 获取当前Token
  String? get token => _prefs?.getString(_tokenKey);
  
  /// 保存Token（别名，供 AuthApi 使用）
  Future<void> setToken(String token) async {
    await saveToken(token);
  }
  
  /// 保存Token
  Future<void> saveToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_tokenKey, token);
  }
  
  /// 清除Token（登出）
  Future<void> clearToken() async {
    await _ensureInitialized();
    await _prefs!.remove(_tokenKey);
  }
  
  /// 检查是否已登录
  bool get isLoggedIn => token != null && token!.isNotEmpty;
  
  /// 检查本地是否有 Token（异步方法，供 AuthApi 使用）
  Future<bool> hasToken() async {
    await _ensureInitialized();
    return isLoggedIn;
  }
  
  /// 获取本地存储的 Token（异步方法，供 AuthApi 使用）
  Future<String?> getToken() async {
    await _ensureInitialized();
    return token;
  }
  
  /// GET 请求
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    try {
      final response = await _dio!.get(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        data: null,
        error: '请求失败: ${e.toString()}',
      );
    }
  }
  
  /// POST 请求
  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    await _ensureInitialized();
    try {
      final response = await _dio!.post(
        path,
        data: data,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        data: null,
        error: '请求失败: ${e.toString()}',
      );
    }
  }
  
  /// PUT 请求
  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    await _ensureInitialized();
    try {
      final response = await _dio!.put(
        path,
        data: data,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        data: null,
        error: '请求失败: ${e.toString()}',
      );
    }
  }
  
  /// DELETE 请求
  Future<ApiResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    try {
      final response = await _dio!.delete(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        data: null,
        error: '请求失败: ${e.toString()}',
      );
    }
  }
  
  /// 处理成功响应
  ApiResponse _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      
      // 处理后端统一响应格式 {"code": 200, "message": "success", "data": {...}}
      if (data is Map<String, dynamic>) {
        final code = data['code'] as int?;
        final message = data['message'] as String?;
        final responseData = data['data'];
        
        if (code == 200) {
          return ApiResponse(
            data: responseData,
            message: message,
          );
        } else {
          return ApiResponse(
            data: null,
            error: message ?? '请求失败',
            code: code,
          );
        }
      }
      
      return ApiResponse(data: data);
    } else {
      return ApiResponse(
        data: null,
        error: 'HTTP错误: ${response.statusCode}',
        code: response.statusCode,
      );
    }
  }
  
  /// 处理Dio错误
  ApiResponse _handleDioError(DioException e) {
    String errorMessage;
    int? errorCode;
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = '网络连接超时，请检查网络';
        break;
      case DioExceptionType.badResponse:
        final response = e.response;
        if (response != null) {
          errorCode = response.statusCode;
          final data = response.data;
          
          // 尝试解析错误信息
          if (data is Map<String, dynamic>) {
            errorMessage = data['message'] as String? ?? '服务器错误';
            errorCode = data['code'] as int? ?? errorCode;
          } else {
            errorMessage = '服务器错误: ${response.statusCode}';
          }
          
          // 401 未授权 - Token过期或无效
          if (response.statusCode == 401) {
            errorMessage = '登录已过期，请重新登录';
            // 清除本地Token
            clearToken();
          }
        } else {
          errorMessage = '网络请求失败';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = '请求已取消';
        break;
      case DioExceptionType.connectionError:
        errorMessage = '网络连接失败，请检查网络设置';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = '证书验证失败';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = '请求失败: ${e.message}';
    }
    
    return ApiResponse(
      data: null,
      error: errorMessage,
      code: errorCode,
    );
  }
  
  /// 获取原始Dio实例（用于特殊场景）
  Dio get dio {
    _ensureInitialized();
    return _dio!;
  }
  
  /// 重置客户端（用于测试或强制重新初始化）
  static void reset() {
    _dio = null;
    _prefs = null;
    _initialized = false;
  }
}

/// 认证拦截器 - 自动添加Authorization头
class AuthInterceptor extends Interceptor {
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // 添加Token到请求头
    final token = ApiClient._prefs?.getString(ApiClient._tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 处理401错误 - Token过期
    if (err.response?.statusCode == 401) {
      // 异步清除Token
      ApiClient._prefs?.remove(ApiClient._tokenKey);
    }
    handler.next(err);
  }
}

/// API 响应包装类
class ApiResponse {
  final dynamic data;
  final String? error;
  final int? code;
  final String? message;
  final int statusCode;
  final bool success;
  
  ApiResponse({
    required this.data,
    this.error,
    this.code,
    this.message,
    this.statusCode = 200,
    this.success = true,
  });
  
  /// 是否成功
  bool get isSuccess => error == null && (code == null || code == 200);
  
  /// 获取错误消息（供 AuthApi 使用）
  String? getError() {
    if (isSuccess) return null;
    if (error != null) return error;
    if (message != null) return message;
    if (data is Map && data['error'] != null) return data['error'].toString();
    if (data is Map && data['message'] != null) return data['message'].toString();
    return '请求失败';
  }
  
  /// 获取分页数据
  /// 后端分页格式: {"records": [...], "total": 100, "size": 20, "current": 1, "pages": 5}
  PaginatedData? get paginatedData {
    if (data == null || data is! Map<String, dynamic>) return null;
    
    final map = data as Map<String, dynamic>;
    if (!map.containsKey('records')) return null;
    
    return PaginatedData(
      records: map['records'] as List<dynamic>? ?? [],
      total: (map['total'] as num?)?.toInt() ?? 0,
      size: (map['size'] as num?)?.toInt() ?? 20,
      current: (map['current'] as num?)?.toInt() ?? 1,
      pages: (map['pages'] as num?)?.toInt() ?? 1,
    );
  }
  
  /// 获取数据列表
  List<dynamic>? get dataList {
    if (data == null) return null;
    if (data is List<dynamic>) return data;
    if (data is Map<String, dynamic>) {
      return data['records'] as List<dynamic>?;
    }
    return null;
  }
  
  @override
  String toString() {
    return 'ApiResponse(data: $data, error: $error, code: $code, message: $message)';
  }
}

/// 分页数据
class PaginatedData {
  final List<dynamic> records;
  final int total;
  final int size;
  final int current;
  final int pages;
  
  PaginatedData({
    required this.records,
    required this.total,
    required this.size,
    required this.current,
    required this.pages,
  });
  
  /// 是否有下一页
  bool get hasNextPage => current < pages;
  
  /// 是否有上一页
  bool get hasPreviousPage => current > 1;
  
  /// 是否为空
  bool get isEmpty => records.isEmpty;
  
  /// 是否不为空
  bool get isNotEmpty => records.isNotEmpty;
  
  @override
  String toString() {
    return 'PaginatedData(total: $total, current: $current/$pages, records: ${records.length})';
  }
}