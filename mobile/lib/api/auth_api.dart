import 'api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 认证API - 真实 HTTP 实现
class AuthApi {
  final ApiClient _client = ApiClient();

  /// 登录
  /// 后端API: POST `/api/auth/login`
  /// 请求体: `{"username": "admin", "password": "123456"}`
  /// 响应: `{"token": "xxx", "user": {"id": 1, "name": "管理员"}}`
  Future<LoginResult> login(String username, String password) async {
    final response = await _client.post('/api/auth/login', data: {
      'username': username,
      'password': password,
    });
    
    if (!response.success) {
      return LoginResult(
        success: false,
        errorMessage: response.getError() ?? '登录失败',
      );
    }
    
    final data = response.data;
    if (data == null) {
      return LoginResult(
        success: false,
        errorMessage: '服务器响应异常',
      );
    }
    
    // 解析响应数据
    final token = data['token']?.toString();
    final userData = data['user'] as Map<String, dynamic>?;
    
    if (token == null || token.isEmpty) {
      return LoginResult(
        success: false,
        errorMessage: '未获取到登录凭证',
      );
    }
    
    // 保存 Token
    await _client.setToken(token);
    
    return LoginResult(
      success: true,
      token: token,
      user: userData != null ? UserInfo.fromJson(userData) : null,
    );
  }

  /// 登出
  Future<bool> logout() async {
    final response = await _client.post('/api/auth/logout');
    // 无论接口是否成功，都清除本地 Token
    await _clearLocalToken();
    return response.success;
  }
  
  /// 清除本地 Token
  Future<void> _clearLocalToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// 获取当前用户信息
  /// API: GET `/api/auth/me`
  Future<UserInfo?> getCurrentUser() async {
    final response = await _client.get('/api/auth/me');
    
    if (!response.success || response.data == null) {
      return null;
    }
    
    return UserInfo.fromJson(response.data);
  }
  
  /// 检查本地是否有 Token（用于自动登录判断）
  Future<bool> hasToken() async {
    return _client.hasToken();
  }
  
  /// 获取本地存储的 Token
  Future<String?> getToken() async {
    return _client.getToken();
  }
}

/// 登录结果
class LoginResult {
  final bool success;
  final String? errorMessage;
  final String? token;
  final UserInfo? user;
  
  LoginResult({
    required this.success,
    this.errorMessage,
    this.token,
    this.user,
  });
}

/// 用户信息
class UserInfo {
  final int id;
  final String name;
  final String? avatar;
  final String? phone;
  final String? role;
  
  UserInfo({
    required this.id,
    required this.name,
    this.avatar,
    this.phone,
    this.role,
  });
  
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      phone: json['phone']?.toString(),
      role: json['role']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'phone': phone,
    'role': role,
  };
}