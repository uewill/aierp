/// 进销存系统数据模型定义
/// 所有模型使用 Equatable 支持对象比较

import 'package:equatable/equatable.dart';

/// 商品分类模型
class Category extends Equatable {
  final String id;
  final String name;
  final String? parentId;
  final int level;
  final int sort;
  final bool enabled;
  final List<Category> children;

  const Category({
    required this.id,
    required this.name,
    this.parentId,
    this.level = 1,
    this.sort = 0,
    this.enabled = true,
    this.children = const [],
  });

  @override
  List<Object?> get props => [id, name, parentId, level, sort, enabled, children];

  Category copyWith({
    String? id,
    String? name,
    String? parentId,
    int? level,
    int? sort,
    bool? enabled,
    List<Category>? children,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      sort: sort ?? this.sort,
      enabled: enabled ?? this.enabled,
      children: children ?? this.children,
    );
  }
}

/// 商品单位
class Unit extends Equatable {
  final String id;
  final String name;
  final double ratio; // 与基本单位的换算比例
  final String baseUnitId;

  const Unit({
    required this.id,
    required this.name,
    this.ratio = 1.0,
    required this.baseUnitId,
  });

  @override
  List<Object?> get props => [id, name, ratio, baseUnitId];
}

/// 商品规格值
class SpecValue extends Equatable {
  final String id;
  final String name;
  final String specId;

  const SpecValue({
    required this.id,
    required this.name,
    required this.specId,
  });

  @override
  List<Object?> get props => [id, name, specId];
}

/// 商品SKU
class ProductSku extends Equatable {
  final String id;
  final String productId;
  final String skuCode;
  final String? barCode;
  final double price;
  final double costPrice;
  final List<SpecValue> specValues;
  final String unitId;

  const ProductSku({
    required this.id,
    required this.productId,
    required this.skuCode,
    this.barCode,
    required this.price,
    required this.costPrice,
    required this.specValues,
    required this.unitId,
  });

  @override
  List<Object?> get props => [id, productId, skuCode, barCode, price, costPrice, specValues, unitId];
  
  /// 获取规格名称组合
  String get specName => specValues.map((v) => v.name).join('/');
}

/// 商品模型
class Product extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String? brand;
  final String? description;
  final String unitId;
  final double price;
  final double costPrice;
  final String? barCode;
  final bool enabled;
  final bool hasSpec; // 是否多规格
  final List<ProductSku>? skus;
  final List<Unit>? units; // 多单位支持
  final DateTime createTime;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    this.brand,
    this.description,
    required this.unitId,
    required this.price,
    required this.costPrice,
    this.barCode,
    this.enabled = true,
    this.hasSpec = false,
    this.skus,
    this.units,
    required this.createTime,
  });

  @override
  List<Object?> get props => [id, name, categoryId, brand, description, unitId, price, costPrice, barCode, enabled, hasSpec, skus, units, createTime];

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? brand,
    String? description,
    String? unitId,
    double? price,
    double? costPrice,
    String? barCode,
    bool? enabled,
    bool? hasSpec,
    List<ProductSku>? skus,
    List<Unit>? units,
    DateTime? createTime,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      unitId: unitId ?? this.unitId,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      barCode: barCode ?? this.barCode,
      enabled: enabled ?? this.enabled,
      hasSpec: hasSpec ?? this.hasSpec,
      skus: skus ?? this.skus,
      units: units ?? this.units,
      createTime: createTime ?? this.createTime,
    );
  }
  
  /// 获取分类名称（需要从分类列表查找）
  String getCategoryName(List<Category> categories) {
    final cat = categories.where((c) => c.id == categoryId).firstOrNull;
    return cat?.name ?? '未分类';
  }
}

/// 往来单位类型
enum PartnerType {
  customer, // 客户
  supplier, // 供应商
}

/// 往来单位模型（客户/供应商）
class Partner extends Equatable {
  final String id;
  final String name;
  final PartnerType type;
  final String? contact;
  final String? phone;
  final String? address;
  final String? bankName;
  final String? bankAccount;
  final String? taxNumber;
  final double creditLimit; // 信用额度
  final double balance; // 当前余额
  final bool enabled;
  final DateTime createTime;

