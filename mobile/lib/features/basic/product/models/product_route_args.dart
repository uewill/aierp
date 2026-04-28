import 'package:aierp_mobile/models/product.dart';

/// 商品页面路由参数
class ProductRouteArgs {
  final Product? product;
  final bool isEdit;
  
  ProductRouteArgs({this.product, this.isEdit = false});
}