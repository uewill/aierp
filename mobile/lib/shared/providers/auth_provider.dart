import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aierp_mobile/api/auth_api.dart';
import 'package:aierp_mobile/shared/models/basic_models.dart';

/// 认证状态管理 - 真实 API 实现
class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  
  /// 当前用户
  User? _user;
  
  /// 是否已登录
  bool _isLoggedIn = false;
  
  /// Token
  String? _token;
  
  /// 是否正在登录（用于按钮禁用状态）
  bool _isLoggingIn = false;
  
  /// 登录错误信息
  String? _loginError;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  bool get isLoggingIn => _isLoggingIn;
  String? get loginError => _loginError;

  /// 登录 - 调用真实 API
  /// 参数: username 用户名, password 密码
  Future<bool> login(String username, String password) async {
    // 设置登录状态
    _isLoggingIn = true;
    _loginError = null;
    notifyListeners();
    
    try {
      // 调用真实登录 API
      final result = await _authApi.login(username, password);
      
      if (result.success) {
        // 登录成功
        _token = result.token;
        _isLoggedIn = true;
        _loginError = null;
        
        // 设置用户信息
        if (result.user != null) {
          _user = User(
            id: result.user!.id.toString(),
            phone: result.user!.phone ?? username,
            name: result.user!.name,
            avatar: result.user!.avatar,
            token: result.token,
          );
        } else {
          // 如果 API 未返回用户信息，使用默认值
          _user = User(
            id: '1',
            phone: username,
            name: '用户',
            token: result.token,
          );
        }
        
        notifyListeners();
        return true;
      } else {
        // 登录失败
        _loginError = result.errorMessage ?? '登录失败，请检查账号密码';
        _isLoggedIn = false;
        _token = null;
        _user = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // 异常处理
      _loginError = '登录异常: ${e.toString()}';
      _isLoggedIn = false;
      _token = null;
      _user = null;
      notifyListeners();
      return false;
    } finally {
      _isLoggingIn = false;
      notifyListeners();
    }
  }

  /// 退出登录
  Future<void> logout() async {
    _isLoggingIn = true;
    notifyListeners();
    
    try {
      // 调用登出 API
      await _authApi.logout();
    } catch (e) {
      // 即使 API 调用失败，也清除本地状态
      debugPrint('Logout API error: $e');
    }
    
    // 清除本地状态
    _user = null;
    _token = null;
    _isLoggedIn = false;
    _loginError = null;
    _isLoggingIn = false;
    
    notifyListeners();
  }

  /// 自动登录 - 检查本地是否有有效 Token
  /// 返回: true 表示有 Token 可以尝试自动登录
  Future<bool> checkAutoLogin() async {
    final hasToken = await _authApi.hasToken();
    
    if (hasToken) {
      // 有本地 Token，尝试获取用户信息验证 Token 是否有效
      try {
        final userInfo = await _authApi.getCurrentUser();
        if (userInfo != null) {
          // Token 有效，设置登录状态
          final token = await _authApi.getToken();
          _user = User(
            id: userInfo.id.toString(),
            phone: userInfo.phone ?? '',
            name: userInfo.name,
            avatar: userInfo.avatar,
            token: token,
          );
          _token = token;
          _isLoggedIn = true;
          notifyListeners();
          return true;
        }
      } catch (e) {
        // Token 可能已过期，清除本地 Token
        debugPrint('Auto login check failed: $e');
        await _clearLocalToken();
      }
    }
    
    return false;
  }
  
  /// 清除本地 Token（不调用 API）
  Future<void> _clearLocalToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// 刷新用户信息
  Future<void> refreshUser() async {
    if (!_isLoggedIn) return;
    
    try {
      final userInfo = await _authApi.getCurrentUser();
      if (userInfo != null) {
        _user = User(
          id: userInfo.id.toString(),
          phone: userInfo.phone ?? _user?.phone ?? '',
          name: userInfo.name,
          avatar: userInfo.avatar,
          token: _token,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Refresh user error: $e');
    }
  }
  
  /// 清除登录错误信息
  void clearError() {
    _loginError = null;
    notifyListeners();
  }
}