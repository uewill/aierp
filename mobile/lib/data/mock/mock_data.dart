/// Mock 数据服务
/// 提供模拟数据供开发测试使用

import 'package:aierp_mobile/data/models/models.dart';

class MockData {
  // 单例模式
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  // ===================== 分类数据 =====================
  static final List<Category> categories = [
    Category(id: 'cat_001', name: '食品饮料', level: 1, sort: 1),
    Category(id: 'cat_002', name: '日用百货', level: 1, sort: 2),
    Category(id: 'cat_003', name: '电子产品', level: 1, sort: 3),
    Category(id: 'cat_004', name: '服装鞋帽', level: 1, sort: 4),
    // 子分类
    Category(id: 'cat_101', name: '饮料', parentId: 'cat_001', level: 2, sort: 1),
    Category(id: 'cat_102', name: '零食', parentId: 'cat_001', level: 2, sort: 2),
    Category(id: 'cat_103', name: '粮油', parentId: 'cat_001', level: 2, sort: 3),
    Category(id: 'cat_201', name: '洗护用品', parentId: 'cat_002', level: 2, sort: 1),
    Category(id: 'cat_202', name: '家居用品', parentId: 'cat_002', level: 2, sort: 2),
    Category(id: 'cat_301', name: '手机配件', parentId: 'cat_003', level: 2, sort: 1),
    Category(id: 'cat_302', name: '电脑配件', parentId: 'cat_003', level: 2, sort: 2),
  ];

  // ===================== 单位数据 =====================
  static final List<Unit> units = [
    Unit(id: 'unit_001', name: '个', ratio: 1, baseUnitId: 'unit_001'),
    Unit(id: 'unit_002', name: '件', ratio: 1, baseUnitId: 'unit_002'),
    Unit(id: 'unit_003', name: '箱', ratio: 24, baseUnitId: 'unit_001'), // 1箱=24个
    Unit(id: 'unit_004', name: '包', ratio: 10, baseUnitId: 'unit_001'), // 1包=10个
    Unit(id: 'unit_005', name: '瓶', ratio: 1, baseUnitId: 'unit_005'),
    Unit(id: 'unit_006', name: '箱', ratio: 12, baseUnitId: 'unit_005'), // 1箱=12瓶
    Unit(id: 'unit_007', name: '千克', ratio: 1, baseUnitId: 'unit_007'),
    Unit(id: 'unit_008', name: '斤', ratio: 0.5, baseUnitId: 'unit_007'), // 1斤=0.5千克
  ];