  const Partner({
    required this.id,
    required this.name,
    required this.type,
    this.contact,
    this.phone,
    this.address,
    this.bankName,
    this.bankAccount,
    this.taxNumber,
    this.creditLimit = 0,
    this.balance = 0,
    this.enabled = true,
    required this.createTime,
  });

  @override
  List<Object?> get props => [id, name, type, contact, phone, address, bankName, bankAccount, taxNumber, creditLimit, balance, enabled, createTime];

  Partner copyWith({
    String? id,
    String? name,
    PartnerType? type,
    String? contact,
    String? phone,
    String? address,
    String? bankName,
    String? bankAccount,
    String? taxNumber,
    double? creditLimit,
    double? balance,
    bool? enabled,
    DateTime? createTime,
  }) {
    return Partner(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bankName: bankName ?? this.bankName,
      bankAccount: bankAccount ?? this.bankAccount,
      taxNumber: taxNumber ?? this.taxNumber,
      creditLimit: creditLimit ?? this.creditLimit,
      balance: balance ?? this.balance,
      enabled: enabled ?? this.enabled,
      createTime: createTime ?? this.createTime,
    );
  }
}

/// 仓库模型
class Warehouse extends Equatable {
  final String id;
  final String name;
  final String? address;
  final String? manager;
  final String? phone;
  final bool enabled;
  final bool isDefault;
  final DateTime createTime;

  const Warehouse({
    required this.id,
    required this.name,
    this.address,
    this.manager,
    this.phone,
    this.enabled = true,
    this.isDefault = false,
    required this.createTime,
  });

  @override
  List<Object?> get props => [id, name, address, manager, phone, enabled, isDefault, createTime];

  Warehouse copyWith({
    String? id,
    String? name,
    String? address,
    String? manager,
    String? phone,
    bool? enabled,
    bool? isDefault,
    DateTime? createTime,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      manager: manager ?? this.manager,
      phone: phone ?? this.phone,
      enabled: enabled ?? this.enabled,
      isDefault: isDefault ?? this.isDefault,
      createTime: createTime ?? this.createTime,
    );
  }
}

/// 库存记录
class Inventory extends Equatable {
  final String productId;
  final String productSkuId;
  final String warehouseId;
  final double quantity;
  final double frozenQuantity; // 冻结数量（已下单未出库）
  final double costPrice;
  final DateTime updateTime;

  const Inventory({
    required this.productId,
    required this.productSkuId,
    required this.warehouseId,
    required this.quantity,
    this.frozenQuantity = 0,
    required this.costPrice,
    required this.updateTime,
  });

  @override
  List<Object?> get props => [productId, productSkuId, warehouseId, quantity, frozenQuantity, costPrice, updateTime];

  /// 可用数量
  double get availableQuantity => quantity - frozenQuantity;
}

/// 单据类型
enum BillType {
  salesOrder,    // 销售单
  purchaseOrder, // 采购单
  salesReturn,   // 销售退货
  purchaseReturn, // 采购退货
  stockIn,       // 其他入库
  stockOut,      // 其他出库
  transfer,      // 调拨单
}

/// 单据状态
enum BillStatus {
  draft,      // 草稿
  pending,    // 待审核
  approved,   // 已审核
  rejected,   // 已驳回
  completed,  // 已完成
  cancelled,  // 已取消
}

/// 单据明细
class BillDetail extends Equatable {
  final String id;
  final String productId;
  final String productSkuId;
  final String productName;
  final String skuName;
  final String unitId;
  final String unitName;
  final double quantity;
  final double price;
  final double discount;
  final double amount;
  final String? remark;

  const BillDetail({
    required this.id,
    required this.productId,
    required this.productSkuId,
    required this.productName,
    required this.skuName,
    required this.unitId,
    required this.unitName,
    required this.quantity,
    required this.price,
    this.discount = 0,
    required this.amount,
    this.remark,
  });

