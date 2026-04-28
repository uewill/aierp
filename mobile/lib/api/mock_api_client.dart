import 'dart:convert';
import 'package:flutter/foundation.dart';

/// 模拟API客户端
class MockApiClient {
  /// 存储模拟数据
  static final Map<String, dynamic> _mockData = {
    'users': [
      {
        'id': 1,
        'username': 'admin',
        'password': '123456',
        'name': '管理员',
        'phone': '13800138000',
        'email': 'admin@example.com',
        'companyId': 1,
      }
    ],
    'companies': [
      {
        'id': 1,
        'name': '测试公司',
        'code': 'TEST001',
        'address': '北京市朝阳区',
        'phone': '010-12345678',
        'contactPerson': '张经理',
        'contactPhone': '13800138000',
        'createTime': '2024-01-01 00:00:00',
      }
    ],
    'products': [
      {
        'id': 1,
        'name': '可口可乐',
        'code': 'KKKL001',
        'categoryId': 1,
        'categoryName': '饮料',
        'specification': '500ml',
        'unit': '瓶',
        'purchasePrice': 2.5,
        'salePrice': 3.0,
        'minStock': 10,
        'maxStock': 100,
        'barcode': '6901234567890',
        'description': '经典碳酸饮料',
        'status': 1,
        'createTime': '2024-01-01 00:00:00',
      },
      {
        'id': 2,
        'name': '雪碧',
        'code': 'XP001',
        'categoryId': 1,
        'categoryName': '饮料',
        'specification': '500ml',
        'unit': '瓶',
        'purchasePrice': 2.3,
        'salePrice': 2.8,
        'minStock': 10,
        'maxStock': 100,
        'barcode': '6901234567891',
        'description': '柠檬味碳酸饮料',
        'status': 1,
        'createTime': '2024-01-02 00:00:00',
      }
    ],
    'categories': [
      {'id': 1, 'name': '饮料', 'parentId': 0, 'level': 1},
      {'id': 2, 'name': '食品', 'parentId': 0, 'level': 1},
      {'id': 3, 'name': '日用品', 'parentId': 0, 'level': 1},
      {'id': 4, 'name': '碳酸饮料', 'parentId': 1, 'level': 2},
      {'id': 5, 'name': '果汁', 'parentId': 1, 'level': 2},
    ]
  };

  /// GET 请求
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    await Future.delayed(const Duration(milliseconds: 300)); // 模拟网络延迟

    if (path == '/api/auth/login') {
      return {'code': 200, 'data': {'token': 'mock_token_123456'}};
    } else if (path == '/api/auth/register') {
      return {'code': 200, 'message': '注册成功'};
    } else if (path == '/api/company/list') {
      return {'code': 200, 'data': _mockData['companies']};
    } else if (path == '/api/company/create') {
      return {'code': 200, 'message': '公司创建成功'};
    } else if (path.startsWith('/api/basic/product/')) {
      final id = int.tryParse(path.split('/').last);
      if (id != null) {
        final product = (_mockData['products'] as List)
            .firstWhere((p) => p['id'] == id, orElse: () => null);
        if (product != null) {
          return {'code': 200, 'data': product};
        }
      }
      return {'code': 404, 'message': '商品不存在'};
    } else if (path == '/api/basic/product/page') {
      final page = queryParameters?['pageNum'] as int? ?? 1;
      final pageSize = queryParameters?['pageSize'] as int? ?? 10;
      final keyword = queryParameters?['keyword'] as String?;

      List<dynamic> products = List.from(_mockData['products']);
      
      if (keyword != null && keyword.isNotEmpty) {
        products = products.where((p) => 
          (p['name'] as String).toLowerCase().contains(keyword.toLowerCase()) ||
          (p['code'] as String).toLowerCase().contains(keyword.toLowerCase())
        ).toList();
      }

      final total = products.length;
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;
      final paginatedProducts = products.skip(startIndex).take(pageSize).toList();

      return {
        'code': 200,
        'data': {
          'list': paginatedProducts,
          'total': total,
          'pageNum': page,
          'pageSize': pageSize,
          'pages': (total / pageSize).ceil(),
        }
      };
    } else if (path == '/api/basic/category/tree') {
      return {'code': 200, 'data': _mockData['categories']};
    }

    return {'code': 404, 'message': '接口未实现'};
  }

  /// POST 请求
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (path == '/api/auth/login') {
      final username = data?['username'];
      final password = data?['password'];
      
      final user = (_mockData['users'] as List)
          .firstWhere((u) => u['username'] == username && u['password'] == password, orElse: () => null);
      
      if (user != null) {
        return {'code': 200, 'data': {'token': 'mock_token_123456', 'user': user}};
      }
      return {'code': 401, 'message': '用户名或密码错误'};
    } else if (path == '/api/auth/register') {
      // 添加新用户到模拟数据
      final newUser = {
        'id': (_mockData['users'] as List).length + 1,
        'username': data?['username'],
        'password': data?['password'],
        'name': data?['name'],
        'phone': data?['phone'],
        'email': data?['email'],
        'companyId': null,
      };
      (_mockData['users'] as List).add(newUser);
      return {'code': 200, 'message': '注册成功'};
    } else if (path == '/api/company/create') {
      final newCompany = {
        'id': (_mockData['companies'] as List).length + 1,
        'name': data?['name'],
        'code': data?['code'],
        'address': data?['address'],
        'phone': data?['phone'],
        'contactPerson': data?['contactPerson'],
        'contactPhone': data?['contactPhone'],
        'createTime': DateTime.now().toIso8601String(),
      };
      (_mockData['companies'] as List).add(newCompany);
      return {'code': 200, 'message': '公司创建成功', 'data': newCompany};
    } else if (path == '/api/basic/product') {
      final newProduct = {
        'id': (_mockData['products'] as List).length + 1,
        'name': data?['name'],
        'code': data?['code'],
        'categoryId': data?['categoryId'],
        'categoryName': data?['categoryName'],
        'specification': data?['specification'],
        'unit': data?['unit'],
        'purchasePrice': data?['purchasePrice'],
        'salePrice': data?['salePrice'],
        'minStock': data?['minStock'],
        'maxStock': data?['maxStock'],
        'barcode': data?['barcode'],
        'description': data?['description'],
        'status': data?['status'] ?? 1,
        'createTime': DateTime.now().toIso8601String(),
      };
      (_mockData['products'] as List).add(newProduct);
      return {'code': 200, 'message': '商品创建成功', 'data': newProduct};
    }

    return {'code': 404, 'message': '接口未实现'};
  }

  /// PUT 请求
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? data}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (path.startsWith('/api/basic/product/')) {
      final id = int.tryParse(path.split('/').last);
      if (id != null) {
        final products = _mockData['products'] as List;
        final index = products.indexWhere((p) => p['id'] == id);
        if (index != -1) {
          products[index] = {
            ...products[index],
            ...data!,
            'id': id,
          };
          return {'code': 200, 'message': '商品更新成功'};
        }
      }
      return {'code': 404, 'message': '商品不存在'};
    }

    return {'code': 404, 'message': '接口未实现'};
  }

  /// DELETE 请求
  Future<void> delete(String path) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (path.startsWith('/api/basic/product/')) {
      final id = int.tryParse(path.split('/').last);
      if (id != null) {
        final products = _mockData['products'] as List;
        products.removeWhere((p) => p['id'] == id);
      }
    }
  }
}