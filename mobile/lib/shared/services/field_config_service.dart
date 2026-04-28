import 'package:flutter/foundation.dart';
import '../models/field_config.dart';
import '../../api/api_client.dart';

/// 字段配置服务
/// 提供字段配置的获取、缓存和同步功能
class FieldConfigService extends ChangeNotifier {
  /// 配置缓存：module -> List<FieldConfig>
  final Map<String, List<FieldConfig>> _cache = {};
  
  /// API客户端
  final ApiClient _apiClient;
  
  FieldConfigService(this._apiClient);
  
  /// 获取模块字段配置
  Future<List<FieldConfig>> getConfig(String module, {String? group}) async {
    // 检查缓存
    if (_cache.containsKey(module)) {
      final config = _cache[module]!;
      if (group != null) {
        return config.where((f) => f.fieldGroup == group).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      }
      return config;
    }
    
    // 从API获取
    try {
      final response = await _apiClient.get(
        '/api/config/$module',
        queryParameters: group != null ? {'group': group} : null,
      );
      
      final List<dynamic> data = response.data;
      final fields = data.map((json) => FieldConfig.fromJson(json)).toList();
      
      // 缓存
      _cache[module] = fields;
      
      if (group != null) {
        return fields.where((f) => f.fieldGroup == group).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      }
      return fields;
    } catch (e) {
      debugPrint('获取字段配置失败: $e');
      return [];
    }
  }
  
  /// 获取可见字段
  Future<List<FieldConfig>> getVisibleFields(String module, {String? group}) async {
    final config = await getConfig(module, group: group);
    return config.where((f) => f.isVisible).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
  
  /// 同步所有模块配置
  Future<Map<String, List<FieldConfig>>> syncAll() async {
    try {
      final response = await _apiClient.get('/api/config/sync');
      final Map<String, dynamic> data = response.data;
      
      final result = <String, List<FieldConfig>>{};
      data.forEach((module, fields) {
        final list = (fields as List).map((f) => FieldConfig.fromJson(f)).toList();
        _cache[module] = list;
        result[module] = list;
      });
      
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('同步字段配置失败: $e');
      return {};
    }
  }
  
  /// 更新字段配置
  Future<void> updateConfig(String module, List<FieldConfig> fields) async {
    try {
      await _apiClient.put('/api/config/$module', data: {
        'fields': fields.map((f) => {
          'fieldCode': f.fieldCode,
          'fieldName': f.fieldName,
          'isRequired': f.isRequired,
          'isVisible': f.isVisible,
          'sortOrder': f.sortOrder,
        }).toList(),
      });
      
      // 更新缓存
      _cache[module] = fields;
      notifyListeners();
    } catch (e) {
      debugPrint('更新字段配置失败: $e');
      rethrow;
    }
  }
  
  /// 重置字段配置
  Future<void> resetConfig(String module) async {
    try {
      await _apiClient.post('/api/config/$module/reset');
      
      // 清除缓存
      _cache.remove(module);
      
      // 重新获取
      await getConfig(module);
      notifyListeners();
    } catch (e) {
      debugPrint('重置字段配置失败: $e');
      rethrow;
    }
  }
  
  /// 清除所有缓存
  void clearCache() {
    _cache.clear();
    notifyListeners();
  }
}