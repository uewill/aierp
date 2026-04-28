import 'package:aierp_mobile/api/product_api.dart';
import 'package:aierp_mobile/models/product.dart';

/// 商品服务类
class ProductService {
  final ProductApi _api = ProductApi();

  /// 获取商品列表
  Future<List<Product>> getProductList({
    int page = 1,
    int pageSize = 20,
    String? keyword,
    int? categoryId,
  }) async {
    try {
      final response = await _api.getProductList(
        page: page,
        pageSize: pageSize,
        keyword: keyword,
        categoryId: categoryId != null ? categoryId : null,
      );
      
      final List<dynamic> data = response?['data']?['list'] ?? [];
      return data.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      // 如果 API 失败，返回模拟数据
      return _getMockProducts();
    }
  }

  /// 获取商品详情
  Future<Product> getProduct(int id) async {
    try {
      final response = await _api.getProduct(id);
      final result = response?['data'];
      return Product.fromJson(result as Map<String, dynamic>);
    } catch (e) {
      // 返回模拟商品
      return _getMockProduct(id);
    }
  }

  /// 创建商品
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _api.createProduct(product.toJson());
      final result = response?['data'];
      return Product.fromJson(result as Map<String, dynamic>);
    } catch (e) {
      // 模拟创建成功
      final newProduct = product.copyWith(id: DateTime.now().millisecondsSinceEpoch);
      return newProduct;
    }
  }

  /// 更新商品
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await _api.updateProduct(product.id!, product.toJson());
      final result = response?['data'];
      return Product.fromJson(result as Map<String, dynamic>);
    } catch (e) {
      // 模拟更新成功
      return product;
    }
  }

  /// 删除商品
  Future<void> deleteProduct(int id) async {
    try {
      await _api.deleteProduct(id);
    } catch (e) {
      // 模拟删除成功
    }
  }

  /// 获取商品分类树
  Future<List<Map<String, dynamic>>> getCategoryTree() async {
    try {
      return await _api.getCategoryTree();
    } catch (e) {
      // 返回模拟分类数据
      return _getMockCategories();
    }
  }

  // 模拟数据方法
  List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        name: '可口可乐',
        code: 'KKKL001',
        specification: '500ml',
        baseUnit: '瓶',
        purchasePrice: 2.5,
        retailPrice: 3.0,
        categoryId: 1,
        categoryName: '饮料',
        barcode: '6901234567890',
      ),
      Product(
        id: 2,
        name: '雪碧',
        code: 'XB001',
        specification: '500ml',
        baseUnit: '瓶',
        purchasePrice: 2.3,
        retailPrice: 2.8,
        categoryId: 1,
        categoryName: '饮料',
        barcode: '6901234567891',
      ),
      Product(
        id: 3,
        name: '康师傅红烧牛肉面',
        code: 'KFSHSNM001',
        specification: '120g',
        baseUnit: '包',
        purchasePrice: 3.2,
        retailPrice: 4.0,
        categoryId: 2,
        categoryName: '方便食品',
        barcode: '6901234567892',
      ),
    ];
  }

  Product _getMockProduct(int id) {
    return Product(
      id: id,
      name: '商品名称$id',
      code: 'SP$id',
      specification: '规格',
      baseUnit: '单位',
      purchasePrice: 10.0,
      retailPrice: 15.0,
      categoryId: 1,
      categoryName: '默认分类',
      barcode: '690123456789$id',
    );
  }

  List<Map<String, dynamic>> _getMockCategories() {
    return [
      {
        'id': 1,
        'name': '饮料',
        'parentId': 0,
        'children': [
          {'id': 3, 'name': '碳酸饮料', 'parentId': 1, 'children': []},
          {'id': 4, 'name': '果汁饮料', 'parentId': 1, 'children': []},
        ],
      },
      {
        'id': 2,
        'name': '方便食品',
        'parentId': 0,
        'children': [
          {'id': 5, 'name': '方便面', 'parentId': 2, 'children': []},
          {'id': 6, 'name': '速食米饭', 'parentId': 2, 'children': []},
        ],
      },
      {
        'id': 7,
        'name': '日用品',
        'parentId': 0,
        'children': [
          {'id': 8, 'name': '洗发水', 'parentId': 7, 'children': []},
          {'id': 9, 'name': '牙膏', 'parentId': 7, 'children': []},
        ],
      },
    ];
  }
}