  @override
  List<Object?> get props => [id, productId, productSkuId, productName, skuName, unitId, unitName, quantity, price, discount, amount, remark];
}

/// 单据模型
class Bill extends Equatable {
  final String id;
  final String billNo;
  final BillType type;
  final BillStatus status;
  final String? partnerId; // 往来单位ID
  final String? partnerName;
  final String warehouseId;
  final String? warehouseName;
  final DateTime billDate;
  final List<BillDetail> details;
  final double totalAmount;
  final double discountAmount;
  final double paidAmount;
  final double arrearsAmount; // 欠款金额
  final String? remark;
  final String? operatorId;
  final String? operatorName;
  final DateTime createTime;
  final DateTime? approveTime;
  final String? approveUser;

  const Bill({
    required this.id,
    required this.billNo,
    required this.type,
    required this.status,
    this.partnerId,
    this.partnerName,
    required this.warehouseId,
    this.warehouseName,
    required this.billDate,
    required this.details,
    required this.totalAmount,
    this.discountAmount = 0,
    this.paidAmount = 0,
    this.arrearsAmount = 0,
    this.remark,
    this.operatorId,
    this.operatorName,
    required this.createTime,
    this.approveTime,
    this.approveUser,
  });

  @override
  List<Object?> get props => [id, billNo, type, status, partnerId, partnerName, warehouseId, warehouseName, billDate, details, totalAmount, discountAmount, paidAmount, arrearsAmount, remark, operatorId, operatorName, createTime, approveTime, approveUser];

  /// 获取单据类型名称
  String get typeName {
    switch (type) {
      case BillType.salesOrder: return '销售单';
      case BillType.purchaseOrder: return '采购单';
      case BillType.salesReturn: return '销售退货';
      case BillType.purchaseReturn: return '采购退货';
      case BillType.stockIn: return '其他入库';
      case BillType.stockOut: return '其他出库';
      case BillType.transfer: return '调拨单';
    }
  }

  /// 获取状态名称
  String get statusName {
    switch (status) {
      case BillStatus.draft: return '草稿';
      case BillStatus.pending: return '待审核';
      case BillStatus.approved: return '已审核';
      case BillStatus.rejected: return '已驳回';
      case BillStatus.completed: return '已完成';
      case BillStatus.cancelled: return '已取消';
    }
  }
}

/// 用户模型
class User extends Equatable {
  final String id;
  final String username;
  final String name;
  final String? phone;
  final String? avatar;
  final String? companyId;
  final String? companyName;
  final List<String> roles;
  final bool enabled;

  const User({
    required this.id,
    required this.username,
    required this.name,
    this.phone,
    this.avatar,
    this.companyId,
    this.companyName,
    required this.roles,
    this.enabled = true,
  });

  @override
  List<Object?> get props => [id, username, name, phone, avatar, companyId, companyName, roles, enabled];
}

/// 公司模型
class Company extends Equatable {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? taxNumber;
  final String? logo;

  const Company({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.taxNumber,
    this.logo,
  });

  @override
  List<Object?> get props => [id, name, address, phone, taxNumber, logo];
}

/// 统计数据模型
class Statistics extends Equatable {
  final double todaySales;
  final double todayPurchase;
  final int todaySalesCount;
  final int todayPurchaseCount;
  final double monthSales;
  final double monthPurchase;
  final int pendingBills;
  final int lowStockCount;
  final double totalInventoryValue;

  const Statistics({
    this.todaySales = 0,
    this.todayPurchase = 0,
    this.todaySalesCount = 0,
    this.todayPurchaseCount = 0,
    this.monthSales = 0,
    this.monthPurchase = 0,
    this.pendingBills = 0,
    this.lowStockCount = 0,
    this.totalInventoryValue = 0,
  });

  @override
  List<Object?> get props => [todaySales, todayPurchase, todaySalesCount, todayPurchaseCount, monthSales, monthPurchase, pendingBills, lowStockCount, totalInventoryValue];
}