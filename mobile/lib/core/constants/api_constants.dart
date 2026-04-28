/// API 接口常量配置
class ApiConstants {
  ApiConstants._();

  /// 基础 URL（公网地址）
  static const String baseUrl = 'http://42.193.169.78:8090/api';

  /// 超时时间
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 10000;

  // ========== 认证相关 ==========
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String sendSms = '/auth/sms/send';
  static const String refreshToken = '/auth/refresh';

  // ========== 基础资料 ==========
  // 商品
  static const String productList = '/products';
  static const String productCreate = '/products';
  static const String productUpdate = '/products/{id}';
  static const String productDelete = '/products/{id}';
  static const String productDetail = '/products/{id}';
  static const String productCategories = '/products/categories';

  // 客户
  static const String customerList = '/customers';
  static const String customerCreate = '/customers';
  static const String customerUpdate = '/customers/{id}';
  static const String customerDelete = '/customers/{id}';
  static const String customerDetail = '/customers/{id}';

  // 供应商
  static const String supplierList = '/suppliers';
  static const String supplierCreate = '/suppliers';
  static const String supplierUpdate = '/suppliers/{id}';
  static const String supplierDelete = '/suppliers/{id}';

  // 仓库
  static const String warehouseList = '/warehouses';
  static const String warehouseCreate = '/warehouses';

  // ========== 单据相关 ==========
  // 销售单
  static const String salesOrderList = '/sales/orders';
  static const String salesOrderCreate = '/sales/orders';
  static const String salesOrderDetail = '/sales/orders/{id}';

  // 采购单
  static const String purchaseOrderList = '/purchase/orders';
  static const String purchaseOrderCreate = '/purchase/orders';

  // 入库单
  static const String stockInList = '/stock/in';
  static const String stockInCreate = '/stock/in';

  // 出库单
  static const String stockOutList = '/stock/out';
  static const String stockOutCreate = '/stock/out';

  // ========== 库存相关 ==========
  static const String inventoryList = '/inventory';
  static const String inventoryWarning = '/inventory/warning';
  static const String inventoryBatch = '/inventory/batch';

  // ========== 报表相关 ==========
  static const String reportSales = '/reports/sales';
  static const String reportPurchase = '/reports/purchase';
  static const String reportInventory = '/reports/inventory';
  static const String reportFinance = '/reports/finance';

  // ========== 系统设置 ==========
  static const String userCompany = '/settings/user-company';
  static const String switchCompany = '/settings/switch-company';
  static const String userList = '/settings/users';
  static const String roleList = '/settings/roles';
}

/// 分页常量
class PageConstants {
  PageConstants._();

  /// 默认页码
  static const int defaultPage = 1;

  /// 默认每页数量
  static const int defaultPageSize = 20;

  /// 每页数量选项
  static const List<int> pageSizeOptions = [10, 20, 50, 100];
}

/// 存储键名常量
class StorageConstants {
  StorageConstants._();

  static const String token = 'token';
  static const String refreshToken = 'refresh_token';
  static const String userInfo = 'user_info';
  static const String companyInfo = 'company_info';
  static const String theme = 'theme';
  static const String locale = 'locale';
}