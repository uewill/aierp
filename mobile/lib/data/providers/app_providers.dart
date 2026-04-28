/// 应用状态管理 Provider
/// 使用 Provider 进行全局状态管理

import 'package:flutter/material.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/services/data_service.dart';
import 'package:aierp_mobile/api/inventory_api.dart';
import 'package:aierp_mobile/api/auth_api.dart';

/// 应用全局状态
class AppState extends ChangeNotifier {
  final DataService _dataService = dataService;
  final AuthApi _authApi = AuthApi();
  
  // 当前用户
  User? _currentUser;
  User? get currentUser => _currentUser;
  
  // 登录用户信息（真实API）
  UserInfo? _loginUser;
  UserInfo? get loginUser => _loginUser;
  
  // 当前公司
  Company? _currentCompany;
  Company? get currentCompany => _currentCompany;
  
  // 是否加载完成
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  // 是否已登录
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  
  // 登录错误信息
  String? _loginError;
  String? get loginError => _loginError;
  
  // 统计数据
  Statistics? _statistics;
  Statistics? get statistics => _statistics;

  /// 初始化应用
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // 检查本地是否有Token（自动登录）
      final hasToken = await _authApi.hasToken();
      if (hasToken) {
        // 有Token，尝试获取用户信息
        _loginUser = await _authApi.getCurrentUser();
        if (_loginUser != null) {
          _currentUser = User(
            id: _loginUser!.id.toString(),
            username: _loginUser!.name,
            name: _loginUser!.name,
            roles: [_loginUser!.role ?? 'user'],
          );
          _isLoggedIn = true;
        }
      }
      
      final companies = await _dataService.getCompanies();
      _currentCompany = companies.firstOrNull;
      _statistics = await _dataService.getStatistics();
    } catch (e) {
      debugPrint('初始化失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  /// 登录（真实API）
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _loginError = null;
    notifyListeners();
    
    try {
      final result = await _authApi.login(username, password);
      
      if (result.success) {
        _loginUser = result.user;
        _currentUser = User(
          id: result.user?.id.toString() ?? '1',
          username: username,
          name: result.user?.name ?? username,
          roles: [result.user?.role ?? 'admin'],
        );
        _isLoggedIn = true;
      } else {
        _loginError = result.errorMessage ?? '登录失败';
      }
    } catch (e) {
      debugPrint('登录失败: $e');
      _loginError = '网络连接失败，请检查服务器地址';
    }
    
    _isLoading = false;
    notifyListeners();
    
    return _isLoggedIn;
  }
  
  /// 登出
  Future<void> logout() async {
    await _authApi.logout();
    _currentUser = null;
    _loginUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  /// 刷新统计数据
  Future<void> refreshStatistics() async {
    _statistics = await _dataService.getStatistics();
    notifyListeners();
  }

  /// 切换公司
  Future<void> switchCompany(Company company) async {
    _currentCompany = company;
    notifyListeners();
  }
}

/// 分类数据 Provider
class CategoryProvider extends ChangeNotifier {
  final DataService _dataService = dataService;
  
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 加载分类列表
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    
    _categories = await _dataService.getCategories();
    
    _isLoading = false;
    notifyListeners();
  }

  /// 获取分类树
  List<Category> getCategoryTree() {
    // 构建分类树结构
    final rootCategories = _categories.where((c) => c.level == 1).toList();
    return rootCategories.map((root) {
      final children = _categories.where((c) => c.parentId == root.id).toList();
      return root.copyWith(children: children);
    }).toList();
  }

  /// 保存分类
  Future<bool> saveCategory(Category category) async {
    final result = await _dataService.saveCategory(category);
    if (result) {
      await loadCategories();
    }
    return result;
  }

  /// 删除分类
  Future<bool> deleteCategory(String id) async {
    final result = await _dataService.deleteCategory(id);
    if (result) {
      await loadCategories();
    }
    return result;
  }
}

/// 商品数据 Provider
class ProductProvider extends ChangeNotifier {
  final DataService _dataService = dataService;
  
  List<Product> _products = [];
  List<Product> get products => _products;
  
  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _categoryIdFilter;
  String? get categoryIdFilter => _categoryIdFilter;
  
  String? _keywordFilter;
  String? get keywordFilter => _keywordFilter;

