/// 数据服务层
/// 提供 Mock 数据访问接口，未来可切换为 API 调用

import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/mock/mock_data.dart';

/// 数据服务接口
/// 定义所有数据访问方法，方便未来切换真实 API
abstract class DataService {
  // 分类
  Future<List<Category>> getCategories();
  Future<Category?> getCategory(String id);
  Future<bool> saveCategory(Category category);
  Future<bool> deleteCategory(String id);

  // 商品
  Future<List<Product>> getProducts({String? categoryId, String? keyword});
  Future<Product?> getProduct(String id);
  Future<bool> saveProduct(Product product);
  Future<bool> deleteProduct(String id);

  // 往来单位
  Future<List<Partner>> getCustomers({String? keyword});
  Future<List<Partner>> getSuppliers({String? keyword});
  Future<Partner?> getPartner(String id);
  Future<bool> savePartner(Partner partner);
  Future<bool> deletePartner(String id);

  // 仓库
  Future<List<Warehouse>> getWarehouses();
  Future<Warehouse?> getWarehouse(String id);
  Future<bool> saveWarehouse(Warehouse warehouse);
  Future<bool> deleteWarehouse(String id);

  // 库存
  Future<List<Inventory>> getInventory({String? warehouseId, String? productId});
  Future<double> getStockQuantity(String productId, String skuId, String warehouseId);

  // 单据
  Future<List<Bill>> getBills({BillType? type, BillStatus? status, DateTime? startDate, DateTime? endDate});
  Future<Bill?> getBill(String id);
  Future<String> generateBillNo(BillType type);
  Future<bool> saveBill(Bill bill);
  Future<bool> deleteBill(String id);
  Future<bool> approveBill(String id);
  Future<bool> cancelBill(String id);

  // 统计
  Future<Statistics> getStatistics();

  // 用户
  Future<User> getCurrentUser();
  Future<List<Company>> getCompanies();
}

/// Mock 数据服务实现
class MockDataService implements DataService {
  final MockData _mockData = MockData();

  // 内部存储（支持增删改）
  List<Category> _categories = List.from(MockData.categories);
  List<Product> _products = List.from(MockData.products);
  List<Partner> _customers = List.from(MockData.customers);
  List<Partner> _suppliers = List.from(MockData.suppliers);
  List<Warehouse> _warehouses = List.from(MockData.warehouses);
  List<Inventory> _inventories = List.from(MockData.inventories);
  List<Bill> _bills = List.from(MockData.bills);

  // 模拟网络延迟
  Future<T> _delay<T>(T value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return value;
  }

  // ===================== 分类 =====================
  @override
  Future<List<Category>> getCategories() => _delay(_categories);

  @override
  Future<Category?> getCategory(String id) => _delay(
    _categories.where((c) => c.id == id).firstOrNull
  );

