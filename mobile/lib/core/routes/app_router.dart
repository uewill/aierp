/// 路由配置 - Web 版路由
/// 支持移动端和 Web 端路由

import 'package:flutter/material.dart';
import 'package:aierp_mobile/features/home/pages/home_page.dart';
import 'package:aierp_mobile/features/auth/pages/login_page.dart';
import 'package:aierp_mobile/features/basic/product/pages/product_list_page.dart';
import 'package:aierp_mobile/features/basic/product/pages/product_create_page.dart';
import 'package:aierp_mobile/features/basic/product/pages/product_detail_page.dart';
import 'package:aierp_mobile/features/basic/product/pages/product_select_page.dart';
import 'package:aierp_mobile/features/basic/category/pages/category_management_page.dart';
import 'package:aierp_mobile/features/basic/customer/pages/customer_list_page.dart';
import 'package:aierp_mobile/features/basic/supplier/pages/supplier_list_page.dart';
import 'package:aierp_mobile/features/basic/warehouse/pages/warehouse_list_page.dart';
import 'package:aierp_mobile/features/inventory/pages/inventory_list_page.dart';
import 'package:aierp_mobile/features/bill/pages/sales_list_page.dart';
import 'package:aierp_mobile/features/bill/pages/sales_create_page.dart';
import 'package:aierp_mobile/features/bill/pages/sales_detail_page.dart';
import 'package:aierp_mobile/features/bill/pages/purchase_list_page.dart';
import 'package:aierp_mobile/features/bill/pages/purchase_create_page.dart';
import 'package:aierp_mobile/features/bill/pages/purchase_detail_page.dart';
import 'package:aierp_mobile/features/report/pages/report_page.dart';

class AppRouter {
  /// 路由表
  static final Map<String, WidgetBuilder> _routes = {
    // 主页面
    '/': (context) => const HomePage(),
    '/login': (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
    
    // 商品管理（统一使用完整版）
    '/products': (context) => const ProductListPage(),
    '/products/create': (context) => const ProductCreatePage(),
    '/product/create': (context) => const ProductCreatePage(), // 兼容旧路由
    '/products/select': (context) => const ProductSelectPage(),
    
    // 分类管理
    '/categories': (context) => const CategoryManagementPage(),
    
    // 往来单位
    '/customers': (context) => const CustomerListPage(),
    '/suppliers': (context) => const SupplierListPage(),
    
    // 仓库管理
    '/warehouses': (context) => const WarehouseListPage(),
    
    // 库存管理
    '/inventory': (context) => const InventoryListPage(),
    
    // 销售管理
    '/sales': (context) => const SalesListPage(),
    '/sales/create': (context) => const SalesCreatePage(),
    
    // 采购管理
    '/purchase': (context) => const PurchaseListPage(),
    '/purchase/create': (context) => const PurchaseCreatePage(),
    
    // 报表
    '/reports': (context) => const ReportPage(),
  };

  /// 需要参数的路由
  static final Map<String, WidgetBuilder> _detailRoutes = {
    '/products/detail': (context) => const ProductDetailPage(),
    '/products/edit': (context) => const ProductCreatePage(),
    '/sales/detail': (context) => const SalesDetailPage(),
    '/sales/edit': (context) => const SalesCreatePage(),
    '/purchase/detail': (context) => const PurchaseDetailPage(),
    '/purchase/edit': (context) => const PurchaseCreatePage(),
  };

  /// 生成路由
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final arguments = settings.arguments;

    // 检查普通路由
    if (_routes.containsKey(routeName)) {
      return MaterialPageRoute(
        builder: _routes[routeName]!,
        settings: settings,
      );
    }

    // 检查详情路由
    if (_detailRoutes.containsKey(routeName)) {
      return MaterialPageRoute(
        builder: (context) {
          final builder = _detailRoutes[routeName]!;
          return builder(context);
        },
        settings: settings,
      );
    }

    // 未找到路由
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('页面不存在')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('未找到页面'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}