import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 商品创建/编辑页面 - Tab式结构
/// 支持单规格和多规格商品，多单位管理

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/models/models.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:aierp_mobile/models/spec_attribute.dart';
import 'package:aierp_mobile/models/unit_conversion.dart';
import 'package:aierp_mobile/features/basic/product/widgets/spec_attribute_editor.dart';
import 'package:aierp_mobile/features/basic/product/widgets/unit_conversion_editor.dart';

class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({super.key});

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  // 表单数据 - 基础信息
  String? _productId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _barCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _categoryId;
  String _baseUnit = '个';
  final TextEditingController _baseUnitController = TextEditingController(text: '个');
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  
  // 规格型号数据
  bool _hasSpec = false;
  List<SpecAttribute> _specAttributes = [];
  List<ProductSku> _generatedSkus = [];
  
  // 单位设置数据
  List<UnitConversion> _unitConversions = [];
  
  bool _isLoading = false;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barCodeController.dispose();
    _descriptionController.dispose();
    _baseUnitController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await context.read<CategoryProvider>().loadCategories();
    
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      _productId = args;
      await _loadProduct(args);
    }
  }

  Future<void> _loadProduct(String id) async {
    setState(() => _isLoading = true);
    // TODO: 从API加载商品数据
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(_productId == null ? '添加商品' : '编辑商品'),
        backgroundColor: AppTheme.brandColor7,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _buildBasicInfoTab(context),
                  _buildSpecTab(context),
                  _buildUnitTab(context),
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  /// Tab导航栏
  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem(context, 0, '基础信息', Icons.home),
          _buildTabItem(context, 1, '规格型号', Icons.view_module),
          _buildTabItem(context, 2, '单位设置', Icons.swap_horiz),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, int index, String title, IconData icon) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppTheme.brandColor7 : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.brandColor7 : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppTheme.brandColor7 : Colors.grey[600]!,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tab 1: 基础信息 - 卡片式布局
  Widget _buildBasicInfoTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品基本信息卡片
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.inventory_2, color: AppTheme.brandColor8, size: 20),
                    const SizedBox(width: 8),
                    const Text('商品信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 商品名称
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '商品名称',
                    hintText: '请输入商品名称',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 商品分类
                _buildCategorySelector(context),
                
                const SizedBox(height: 12),
                
                // 品牌
                TextField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: '品牌',
                    hintText: '可选',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 条码
                TextField(
                  controller: _barCodeController,
                  decoration: InputDecoration(
                    labelText: '条码',
                    hintText: '可选',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 描述
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: '商品描述',
                    hintText: '可选',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 价格和单位卡片
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.payments_outlined, color: AppTheme.brandColor8, size: 20),
                    const SizedBox(width: 8),
                    const Text('价格和单位', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 基础单位
                TextField(
                  controller: _baseUnitController,
                  decoration: InputDecoration(
                    labelText: '基础单位',
                    hintText: '如：个、件、瓶',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (text) {
                    setState(() => _baseUnit = text);
                  },
                ),
                
                const SizedBox(height: 12),
                
                // 售价
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: '售价',
                    hintText: '0.00',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    prefixText: '¥ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
                
                const SizedBox(height: 12),
                
                // 成本价
                TextField(
                  controller: _costPriceController,
                  decoration: InputDecoration(
                    labelText: '成本价',
                    hintText: '0.00',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    prefixText: '¥ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  '基础价格适用于单规格商品或SKU默认价格',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categories = categoryProvider.categories.where((c) => c.level == 1).toList();
        final selectedCategory = categories.where((c) => c.id == _categoryId).firstOrNull;
        
        return GestureDetector(
          onTap: () => _showCategoryPicker(context, categories),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.category_outlined, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  '商品分类',
                  style: const TextStyle(fontSize: 14),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selectedCategory != null ? AppTheme.brandColor1 : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: selectedCategory != null 
                      ? Border.all(color: AppTheme.brandColor6)
                      : Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(
                    selectedCategory?.name ?? '请选择',
                    style: TextStyle(
                      color: selectedCategory != null ? AppTheme.brandColor8 : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: Colors.grey.shade600),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCategoryPicker(BuildContext context, List<Category> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Container(
        height: 300,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('选择分类', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category.id == _categoryId;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _categoryId = category.id);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.brandColor1 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected 
                          ? Border.all(color: AppTheme.brandColor8, width: 2)
                          : Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: isSelected ? AppTheme.brandColor8 : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppTheme.brandColor8 : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Icon(Icons.check_circle, color: AppTheme.brandColor8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tab 2: 规格型号 - 卡片式布局
  Widget _buildSpecTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 规格开关卡片
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.view_module, color: AppTheme.brandColor8, size: 20),
                        const SizedBox(width: 8),
                        const Text('多规格商品', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _hasSpec ? '启用多规格，可设置不同规格价格' : '单规格商品，使用基础价格',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
                Switch(
                  value: _hasSpec,
                  onChanged: (value) => setState(() => _hasSpec = value),
                  activeColor: AppTheme.brandColor8,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 规格属性编辑器（卡片式）
          if (_hasSpec)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.layers, color: AppTheme.brandColor8, size: 20),
                      const SizedBox(width: 8),
                      const Text('规格属性', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '添加规格属性，系统将自动生成SKU组合',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  SpecAttributeEditor(
                    attributes: _specAttributes,
                    onAttributesChanged: (attributes) {
                      setState(() => _specAttributes = attributes);
                      _generateSkus();
                    },
                  ),
                ],
              ),
            ),
          
          // 生成的SKU列表卡片
          if (_hasSpec && _generatedSkus.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.grid_view, color: AppTheme.brandColor8, size: 20),
                      const SizedBox(width: 8),
                      const Text('SKU列表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '已生成 ${_generatedSkus.length} 个SKU组合',
                      style: const TextStyle(color: Color(0xFFFF4D4F), fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._generatedSkus.map((sku) => _buildSkuCard(context, sku)),
                ],
              ),
            ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  /// SKU卡片 - 参考图片样式
  Widget _buildSkuCard(BuildContext context, ProductSku sku) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // SKU规格值标签
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: sku.specValues.map((v) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F0),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFFF4D4F)),
                    ),
                    child: Text(v.name, style: const TextStyle(color: Color(0xFFFF4D4F), fontSize: 11)),
                  )).toList(),
                ),
                const SizedBox(height: 4),
                Text(
                  '条码: ${sku.barCode ?? "-"}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          // 价格信息
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${sku.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFF4D4F)),
              ),
              Text(
                '成本 ¥${sku.costPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 自动生成SKU组合
  void _generateSkus() {
    if (_specAttributes.isEmpty) {
      _generatedSkus = [];
      return;
    }

    final skuCombinations = <List<String>>[];
    void generateCombination(int index, List<String> current) {
      if (index >= _specAttributes.length) {
        skuCombinations.add(List.from(current));
        return;
      }
      
      for (final value in _specAttributes[index].values) {
        current.add(value);
        generateCombination(index + 1, current);
        current.removeLast();
      }
    }
    
    generateCombination(0, []);
    
    final basePrice = double.tryParse(_priceController.text) ?? 0;
    final baseCostPrice = double.tryParse(_costPriceController.text) ?? 0;
    
    _generatedSkus = skuCombinations.map((combination) {
      final skuId = 'sku_${DateTime.now().millisecondsSinceEpoch}_${combination.join('_')}';
      return ProductSku(
        id: skuId,
        productId: _productId ?? 'prod_temp',
        skuCode: skuId,
        price: basePrice,
        costPrice: baseCostPrice,
        specValues: combination.asMap().entries.map((entry) {
          return SpecValue(
            id: '${_specAttributes[entry.key].name}_${entry.value}',
            name: entry.value,
            specId: _specAttributes[entry.key].name,
          );
        }).toList(),
        unitId: 'unit_base',
      );
    }).toList();
  }

  /// Tab 3: 单位设置 - 卡片式布局
  Widget _buildUnitTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 基础单位卡片
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.straighten, color: AppTheme.brandColor8, size: 20),
                    const SizedBox(width: 8),
                    const Text('基础单位', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _baseUnit.isEmpty ? Colors.grey.shade100 : AppTheme.brandColor1,
                    borderRadius: BorderRadius.circular(8),
                    border: _baseUnit.isEmpty ? null : Border.all(color: AppTheme.brandColor6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _baseUnit.isEmpty ? '请在基础信息中设置' : _baseUnit,
                        style: TextStyle(
                          color: _baseUnit.isEmpty ? Colors.grey.shade600 : AppTheme.brandColor8,
                          fontSize: 14,
                          fontWeight: _baseUnit.isEmpty ? FontWeight.normal : FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _baseUnit.isEmpty
                        ? Icon(Icons.warning_amber, color: Colors.orange, size: 18)
                        : Icon(Icons.check_circle, color: AppTheme.brandColor8, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 单位换算编辑器卡片
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.swap_horiz, color: AppTheme.brandColor8, size: 20),
                    const SizedBox(width: 8),
                    const Text('单位换算', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '设置多单位换算关系，如：1箱=24个',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 16),
                UnitConversionEditor(
                  conversions: _unitConversions,
                  baseUnit: _baseUnit,
                  onConversionsChanged: (conversions) {
                    setState(() => _unitConversions = conversions);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  /// 底部操作栏
  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TDButton(
              text: '取消',
              theme: TDButtonTheme.defaultTheme,
              size: TDButtonSize.large,
              onTap: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TDButton(
              text: '保存',
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              onTap: () => _saveProduct(),
            ),
          ),
        ],
      ),
    );
  }

  /// 保存商品
  Future<void> _saveProduct() async {
    // 验证基础信息
    if (_nameController.text.isEmpty) {
      TDToast.showFail('请输入商品名称', context: context);
      setState(() => _currentTab = 0);
      return;
    }

    if (_categoryId == null) {
      TDToast.showFail('请选择商品分类', context: context);
      setState(() => _currentTab = 0);
      return;
    }

    if (_baseUnit.isEmpty) {
      TDToast.showFail('请设置基础单位', context: context);
      setState(() => _currentTab = 0);
      return;
    }

    final basePrice = double.tryParse(_priceController.text) ?? 0;
    if (basePrice <= 0) {
      TDToast.showFail('请输入售价', context: context);
      setState(() => _currentTab = 0);
      return;
    }

    // 验证多规格SKU价格
    if (_hasSpec && _generatedSkus.isNotEmpty) {
      for (final sku in _generatedSkus) {
        if (sku.price <= 0) {
          TDToast.showFail('SKU「${sku.specName}」售价未设置', context: context);
          setState(() => _currentTab = 1);
          return;
        }
      }
    }

    setState(() => _isLoading = true);

    try {
      final baseCostPrice = double.tryParse(_costPriceController.text) ?? 0;
      
      // 构建商品数据（TODO: 后续调用API保存）
      final product = Product(
        id: _productId ?? 'prod_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        categoryId: _categoryId!,
        brand: _brandController.text.isNotEmpty ? _brandController.text : null,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        unitId: 'unit_base',
        price: basePrice,
        costPrice: baseCostPrice,
        barCode: _barCodeController.text.isNotEmpty ? _barCodeController.text : null,
        enabled: true,
        hasSpec: _hasSpec,
        skus: _hasSpec ? _generatedSkus : null,
        units: _unitConversions.isNotEmpty 
          ? [
            Unit(id: 'unit_base', name: _baseUnit, ratio: 1.0, baseUnitId: 'unit_base'),
            ..._unitConversions.map((conv) => Unit(
              id: 'unit_${conv.targetUnit}',
              name: conv.targetUnit,
              ratio: conv.conversionRate,
              baseUnitId: 'unit_base',
            )),
          ]
          : null,
        createTime: DateTime.now(),
      );
      
      // TODO: 实现API保存接口调用
      // await dataService.saveProduct(product);
      // print('Product saved: ${product.id}');
      
      setState(() => _isLoading = false);
      TDToast.showSuccess('保存成功', context: context);
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
      TDToast.showFail('保存失败：$e', context: context);
    }
  }
}