  /// 加载商品列表
  Future<void> loadProducts({String? categoryId, String? keyword}) async {
    _isLoading = true;
    _categoryIdFilter = categoryId;
    _keywordFilter = keyword;
    notifyListeners();
    
    _products = await _dataService.getProducts(
      categoryId: categoryId,
      keyword: keyword,
    );
    
    _isLoading = false;
    notifyListeners();
  }

  /// 选择商品
  void selectProduct(Product? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  /// 获取商品详情
  Future<Product?> getProduct(String id) async {
    return await _dataService.getProduct(id);
  }

  /// 保存商品
  Future<bool> saveProduct(Product product) async {
    final result = await _dataService.saveProduct(product);
    if (result) {
      await loadProducts(categoryId: _categoryIdFilter, keyword: _keywordFilter);
    }
    return result;
  }

  /// 删除商品
  Future<bool> deleteProduct(String id) async {
    final result = await _dataService.deleteProduct(id);
    if (result) {
      await loadProducts(categoryId: _categoryIdFilter, keyword: _keywordFilter);
    }
    return result;
  }
}

/// 往来单位 Provider
class PartnerProvider extends ChangeNotifier {
  final DataService _dataService = dataService;
  
  List<Partner> _customers = [];
  List<Partner> get customers => _customers;
  
  List<Partner> _suppliers = [];
  List<Partner> get suppliers => _suppliers;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 加载客户列表
  Future<void> loadCustomers({String? keyword}) async {
    _isLoading = true;
    notifyListeners();
    
    _customers = await _dataService.getCustomers(keyword: keyword);
    
    _isLoading = false;
    notifyListeners();
  }

  /// 加载供应商列表
  Future<void> loadSuppliers({String? keyword}) async {
    _isLoading = true;
    notifyListeners();
    
    _suppliers = await _dataService.getSuppliers(keyword: keyword);
    
    _isLoading = false;
    notifyListeners();
  }

  /// 保存往来单位
  Future<bool> savePartner(Partner partner) async {
    final result = await _dataService.savePartner(partner);
    if (result) {
      if (partner.type == PartnerType.customer) {
        await loadCustomers();
      } else {
        await loadSuppliers();
      }
    }
    return result;
  }

  /// 删除往来单位
  Future<bool> deletePartner(String id, PartnerType type) async {
    final result = await _dataService.deletePartner(id);
    if (result) {
      if (type == PartnerType.customer) {
        await loadCustomers();
      } else {
        await loadSuppliers();
      }
    }
    return result;
  }
}

/// 仓库 Provider
class WarehouseProvider extends ChangeNotifier {
  final DataService _dataService = dataService;
  
  List<Warehouse> _warehouses = [];
  List<Warehouse> get warehouses => _warehouses;
  
  Warehouse? _defaultWarehouse;
  Warehouse? get defaultWarehouse => _defaultWarehouse;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 加载仓库列表
  Future<void> loadWarehouses() async {
    _isLoading = true;
    notifyListeners();
    
    _warehouses = await _dataService.getWarehouses();
    _defaultWarehouse = _warehouses.where((w) => w.isDefault).firstOrNull;
    
    _isLoading = false;
    notifyListeners();
  }

  /// 保存仓库
  Future<bool> saveWarehouse(Warehouse warehouse) async {
    final result = await _dataService.saveWarehouse(warehouse);
    if (result) {
      await loadWarehouses();
    }
    return result;
  }

  /// 删除仓库
  Future<bool> deleteWarehouse(String id) async {
    final result = await _dataService.deleteWarehouse(id);
    if (result) {
      await loadWarehouses();
    }
    return result;
  }
}

/// 库存 Provider（原有 Mock 实现）
class InventoryProvider extends ChangeNotifier {
  final DataService _dataService = dataService;
  
  List<Inventory> _inventories = [];
  List<Inventory> get inventories => _inventories;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 加载库存列表
  Future<void> loadInventory({String? warehouseId, String? productId}) async {
    _isLoading = true;
    notifyListeners();
    
    _inventories = await _dataService.getInventory(
      warehouseId: warehouseId,
      productId: productId,
    );
    
    _isLoading = false;
    notifyListeners();
  }