  @override
  Future<bool> saveCategory(Category category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
    } else {
      _categories.add(category);
    }
    return _delay(true);
  }

  @override
  Future<bool> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
    return _delay(true);
  }

  // ===================== 商品 =====================
  @override
  Future<List<Product>> getProducts({String? categoryId, String? keyword}) => _delay(() {
    var result = _products.where((p) => p.enabled).toList();
    if (categoryId != null) {
      result = result.where((p) => p.categoryId == categoryId).toList();
    }
    if (keyword != null && keyword.isNotEmpty) {
      result = result.where((p) => 
        p.name.contains(keyword) || 
        (p.barCode?.contains(keyword) ?? false)
      ).toList();
    }
    return result;
  }());

  @override
  Future<Product?> getProduct(String id) => _delay(
    _products.where((p) => p.id == id).firstOrNull
  );

  @override
  Future<bool> saveProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
    } else {
      _products.add(product);
    }
    return _delay(true);
  }

  @override
  Future<bool> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    return _delay(true);
  }

  // ===================== 往来单位 =====================
  @override
  Future<List<Partner>> getCustomers({String? keyword}) => _delay(() {
    var result = _customers.where((c) => c.enabled).toList();
    if (keyword != null && keyword.isNotEmpty) {
      result = result.where((c) => 
        c.name.contains(keyword) || 
        (c.phone?.contains(keyword) ?? false)
      ).toList();
    }
    return result;
  }());

  @override
  Future<List<Partner>> getSuppliers({String? keyword}) => _delay(() {
    var result = _suppliers.where((s) => s.enabled).toList();
    if (keyword != null && keyword.isNotEmpty) {
      result = result.where((s) => 
        s.name.contains(keyword) || 
        (s.phone?.contains(keyword) ?? false)
      ).toList();
    }
    return result;
  }());

  @override
  Future<Partner?> getPartner(String id) => _delay(() {
    final customer = _customers.where((c) => c.id == id).firstOrNull;
    final supplier = _suppliers.where((s) => s.id == id).firstOrNull;
    return customer ?? supplier;
  }());

  @override
  Future<bool> savePartner(Partner partner) async {
    final list = partner.type == PartnerType.customer ? _customers : _suppliers;
    final index = list.indexWhere((p) => p.id == partner.id);
    if (index >= 0) {
      list[index] = partner;
    } else {
      list.add(partner);
    }
    return _delay(true);
  }

  @override
  Future<bool> deletePartner(String id) async {
    _customers.removeWhere((c) => c.id == id);
    _suppliers.removeWhere((s) => s.id == id);
    return _delay(true);
  }

  // ===================== 仓库 =====================
  @override
  Future<List<Warehouse>> getWarehouses() => _delay(_warehouses.where((w) => w.enabled).toList());

  @override
  Future<Warehouse?> getWarehouse(String id) => _delay(
    _warehouses.where((w) => w.id == id).firstOrNull
  );

  @override
  Future<bool> saveWarehouse(Warehouse warehouse) async {
    final index = _warehouses.indexWhere((w) => w.id == warehouse.id);
    if (index >= 0) {
      _warehouses[index] = warehouse;
    } else {
      _warehouses.add(warehouse);
    }
    return _delay(true);
  }

  @override
  Future<bool> deleteWarehouse(String id) async {
    _warehouses.removeWhere((w) => w.id == id);
    return _delay(true);
  }

  // ===================== 库存 =====================
  @override
  Future<List<Inventory>> getInventory({String? warehouseId, String? productId}) => _delay(() {
    var result = _inventories;
    if (warehouseId != null) {
      result = result.where((i) => i.warehouseId == warehouseId).toList();
    }
    if (productId != null) {
      result = result.where((i) => i.productId == productId).toList();
    }
    return result;
  }());

  @override
  Future<double> getStockQuantity(String productId, String skuId, String warehouseId) => _delay(() {
    final inv = _inventories.where((i) => 
      i.productId == productId && 
      i.productSkuId == skuId && 
      i.warehouseId == warehouseId
    ).firstOrNull;
    return inv?.availableQuantity ?? 0;
  }());

  // ===================== 单据 =====================
  int _billCounter = 5; // 单据计数器

  @override
  Future<List<Bill>> getBills({BillType? type, BillStatus? status, DateTime? startDate, DateTime? endDate}) => _delay(() {
    var result = _bills;
    if (type != null) {
      result = result.where((b) => b.type == type).toList();
    }
    if (status != null) {
      result = result.where((b) => b.status == status).toList();
    }
    if (startDate != null) {
      result = result.where((b) => !b.billDate.isBefore(startDate)).toList();
    }
    if (endDate != null) {
      result = result.where((b) => !b.billDate.isAfter(endDate)).toList();
    }
    return result;
  }());

  @override
  Future<Bill?> getBill(String id) => _delay(
    _bills.where((b) => b.id == id).firstOrNull
  );

  @override
  Future<String> generateBillNo(BillType type) => _delay(() {
    _billCounter++;
    final prefix = type == BillType.salesOrder ? 'XS' : type == BillType.purchaseOrder ? 'CG' : 'QT';
    final date = DateTime.now().toString().substring(0, 10).replaceAll('-', '');
    return '$prefix${date}${_billCounter.toString().padLeft(4, '0')}';
  }());

  @override
  Future<bool> saveBill(Bill bill) async {
    final index = _bills.indexWhere((b) => b.id == bill.id);
    if (index >= 0) {
      _bills[index] = bill;
    } else {
      _bills.add(bill);
    }
    return _delay(true);
  }

  @override
  Future<bool> deleteBill(String id) async {
    _bills.removeWhere((b) => b.id == id);
    return _delay(true);
  }

  @override
  Future<bool> approveBill(String id) async {
    final index = _bills.indexWhere((b) => b.id == id);
    if (index >= 0) {
      final bill = _bills[index];
      _bills[index] = Bill(
        id: bill.id,
        billNo: bill.billNo,
        type: bill.type,
        status: BillStatus.approved,
        partnerId: bill.partnerId,
        partnerName: bill.partnerName,
        warehouseId: bill.warehouseId,
        warehouseName: bill.warehouseName,
        billDate: bill.billDate,
        details: bill.details,
        totalAmount: bill.totalAmount,
        discountAmount: bill.discountAmount,
        paidAmount: bill.paidAmount,
        arrearsAmount: bill.arrearsAmount,
        remark: bill.remark,
        operatorId: bill.operatorId,
        operatorName: bill.operatorName,
        createTime: bill.createTime,
        approveTime: DateTime.now(),
        approveUser: '管理员',
      );
    }
    return _delay(true);
  }

  @override
  Future<bool> cancelBill(String id) async {
    final index = _bills.indexWhere((b) => b.id == id);
    if (index >= 0) {
      final bill = _bills[index];
      _bills[index] = Bill(
        id: bill.id,
        billNo: bill.billNo,
        type: bill.type,
        status: BillStatus.cancelled,
        partnerId: bill.partnerId,
        partnerName: bill.partnerName,
        warehouseId: bill.warehouseId,
        warehouseName: bill.warehouseName,
        billDate: bill.billDate,
        details: bill.details,
        totalAmount: bill.totalAmount,
        discountAmount: bill.discountAmount,
        paidAmount: bill.paidAmount,
        arrearsAmount: bill.arrearsAmount,
        remark: bill.remark,
        operatorId: bill.operatorId,
        operatorName: bill.operatorName,
        createTime: bill.createTime,
        approveTime: bill.approveTime,
        approveUser: bill.approveUser,
      );
    }
    return _delay(true);
  }

  // ===================== 统计 =====================
  @override
  Future<Statistics> getStatistics() => _delay(MockData.getStatistics());

  // ===================== 用户 =====================
  @override
  Future<User> getCurrentUser() => _delay(MockData.currentUser);

  @override
  Future<List<Company>> getCompanies() => _delay(MockData.companies);
}

/// 全局数据服务实例
final DataService dataService = MockDataService();