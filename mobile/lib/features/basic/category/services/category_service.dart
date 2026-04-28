import 'package:aierp_mobile/api/category_api.dart';
import 'package:aierp_mobile/models/category.dart';

/// 商品分类服务类
class CategoryService {
  final CategoryApi _api = CategoryApi();

  /// 获取商品分类树
  Future<List<Category>> getCategoryTree() async {
    try {
      final data = await _api.getCategoryTree();
      return data.map((item) => Category.fromJson(item)).toList();
    } catch (e) {
      // 模拟数据
      return _getMockCategories();
    }
  }

  List<Category> _getMockCategories() {
    return [
      Category(
        id: 1,
        name: '饮料',
        code: 'YL',
        parentId: 0,
        level: 1,
        children: [
          Category(id: 3, name: '碳酸饮料', code: 'TQYL', parentId: 1, level: 2),
          Category(id: 4, name: '果汁饮料', code: 'GZYL', parentId: 1, level: 2),
        ],
      ),
      Category(
        id: 2,
        name: '方便食品',
        code: 'FFSP',
        parentId: 0,
        level: 1,
        children: [
          Category(id: 5, name: '方便面', code: 'FFM', parentId: 2, level: 2),
          Category(id: 6, name: '速食米饭', code: 'SSMF', parentId: 2, level: 2),
        ],
      ),
      Category(
        id: 7,
        name: '零食',
        code: 'LS',
        parentId: 0,
        level: 1,
        children: [
          Category(id: 8, name: '糖果', code: 'TG', parentId: 7, level: 2),
          Category(id: 9, name: '薯片', code: 'SP', parentId: 7, level: 2),
        ],
      ),
    ];
  }

  /// 创建商品分类
  Future<Category?> createCategory(Category category) async {
    try {
      final data = await _api.createCategory(category.toJson());
      if (data == null) return null;
      return Category.fromJson(data);
    } catch (e) {
      // 模拟创建成功
      return category.copyWith(id: 10);
    }
  }

  /// 更新商品分类
  Future<Category?> updateCategory(Category category) async {
    try {
      final data = await _api.updateCategory(category.id!, category.toJson());
      if (data == null) return null;
      return Category.fromJson(data);
    } catch (e) {
      // 模拟更新成功
      return category;
    }
  }
}