import 'package:flutter/material.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/home/pages/main_page.dart';
import '../../features/company/pages/company_select_page.dart';
import '../../features/company/pages/company_create_page.dart';
import '../../features/basic/product/pages/product_list_page.dart';
import '../../features/basic/product/pages/product_detail_page.dart';
import '../../features/basic/product/pages/product_inventory_page.dart';
import '../../features/basic/product/pages/product_statistics_page.dart';
import '../../features/basic/product/pages/batch/product_batch_import_page.dart';
import '../../features/basic/category/pages/category_management_page.dart';
import '../../features/bill/sales/pages/sales_order_add_page.dart';
import '../../features/settings/pages/print_settings_page.dart';

/// 路由配置
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';
  
  static const String product = '/product';
  static const String productCreate = '/product/create';
  static const String productDetail = '/product/detail';
  static const String productInventory = '/product/inventory';
  static const String productStatistics = '/product/statistics';
  static const String productBatchImport = '/product/batch-import';
  
  static const String category = '/category';
  static const String categoryManagement = '/category/management';
  static const String categoryCreate = '/category/create';
  static const String categoryEdit = '/category/edit';
  
  static const String companySelect = '/company/select';
  static const String companyCreate = '/company/create';
  
  static const String sales = '/sales';
  static const String salesCreate = '/sales/create';
  static const String purchase = '/purchase';
  static const String purchaseCreate = '/purchase/create';
  static const String inventory = '/inventory';
  static const String partner = '/partner';
  static const String warehouse = '/warehouse';
  static const String finance = '/finance';
  static const String report = '/report';
  static const String settings = '/settings';
  static const String printSettings = '/settings/print';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    main: (context) => const MainPage(),
    companySelect: (context) => const CompanySelectPage(),
    companyCreate: (context) => const CompanyCreatePage(),
    product: (context) => const ProductListPage(),
    productCreate: (context) => const ProductDetailPage(),
    productBatchImport: (context) => const ProductBatchImportPage(),
    categoryManagement: (context) => const CategoryManagementPage(),
    salesCreate: (context) => const SalesOrderAddPage(),
    printSettings: (context) => const PrintSettingsPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ProductDetailPage(),
          settings: RouteSettings(arguments: args?['productId']),
        );
      case productInventory:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args?['productId'] == null) {
          return null;
        }
        return MaterialPageRoute(
          builder: (context) => ProductInventoryPage(productId: args!['productId'].toString()),
        );
      case productStatistics:
        return MaterialPageRoute(
          builder: (context) => const ProductStatisticsPage(),
        );
      case categoryEdit:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => const CategoryManagementPage(), // 简化处理
        );
      default:
        return null;
    }
  }
}