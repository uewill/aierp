/// 应用常量配置
class AppConstants {
  // 应用名称
  static const String appName = '进销存';
  
  // 版本号
  static const String version = '1.0.0';
  
  // API地址
  static const String apiBaseUrl = 'http://42.193.169.78:8080';
  
  // 存储Key
  static const String tokenKey = 'auth_token';
  static const String userInfoKey = 'user_info';
  static const String tenantKey = 'tenant_id';
  
  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 超时配置
  static const int connectTimeout = 15000; // 15秒
  static const int receiveTimeout = 30000; // 30秒
  
  // 缓存配置
  static const int cacheMaxAge = 3600; // 1小时
}