  // ===================== 商品数据 =====================
  static final List<Product> products = [
    Product(
      id: 'prod_001',
      name: '农夫山泉矿泉水',
      categoryId: 'cat_101',
      brand: '农夫山泉',
      description: '550ml 矿泉水',
      unitId: 'unit_005',
      price: 2.5,
      costPrice: 1.8,
      barCode: '6901234567890',
      createTime: DateTime.now().subtract(Duration(days: 30)),
      units: [
        units[4], // 瓶
        units[5], // 箱
      ],
    ),
    Product(
      id: 'prod_002',
      name: '可口可乐',
      categoryId: 'cat_101',
      brand: '可口可乐',
      description: '330ml 碳酸饮料',
      unitId: 'unit_005',
      price: 3.0,
      costPrice: 2.2,
      barCode: '6901234567891',
      createTime: DateTime.now().subtract(Duration(days: 30)),
    ),
    Product(
      id: 'prod_003',
      name: '统一冰红茶',
      categoryId: 'cat_101',
      brand: '统一',
      description: '500ml 茶饮料',
      unitId: 'unit_005',
      price: 3.5,
      costPrice: 2.5,
      barCode: '6901234567892',
      createTime: DateTime.now().subtract(Duration(days: 25)),
    ),
    Product(
      id: 'prod_004',
      name: '奥利奥饼干',
      categoryId: 'cat_102',
      brand: '奥利奥',
      description: '原味夹心饼干',
      unitId: 'unit_001',
      price: 12.0,
      costPrice: 8.5,
      barCode: '6901234567893',
      createTime: DateTime.now().subtract(Duration(days: 20)),
    ),
    Product(
      id: 'prod_005',
      name: '德芙巧克力',
      categoryId: 'cat_102',
      brand: '德芙',
      description: '丝滑牛奶巧克力',
      unitId: 'unit_001',
      price: 25.0,
      costPrice: 18.0,
      barCode: '6901234567894',
      createTime: DateTime.now().subtract(Duration(days: 15)),
    ),
    Product(
      id: 'prod_006',
      name: '舒肤佳香皂',
      categoryId: 'cat_201',
      brand: '舒肤佳',
      description: '纯白香皂',
      unitId: 'unit_001',
      price: 5.0,
      costPrice: 3.5,
      barCode: '6901234567895',
      createTime: DateTime.now().subtract(Duration(days: 10)),
    ),
    Product(
      id: 'prod_007',
      name: '高露洁牙膏',
      categoryId: 'cat_201',
      brand: '高露洁',
      description: '全效牙膏',
      unitId: 'unit_001',
      price: 15.0,
      costPrice: 10.0,
      barCode: '6901234567896',
      createTime: DateTime.now().subtract(Duration(days: 5)),
    ),
    Product(
      id: 'prod_008',
      name: 'iPhone数据线',
      categoryId: 'cat_301',
      brand: 'Apple',
      description: 'Lightning数据线',
      unitId: 'unit_001',
      price: 30.0,
      costPrice: 20.0,
      barCode: '6901234567897',
      hasSpec: true,
      createTime: DateTime.now().subtract(Duration(days: 3)),
      skus: [
        ProductSku(
          id: 'sku_001',
          productId: 'prod_008',
          skuCode: 'SKU001',
          barCode: '69012345678971',
          price: 30.0,
          costPrice: 20.0,
          specValues: [
            SpecValue(id: 'sv_001', name: '1米', specId: 'spec_001'),
          ],
          unitId: 'unit_001',
        ),
        ProductSku(
          id: 'sku_002',
          productId: 'prod_008',
          skuCode: 'SKU002',
          barCode: '69012345678972',
          price: 45.0,
          costPrice: 28.0,
          specValues: [
            SpecValue(id: 'sv_002', name: '2米', specId: 'spec_001'),
          ],
          unitId: 'unit_001',
        ),
      ],
    ),
    Product(
      id: 'prod_009',
      name: '小米充电宝',
      categoryId: 'cat_301',
      brand: '小米',
      description: '移动电源',
      unitId: 'unit_001',
      price: 99.0,
      costPrice: 65.0,
      barCode: '6901234567898',
      hasSpec: true,
      createTime: DateTime.now().subtract(Duration(days: 2)),
      skus: [
        ProductSku(
          id: 'sku_003',
          productId: 'prod_009',
          skuCode: 'SKU003',
          barCode: '69012345678981',
          price: 99.0,
          costPrice: 65.0,
          specValues: [
            SpecValue(id: 'sv_003', name: '10000mAh', specId: 'spec_002'),
          ],
          unitId: 'unit_001',
        ),
        ProductSku(
          id: 'sku_004',
          productId: 'prod_009',
          skuCode: 'SKU004',
          barCode: '69012345678982',
          price: 149.0,
          costPrice: 95.0,
          specValues: [
            SpecValue(id: 'sv_004', name: '20000mAh', specId: 'spec_002'),
          ],
          unitId: 'unit_001',
        ),
      ],
    ),
    Product(
      id: 'prod_010',
      name: '金龙鱼大米',
      categoryId: 'cat_103',
      brand: '金龙鱼',
      description: '东北优质大米',
      unitId: 'unit_007',
      price: 5.0, // 每千克
      costPrice: 3.5,
      barCode: '6901234567899',
      createTime: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  // ===================== 往来单位数据 =====================
  static final List<Partner> customers = [
    Partner(
      id: 'cust_001',
      name: '张三便利店',
      type: PartnerType.customer,
      contact: '张三',
      phone: '13800138001',
      address: '成都市高新区xxx街道',
      creditLimit: 50000,
      balance: 3200,
      createTime: DateTime.now().subtract(Duration(days: 60)),
    ),
    Partner(
      id: 'cust_002',
      name: '李四超市',
      type: PartnerType.customer,
      contact: '李四',
      phone: '13800138002',
      address: '成都市武侯区xxx街道',
      creditLimit: 100000,
      balance: -5000,
      createTime: DateTime.now().subtract(Duration(days: 50)),
    ),
    Partner(
      id: 'cust_003',
      name: '王五批发部',
      type: PartnerType.customer,
      contact: '王五',
      phone: '13800138003',
      address: '成都市金牛区xxx街道',
      creditLimit: 200000,
      balance: 0,
      createTime: DateTime.now().subtract(Duration(days: 40)),
    ),
    Partner(
      id: 'cust_004',
      name: '赵六餐饮店',
      type: PartnerType.customer,
      contact: '赵六',
      phone: '13800138004',
      address: '成都市锦江区xxx街道',
      creditLimit: 30000,
      balance: 1500,
      createTime: DateTime.now().subtract(Duration(days: 30)),
    ),
  ];

  static final List<Partner> suppliers = [
    Partner(
      id: 'supp_001',
      name: '农夫山泉成都分公司',
      type: PartnerType.supplier,
      contact: '陈经理',
      phone: '13900139001',
      address: '成都市高新区农夫路',
      bankName: '工商银行',
      bankAccount: '1234567890',
      createTime: DateTime.now().subtract(Duration(days: 90)),
    ),
    Partner(
      id: 'supp_002',
      name: '可口可乐四川总代理',
      type: PartnerType.supplier,
      contact: '刘经理',
      phone: '13900139002',
      address: '成都市武侯区可乐街',
      bankName: '建设银行',
      bankAccount: '2234567890',
      createTime: DateTime.now().subtract(Duration(days: 80)),
    ),
    Partner(
      id: 'supp_003',
      name: '统一食品批发',
      type: PartnerType.supplier,
      contact: '周经理',
      phone: '13900139003',
      address: '成都市金牛区统一路',
      bankName: '农业银行',
      bankAccount: '3234567890',
      createTime: DateTime.now().subtract(Duration(days: 70)),
    ),
    Partner(
      id: 'supp_004',
      name: '数码配件供应商',
      type: PartnerType.supplier,
      contact: '吴经理',
      phone: '13900139004',
      address: '深圳市华强北',
      bankName: '招商银行',
      bankAccount: '4234567890',
      createTime: DateTime.now().subtract(Duration(days: 60)),
    ),
  ];

  // ===================== 仓库数据 =====================
  static final List<Warehouse> warehouses = [
    Warehouse(
      id: 'wh_001',
      name: '主仓库',
      address: '成都市高新区仓库路1号',
      manager: '管理员',
      phone: '028-12345678',
      isDefault: true,
      createTime: DateTime.now().subtract(Duration(days: 365)),
    ),
    Warehouse(
      id: 'wh_002',
      name: '备用仓库',
      address: '成都市武侯区仓库路2号',
      manager: '仓库员',
      phone: '028-12345679',
      createTime: DateTime.now().subtract(Duration(days: 180)),
    ),
  ];

  // ===================== 库存数据 =====================
  static final List<Inventory> inventories = [
    Inventory(
      productId: 'prod_001',
      productSkuId: 'prod_001',
      warehouseId: 'wh_001',
      quantity: 500,
      frozenQuantity: 50,
      costPrice: 1.8,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_002',
      productSkuId: 'prod_002',
      warehouseId: 'wh_001',
      quantity: 300,
      costPrice: 2.2,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_003',
      productSkuId: 'prod_003',
      warehouseId: 'wh_001',
      quantity: 200,
      costPrice: 2.5,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_004',
      productSkuId: 'prod_004',
      warehouseId: 'wh_001',
      quantity: 100,
      costPrice: 8.5,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_005',
      productSkuId: 'prod_005',
      warehouseId: 'wh_001',
      quantity: 50,
      costPrice: 18.0,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_008',
      productSkuId: 'sku_001',
      warehouseId: 'wh_001',
      quantity: 80,
      costPrice: 20.0,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_008',
      productSkuId: 'sku_002',
      warehouseId: 'wh_001',
      quantity: 40,
      costPrice: 28.0,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_009',
      productSkuId: 'sku_003',
      warehouseId: 'wh_001',
      quantity: 30,
      costPrice: 65.0,
      updateTime: DateTime.now(),
    ),
    Inventory(
      productId: 'prod_009',
      productSkuId: 'sku_004',
      warehouseId: 'wh_001',
      quantity: 20,
      costPrice: 95.0,
      updateTime: DateTime.now(),
    ),
  ];

  // ===================== 单据数据 =====================
  static final List<Bill> bills = [
    // 销售单
    Bill(
      id: 'bill_001',
      billNo: 'XS202604210001',
      type: BillType.salesOrder,
      status: BillStatus.approved,
      partnerId: 'cust_001',
      partnerName: '张三便利店',
      warehouseId: 'wh_001',
      warehouseName: '主仓库',
      billDate: DateTime.now(),
      details: [
        BillDetail(
          id: 'detail_001',
          productId: 'prod_001',
          productSkuId: 'prod_001',
          productName: '农夫山泉矿泉水',
          skuName: '',
          unitId: 'unit_005',
          unitName: '瓶',
          quantity: 100,
          price: 2.5,
          amount: 250,
        ),
        BillDetail(
          id: 'detail_002',
          productId: 'prod_002',
          productSkuId: 'prod_002',
          productName: '可口可乐',
          skuName: '',
          unitId: 'unit_005',
          unitName: '瓶',
          quantity: 50,
          price: 3.0,
          amount: 150,
        ),
      ],
      totalAmount: 400,
      paidAmount: 400,
      operatorName: '管理员',
      createTime: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Bill(
      id: 'bill_002',
      billNo: 'XS202604210002',
      type: BillType.salesOrder,
      status: BillStatus.pending,
      partnerId: 'cust_002',
      partnerName: '李四超市',
      warehouseId: 'wh_001',
      warehouseName: '主仓库',
      billDate: DateTime.now(),
      details: [
        BillDetail(
          id: 'detail_003',
          productId: 'prod_008',
          productSkuId: 'sku_001',
          productName: 'iPhone数据线',
          skuName: '1米',
          unitId: 'unit_001',
          unitName: '个',
          quantity: 10,
          price: 30,
          amount: 300,
        ),
      ],
      totalAmount: 300,
      paidAmount: 0,
      arrearsAmount: 300,
      operatorName: '管理员',
      createTime: DateTime.now().subtract(Duration(hours: 1)),
    ),
    // 采购单
    Bill(
      id: 'bill_003',
      billNo: 'CG202604210001',
      type: BillType.purchaseOrder,
      status: BillStatus.approved,
      partnerId: 'supp_001',
      partnerName: '农夫山泉成都分公司',
      warehouseId: 'wh_001',
      warehouseName: '主仓库',
      billDate: DateTime.now(),
      details: [
        BillDetail(
          id: 'detail_004',
          productId: 'prod_001',
          productSkuId: 'prod_001',
          productName: '农夫山泉矿泉水',
          skuName: '',
          unitId: 'unit_006',
          unitName: '箱',
          quantity: 50, // 50箱 = 600瓶
          price: 21.6, // 每箱成本
          amount: 1080,
        ),
      ],
      totalAmount: 1080,
      paidAmount: 1080,
      operatorName: '管理员',
      createTime: DateTime.now().subtract(Duration(hours: 3)),
    ),
    Bill(
      id: 'bill_004',
      billNo: 'CG202604210002',
      type: BillType.purchaseOrder,
      status: BillStatus.pending,
      partnerId: 'supp_004',
      partnerName: '数码配件供应商',
      warehouseId: 'wh_001',
      warehouseName: '主仓库',
      billDate: DateTime.now(),
      details: [
        BillDetail(
          id: 'detail_005',
          productId: 'prod_009',
          productSkuId: 'sku_003',
          productName: '小米充电宝',
          skuName: '10000mAh',
          unitId: 'unit_001',
          unitName: '个',
          quantity: 20,
          price: 65,
          amount: 1300,
        ),
        BillDetail(
          id: 'detail_006',
          productId: 'prod_009',
          productSkuId: 'sku_004',
          productName: '小米充电宝',
          skuName: '20000mAh',
          unitId: 'unit_001',
          unitName: '个',
          quantity: 10,
          price: 95,
          amount: 950,
        ),
      ],
      totalAmount: 2250,
      paidAmount: 0,
      arrearsAmount: 2250,
      operatorName: '管理员',
      createTime: DateTime.now().subtract(Duration(minutes: 30)),
    ),
  ];

  // ===================== 用户数据 =====================
  static final User currentUser = User(
    id: 'user_001',
    username: 'admin',
    name: '管理员',
    phone: '18190780080',
    companyId: 'company_001',
    companyName: '任我行软件',
    roles: ['admin', 'manager'],
  );

  static final List<Company> companies = [
    Company(
      id: 'company_001',
      name: '任我行软件',
      address: '天府软件园D2',
      phone: '028-12345678',
    ),
  ];

  // ===================== 统计数据 =====================
  static Statistics getStatistics() {
    final todaySalesBills = bills.where((b) => 
      b.type == BillType.salesOrder && 
      b.billDate.day == DateTime.now().day
    );
    
    final todayPurchaseBills = bills.where((b) => 
      b.type == BillType.purchaseOrder && 
      b.billDate.day == DateTime.now().day
    );

    return Statistics(
      todaySales: todaySalesBills.fold(0, (sum, b) => sum + b.totalAmount),
      todayPurchase: todayPurchaseBills.fold(0, (sum, b) => sum + b.totalAmount),
      todaySalesCount: todaySalesBills.length,
      todayPurchaseCount: todayPurchaseBills.length,
      monthSales: 125000,
      monthPurchase: 85000,
      pendingBills: bills.where((b) => b.status == BillStatus.pending).length,
      lowStockCount: 3,
      totalInventoryValue: inventories.fold(0, (sum, i) => sum + i.quantity * i.costPrice),
    );
  }
}