  /// 获取库存数量
  Future<double> getStockQuantity(String productId, String skuId, String warehouseId) async {
    return await _dataService.getStockQuantity(productId, skuId, warehouseId);
  }
}

/// 库存分页 Provider（真实 API 实现）
class InventoryPageProvider extends ChangeNotifier {
  final _api = InventoryApi();
  
  List<InventoryItem> _records = [];
  List<InventoryItem> get records => _records;
  
  int _total = 0;
  int get total => _total;
  
  int _currentPage = 1;
  int get currentPage => _currentPage;
  
  int _pageSize = 20;
  int get pageSize => _pageSize;
  
  int _pages = 0;
  int get pages => _pages;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  
  int? _warehouseIdFilter;
  int? get warehouseIdFilter => _warehouseIdFilter;
  
  String _keywordFilter = '';
  String get keywordFilter => _keywordFilter;
  
  /// 加载库存分页数据
  Future<void> loadInventoryPage({
    int page = 1,
    int? warehouseId,
    String? keyword,
    bool refresh = false,
  }) async {
    if (_isLoading) return;
    
    _isLoading = true;
    if (refresh) {
      _currentPage = 1;
      _records = [];
    }
    notifyListeners();
    
    _warehouseIdFilter = warehouseId;
    _keywordFilter = keyword ?? '';
    
    final result = await _api.getInventoryPage(
      page: page,
      size: _pageSize,
      warehouseId: warehouseId,
      keyword: keyword,
    );
    
    _records = page == 1 ? result.records : [..._records, ...result.records];
    _total = result.total;
    _currentPage = result.current;
    _pages = result.pages;
    _hasMore = result.hasMore;
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// 加载更多
  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;
    await loadInventoryPage(
      page: _currentPage + 1,
      warehouseId: _warehouseIdFilter,
      keyword: _keywordFilter,
    );
  }
  
  /// 刷新
  Future<void> refresh() async {
    await loadInventoryPage(
      page: 1,
      warehouseId: _warehouseIdFilter,
      keyword: _keywordFilter,
      refresh: true,
    );
  }
  
  /// 切换仓库筛选
  Future<void> setWarehouseFilter(int? warehouseId) async {
    await loadInventoryPage(
      page: 1,
      warehouseId: warehouseId,
      keyword: _keywordFilter,
      refresh: true,
    );
  }
  
  /// 搜索商品
  Future<void> search(String keyword) async {
    await loadInventoryPage(
      page: 1,
      warehouseId: _warehouseIdFilter,
      keyword: keyword,
      refresh: true,
    );
  }
}

/// 单据 Provider
class BillProvider extends ChangeNotifier {
  final DataService _dataService = dataService;
  
  List<Bill> _bills = [];
  List<Bill> get bills => _bills;
  
  Bill? _selectedBill;
  Bill? get selectedBill => _selectedBill;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  BillType? _typeFilter;
  BillType? get typeFilter => _typeFilter;
  
  BillStatus? _statusFilter;
  BillStatus? get statusFilter => _statusFilter;

  /// 加载单据列表
  Future<void> loadBills({BillType? type, BillStatus? status}) async {
    _isLoading = true;
    _typeFilter = type;
    _statusFilter = status;
    notifyListeners();
    
    _bills = await _dataService.getBills(type: type, status: status);
    
    _isLoading = false;
    notifyListeners();
  }

  /// 选择单据
  void selectBill(Bill? bill) {
    _selectedBill = bill;
    notifyListeners();
  }

  /// 获取单据详情
  Future<Bill?> getBill(String id) async {
    return await _dataService.getBill(id);
  }

  /// 生成单据编号
  Future<String> generateBillNo(BillType type) async {
    return await _dataService.generateBillNo(type);
  }

  /// 保存单据
  Future<bool> saveBill(Bill bill) async {
    final result = await _dataService.saveBill(bill);
    if (result) {
      await loadBills(type: _typeFilter, status: _statusFilter);
    }
    return result;
  }

  /// 审核单据
  Future<bool> approveBill(String id) async {
    final result = await _dataService.approveBill(id);
    if (result) {
      await loadBills(type: _typeFilter, status: _statusFilter);
    }
    return result;
  }

  /// 取消单据
  Future<bool> cancelBill(String id) async {
    final result = await _dataService.cancelBill(id);
    if (result) {
      await loadBills(type: _typeFilter, status: _statusFilter);
    }
    return result;
  }
}