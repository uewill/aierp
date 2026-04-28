/// 用户模型
class User {
  final String id;
  final String phone;
  final String name;
  final String? avatar;
  final String? token;

  User({
    required this.id,
    required this.phone,
    required this.name,
    this.avatar,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone': phone,
    'name': name,
    'avatar': avatar,
    'token': token,
  };
}

/// 商品模型
class ProductModel {
  final String id;
  final String code;
  final String name;
  final String? barcode;
  final String? spec;
  final String unit;
  final double? purchasePrice;
  final double salePrice;
  final int? shelfLife;
  final String? categoryId;
  final String? categoryName;
  final int stock;
  final String? imageUrl;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.code,
    required this.name,
    this.barcode,
    this.spec,
    required this.unit,
    this.purchasePrice,
    required this.salePrice,
    this.shelfLife,
    this.categoryId,
    this.categoryName,
    this.stock = 0,
    this.imageUrl,
    this.isActive = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      barcode: json['barcode']?.toString(),
      spec: json['spec']?.toString(),
      unit: json['unit']?.toString() ?? '件',
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0,
      shelfLife: json['shelfLife'] as int?,
      categoryId: json['categoryId']?.toString(),
      categoryName: json['categoryName']?.toString(),
      stock: json['stock'] as int? ?? 0,
      imageUrl: json['imageUrl']?.toString(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'barcode': barcode,
    'spec': spec,
    'unit': unit,
    'purchasePrice': purchasePrice,
    'salePrice': salePrice,
    'shelfLife': shelfLife,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'stock': stock,
    'imageUrl': imageUrl,
    'isActive': isActive,
  };

  /// 显示名称（规格）
  String get displayName => spec != null && spec!.isNotEmpty 
    ? '$name $spec' 
    : name;

  /// 显示价格
  String get displayPrice => '¥${salePrice.toStringAsFixed(2)}';
}

/// 客户模型
class CustomerModel {
  final String id;
  final String name;
  final String? contact;
  final String? phone;
  final String? address;
  final String level;
  final double creditLimit;
  final double balance;
  final int creditDays;
  final bool isActive;

  CustomerModel({
    required this.id,
    required this.name,
    this.contact,
    this.phone,
    this.address,
    this.level = 'normal',
    this.creditLimit = 0,
    this.balance = 0,
    this.creditDays = 0,
    this.isActive = true,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      contact: json['contact']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      level: json['level']?.toString() ?? 'normal',
      creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      creditDays: json['creditDays'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'contact': contact,
    'phone': phone,
    'address': address,
    'level': level,
    'creditLimit': creditLimit,
    'balance': balance,
    'creditDays': creditDays,
    'isActive': isActive,
  };

  /// 客户等级显示名称
  String get levelDisplayName {
    switch (level) {
      case 'vip':
        return 'VIP客户';
      case 'wholesale':
        return '批发客户';
      default:
        return '普通客户';
    }
  }

  /// 是否有欠款
  bool get hasDebt => balance > 0;
}

/// 供应商模型
class SupplierModel {
  final String id;
  final String name;
  final String? contact;
  final String? phone;
  final String? address;
  final String settlementType;
  final bool isActive;

  SupplierModel({
    required this.id,
    required this.name,
    this.contact,
    this.phone,
    this.address,
    this.settlementType = 'cash',
    this.isActive = true,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      contact: json['contact']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      settlementType: json['settlementType']?.toString() ?? 'cash',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'contact': contact,
    'phone': phone,
    'address': address,
    'settlementType': settlementType,
    'isActive': isActive,
  };
}

/// 仓库模型
class WarehouseModel {
  final String id;
  final String name;
  final String? address;
  final String? manager;
  final bool isActive;

  WarehouseModel({
    required this.id,
    required this.name,
    this.address,
    this.manager,
    this.isActive = true,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString(),
      manager: json['manager']?.toString(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'manager': manager,
    'isActive': isActive,
  };
}