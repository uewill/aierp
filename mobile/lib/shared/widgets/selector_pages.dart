import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/shared/models/basic_models.dart';
import '../../../shared/widgets/base_selector_page.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 商品选择器页面
/// 支持搜索、分页、扫码
class ProductSelectorPage extends BaseSelectorPage<ProductModel> {
  const ProductSelectorPage({
    super.key,
    super.multiSelect,
    super.selectedItems,
    super.title = '选择商品',
  });

  @override
  State<BaseSelectorPage<ProductModel>> createState() => ProductSelectorPageState();
}

class ProductSelectorPageState extends BaseSelectorPageState<ProductModel, ProductSelectorPage> {
  @override
  String getItemId(ProductModel item) => item.id;

  @override
  String getItemName(ProductModel item) => item.displayName;

  @override
  String? getItemSubtitle(ProductModel item) {
    return '库存: ${item.stock}${item.unit} | ${item.displayPrice}';
  }

  @override
  Future<List<ProductModel>> fetchData(String keyword, int page, int pageSize) async {
    // TODO: 调用实际 API
    // 模拟数据
    await Future.delayed(const Duration(milliseconds: 500));
    
    final mockData = [
      ProductModel(id: '1', code: 'P001', name: '可口可乐', spec: '500ml', unit: '瓶', salePrice: 3.5, stock: 1000),
      ProductModel(id: '2', code: 'P002', name: '雪碧', spec: '500ml', unit: '瓶', salePrice: 3.5, stock: 800),
      ProductModel(id: '3', code: 'P003', name: '农夫山泉', spec: '550ml', unit: '瓶', salePrice: 2.0, stock: 500),
      ProductModel(id: '4', code: 'P004', name: '青岛啤酒', spec: '500ml', unit: '瓶', salePrice: 5.0, stock: 200),
    ];
    
    if (keyword.isNotEmpty) {
      return mockData.where((p) => 
        p.name.contains(keyword) || 
        p.code.contains(keyword) ||
        (p.barcode?.contains(keyword) ?? false)
      ).toList();
    }
    
    return mockData;
  }

  @override
  Widget _buildListItem(ProductModel item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacer3),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderColor, width: 0.5)),
      ),
      child: Row(
        children: [
          // 商品图片
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.bgSecondaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
            ),
            child: const Icon(Icons.inventory_2_outlined, size: 28, color: AppTheme.textPlaceholder),
          ),
          const SizedBox(width: AppTheme.spacer3),
          
          // 商品信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  style: const TextStyle(fontSize: AppTheme.fontSizeS, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '库存: ${item.stock}${item.unit}',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeXs,
                    color: item.stock < 50 ? AppTheme.warningColor : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.displayPrice,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSizeM,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.errorColor,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacer2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.bgSecondaryContainer,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        '箱=24${item.unit}',
                        style: const TextStyle(fontSize: AppTheme.fontSizeLink, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 选择状态
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? AppTheme.brandColor : AppTheme.gray5,
            size: 24,
          ),
        ],
      ),
    );
  }
}

/// 客户选择器页面
class CustomerSelectorPage extends BaseSelectorPage<CustomerModel> {
  const CustomerSelectorPage({
    super.key,
    super.multiSelect = false,
    super.selectedItems,
    super.title = '选择客户',
  });

  @override
  State<BaseSelectorPage<CustomerModel>> createState() => CustomerSelectorPageState();
}

class CustomerSelectorPageState extends BaseSelectorPageState<CustomerModel, CustomerSelectorPage> {
  @override
  String getItemId(CustomerModel item) => item.id;

  @override
  String getItemName(CustomerModel item) => item.name;

  @override
  String? getItemSubtitle(CustomerModel item) {
    return '${item.levelDisplayName} | ${item.phone ?? ''}';
  }

  @override
  Future<List<CustomerModel>> fetchData(String keyword, int page, int pageSize) async {
    // TODO: 调用实际 API
    await Future.delayed(const Duration(milliseconds: 500));
    
    final mockData = [
      CustomerModel(id: '1', name: 'XX超市', phone: '138****1234', level: 'vip', balance: 500),
      CustomerModel(id: '2', name: 'YY批发部', phone: '139****5678', level: 'wholesale', balance: 0),
      CustomerModel(id: '3', name: 'ZZ便利店', phone: '137****9012', level: 'normal', balance: 1200),
    ];
    
    if (keyword.isNotEmpty) {
      return mockData.where((c) => 
        c.name.contains(keyword) || 
        (c.phone?.contains(keyword) ?? false)
      ).toList();
    }
    
    return mockData;
  }

  @override
  Widget _buildListItem(CustomerModel item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacer3),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderColor, width: 0.5)),
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.brandColorLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
            ),
            child: const Icon(Icons.store, size: 20, color: AppTheme.brandColor),
          ),
          const SizedBox(width: AppTheme.spacer3),
          
          // 客户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: AppTheme.fontSizeS, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: AppTheme.spacer2),
                    _buildLevelTag(item.level),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.phone ?? '',
                  style: const TextStyle(fontSize: AppTheme.fontSizeXs, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          
          // 欠款
          if (item.hasDebt)
            Text(
              '欠款 ¥${item.balance.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: AppTheme.fontSizeXs, color: AppTheme.errorColor),
            ),
          
          const SizedBox(width: AppTheme.spacer2),
          
          // 选择状态
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? AppTheme.brandColor : AppTheme.gray5,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTag(String level) {
    Color bgColor;
    Color textColor;
    String text;

    switch (level) {
      case 'vip':
        bgColor = const Color(0xFFFFECEC);
        textColor = AppTheme.errorColor;
        text = 'VIP';
        break;
      case 'wholesale':
        bgColor = AppTheme.brandColorLight;
        textColor = AppTheme.brandColor;
        text = '批发';
        break;
      default:
        bgColor = AppTheme.bgSecondaryContainer;
        textColor = AppTheme.textSecondary;
        text = '普通';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(text, style: TextStyle(fontSize: AppTheme.fontSizeLink, color: textColor)),
    );
  }
}

/// 仓库选择器页面
class WarehouseSelectorPage extends BaseSelectorPage<WarehouseModel> {
  const WarehouseSelectorPage({
    super.key,
    super.selectedItems,
    super.title = '选择仓库',
  });

  @override
  State<BaseSelectorPage<WarehouseModel>> createState() => WarehouseSelectorPageState();
}

class WarehouseSelectorPageState extends BaseSelectorPageState<WarehouseModel, WarehouseSelectorPage> {
  @override
  String getItemId(WarehouseModel item) => item.id;

  @override
  String getItemName(WarehouseModel item) => item.name;

  @override
  Future<List<WarehouseModel>> fetchData(String keyword, int page, int pageSize) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final mockData = [
      WarehouseModel(id: '1', name: '主仓库', address: '一号仓库'),
      WarehouseModel(id: '2', name: '分仓库A', address: '二号仓库'),
      WarehouseModel(id: '3', name: '门店仓库', address: '门店后仓'),
    ];
    
    if (keyword.isNotEmpty) {
      return mockData.where((w) => w.name.contains(keyword)).toList();
    }
    
    return mockData;
  }
}