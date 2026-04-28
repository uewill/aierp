import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 路由路径常量
class RoutePaths {
  RoutePaths._();

  // 认证
  static const String login = '/login';
  static const String companySelect = '/company-select';

  // 主页
  static const String home = '/';
  static const String main = '/main';

  // 基础资料
  static const String productList = '/basic/products';
  static const String productAdd = '/basic/products/add';
  static const String productEdit = '/basic/products/edit/:id';
  static const String productSelect = '/basic/products/select';
  static const String customerList = '/basic/customers';
  static const String customerAdd = '/basic/customers/add';
  static const String customerEdit = '/basic/customers/edit/:id';
  static const String customerSelect = '/basic/customers/select';
  static const String supplierList = '/basic/suppliers';
  static const String supplierSelect = '/basic/suppliers/select';
  static const String warehouseList = '/basic/warehouses';
  static const String warehouseSelect = '/basic/warehouses/select';

  // 单据
  static const String salesOrderList = '/bill/sales';
  static const String salesOrderAdd = '/bill/sales/add';
  static const String salesOrderDetail = '/bill/sales/:id';
  static const String purchaseOrderList = '/bill/purchase';
  static const String purchaseOrderAdd = '/bill/purchase/add';
  static const String stockInList = '/bill/stock-in';
  static const String stockInAdd = '/bill/stock-in/add';
  static const String stockOutList = '/bill/stock-out';
  static const String stockOutAdd = '/bill/stock-out/add';

  // 库存
  static const String inventoryList = '/inventory';
  static const String inventoryDetail = '/inventory/:id';
  static const String stocktakeList = '/inventory/stocktake';
  static const String stocktakeAdd = '/inventory/stocktake/add';

  // 报表
  static const String reportSales = '/report/sales';
  static const String reportPurchase = '/report/purchase';
  static const String reportInventory = '/report/inventory';
  static const String reportFinance = '/report/finance';

  // 设置
  static const String settings = '/settings';
  static const String userList = '/settings/users';
  static const String roleList = '/settings/roles';
  static const String companySettings = '/settings/company';
}

/// 路由配置
/// 注意：实际使用时需要引入 go_router 包
/// 这里提供路由结构定义
class AppRouter {
  AppRouter._();

  /// 路由配置示例
  /// 实际项目中需要配合 go_router 使用
  static Map<String, WidgetBuilder> get routes => {
    // RoutePaths.login: (context) => const LoginPage(),
    // RoutePaths.home: (context) => const HomePage(),
    // RoutePaths.productList: (context) => const ProductListPage(),
    // ... 其他路由
  };

  /// 路由名称
  static const Map<String, String> routeNames = {
    'login': RoutePaths.login,
    'home': RoutePaths.home,
    'productList': RoutePaths.productList,
    'productAdd': RoutePaths.productAdd,
    'customerList': RoutePaths.customerList,
    'customerAdd': RoutePaths.customerAdd,
    'salesOrderAdd': RoutePaths.salesOrderAdd,
    'purchaseOrderAdd': RoutePaths.purchaseOrderAdd,
  };
}