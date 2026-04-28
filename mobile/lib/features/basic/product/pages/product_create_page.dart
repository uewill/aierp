import 'package:aierp_mobile/arco_design/arco_design.dart';
/// 商品创建/编辑页面 - 使用 ArcoCell 样式
/// 白色背景、左右布局、右侧箭头、底部边框分隔

import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({super.key});

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String? _productId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _barCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _categoryId;
  
  // 单位设置
  String _baseUnit = '个';
  bool _enableMultiUnit = false;
  List<Map<String, dynamic>> _units = [];
  
  // 批次及保质期
  bool _enableBatch = false;
  bool _enableExpiry = false;
  int? _shelfLifeDays;
  
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  
  // 规格型号
  bool _hasSpec = false;
  List<Map<String, dynamic>> _specList = [];
  
  bool _isLoading = false;
  int _currentTab = 0;
  
  final List<String> _commonUnits = ['个', '件', '瓶', '盒', '箱', '包', '袋', '桶', '罐', '支'];
  final List<String> _categories = ['电子产品', '服装', '食品', '日用品', '办公用品'];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barCodeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArcoColors.background,
      appBar: AppBar(
        title: Text(_productId == null ? '添加商品' : '编辑商品'),
        backgroundColor: ArcoColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildBasicInfoTab(),
                _buildSpecTab(),
                _buildBatchTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Row(
        children: [
          _buildTabItem(0, '基础信息', Icons.home),
          _buildTabItem(1, '规格型号', Icons.view_module),
          _buildTabItem(2, '批次保质', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title, IconData icon) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ArcoSpacing.s),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? ArcoColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? ArcoColors.primary : ArcoColors.textSecondary, size: 20),
              SizedBox(height: ArcoSpacing.xs),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? ArcoColors.primary : ArcoColors.textSecondary,
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

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ArcoSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品信息卡片
          Text('商品信息', style: ArcoTypography.title2),
          SizedBox(height: ArcoSpacing.s),
          ArcoCellGroup(
            children: [
              ArcoCellInput(
                label: '商品名称',
                hintText: '请输入商品名称',
                controller: _nameController,
                showDivider: true,
              ),
              
              ArcoCell(
                label: '商品分类',
                value: _categoryId != null ? _categories[int.tryParse(_categoryId!) ?? 0] : null,
                placeholder: '请选择分类',
                prefixIcon: Icon(Icons.category_outlined, color: ArcoColors.primary, size: 18),
                onTap: () => _showCategoryPicker(),
              ),
              
              ArcoCellInput(
                label: '品牌',
                hintText: '可选',
                controller: _brandController,
                showDivider: true,
              ),
              
              ArcoCellInput(
                label: '条码',
                hintText: '可选',
                controller: _barCodeController,
                showDivider: true,
              ),
              
              ArcoCell(
                label: '商品描述',
                value: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                placeholder: '可选',
                prefixIcon: Icon(Icons.description_outlined, color: ArcoColors.primary, size: 18),
                onTap: () => _showDescriptionDialog(),
                showArrow: false,
                showDivider: false,
              ),
            ],
          ),
          
          SizedBox(height: ArcoSpacing.m),
          
          // 价格卡片
          Text('价格信息', style: ArcoTypography.title2),
          SizedBox(height: ArcoSpacing.s),
          ArcoCellGroup(
            children: [
              ArcoCellInput(
                label: '售价',
                hintText: '0.00',
                controller: _priceController,
                keyboardType: TextInputType.number,
                prefixIcon: Text('￥', style: TextStyle(color: ArcoColors.primary, fontSize: 16)),
                showDivider: true,
              ),
              
              ArcoCellInput(
                label: '成本价',
                hintText: '0.00',
                controller: _costPriceController,
                keyboardType: TextInputType.number,
                prefixIcon: Text('￥', style: TextStyle(color: ArcoColors.primary, fontSize: 16)),
                showDivider: false,
              ),
            ],
          ),
          
          SizedBox(height: ArcoSpacing.m),
          
          // 单位设置卡片
          Text('单位设置', style: ArcoTypography.title2),
          SizedBox(height: ArcoSpacing.s),
          ArcoCellGroup(
            children: [
              ArcoCell(
                label: '基础单位',
                value: _baseUnit,
                prefixIcon: Icon(Icons.straighten, color: ArcoColors.primary, size: 18),
                onTap: () => _showBaseUnitPicker(),
              ),
              
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ArcoSpacing.m,
                  vertical: ArcoSpacing.m,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('启用多单位', style: ArcoTypography.body2),
                    Switch(
                      value: _enableMultiUnit,
                      onChanged: (v) => setState(() => _enableMultiUnit = v),
                      activeColor: ArcoColors.primary,
                    ),
                  ],
                ),
              ),
              
              if (_enableMultiUnit) ...[
                Divider(height: 1, thickness: 1, color: ArcoColors.border),
                ..._units.asMap().entries.map((entry) {
                  final index = entry.key;
                  final unit = entry.value;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ArcoSpacing.m,
                          vertical: ArcoSpacing.s,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ArcoCellInput(
                                label: '单位',
                                hintText: '如：箱',
                                controller: TextEditingController(text: unit['name']),
                                onChanged: (v) => setState(() => _units[index]['name'] = v),
                                showDivider: false,
                              ),
                            ),
                            SizedBox(width: ArcoSpacing.s),
                            Expanded(
                              flex: 1,
                              child: ArcoCellInput(
                                label: '换算率',
                                hintText: '1',
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: unit['ratio'].toString()),
                                onChanged: (v) => setState(() => _units[index]['ratio'] = double.tryParse(v) ?? 1.0),
                                showDivider: false,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: ArcoColors.danger, size: 20),
                              onPressed: () => setState(() => _units.removeAt(index)),
                            ),
                          ],
                        ),
                      ),
                      if (index < _units.length - 1)
                        Divider(height: 1, thickness: 1, color: ArcoColors.border),
                    ],
                  );
                }),
                
                Container(
                  padding: EdgeInsets.all(ArcoSpacing.m),
                  child: ArcoButton(
                    label: '+ 添加单位',
                    type: ArcoButtonType.secondary,
                    size: ArcoButtonSize.small,
                    onPressed: () => setState(() => _units.add({'name': '', 'ratio': 1.0})),
                  ),
                ),
              ],
            ],
          ),
          
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSpecTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ArcoSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('规格设置', style: ArcoTypography.title2),
          SizedBox(height: ArcoSpacing.s),
          ArcoCellGroup(
            children: [
              Container(
                padding: EdgeInsets.all(ArcoSpacing.m),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('多规格商品', style: ArcoTypography.title2),
                        SizedBox(height: 4),
                        Text(
                          _hasSpec ? '已启用多规格' : '单规格商品',
                          style: ArcoTypography.body3.copyWith(color: ArcoColors.textSecondary),
                        ),
                      ],
                    ),
                    Switch(
                      value: _hasSpec,
                      onChanged: (v) => setState(() => _hasSpec = v),
                      activeColor: ArcoColors.primary,
                    ),
                  ],
                ),
              ),
              
              if (_hasSpec) ...[
                Divider(height: 1, thickness: 1, color: ArcoColors.border),
                ..._specList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final spec = entry.value;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ArcoSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ArcoCellInput(
                                    label: '规格名',
                                    hintText: '如：颜色',
                                    controller: TextEditingController(text: spec['name']),
                                    onChanged: (v) => setState(() => _specList[index]['name'] = v),
                                    showDivider: false,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: ArcoColors.danger, size: 20),
                                  onPressed: () => setState(() => _specList.removeAt(index)),
                                ),
                              ],
                            ),
                            SizedBox(height: ArcoSpacing.s),
                            
                            Text('规格值（用逗号分隔）', style: ArcoTypography.body3),
                            SizedBox(height: ArcoSpacing.xs),
                            ArcoCellInput(
                              label: '',
                              hintText: '如：红色,蓝色,绿色',
                              controller: TextEditingController(text: (spec['values'] as List?)?.join(',') ?? ''),
                              onChanged: (v) {
                                setState(() {
                                  _specList[index]['values'] = v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                                });
                              },
                              showDivider: false,
                            ),
                          ],
                        ),
                      ),
                      if (index < _specList.length - 1)
                        Divider(height: 1, thickness: 1, color: ArcoColors.border),
                    ],
                  );
                }),
                
                Container(
                  padding: EdgeInsets.all(ArcoSpacing.m),
                  child: ArcoButton(
                    label: '+ 添加规格',
                    type: ArcoButtonType.secondary,
                    size: ArcoButtonSize.small,
                    onPressed: () => setState(() => _specList.add({'name': '', 'values': []})),
                  ),
                ),
              ],
            ],
          ),
          
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBatchTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ArcoSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('批次管理', style: ArcoTypography.title2),
          SizedBox(height: ArcoSpacing.s),
          ArcoCellGroup(
            children: [
              Container(
                padding: EdgeInsets.all(ArcoSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('启用批次', style: ArcoTypography.body2),
                        Switch(
                          value: _enableBatch,
                          onChanged: (v) => setState(() => _enableBatch = v),
                          activeColor: ArcoColors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: ArcoSpacing.xs),
                    Text(
                      '启用后可对商品进行批次追踪',
                      style: ArcoTypography.body3.copyWith(color: ArcoColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: ArcoSpacing.m),
          
          Text('保质期设置', style: ArcoTypography.title2),
          SizedBox(height: ArcoSpacing.s),
          ArcoCellGroup(
            children: [
              Container(
                padding: EdgeInsets.all(ArcoSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('启用保质期', style: ArcoTypography.body2),
                        Switch(
                          value: _enableExpiry,
                          onChanged: (v) => setState(() => _enableExpiry = v),
                          activeColor: ArcoColors.primary,
                        ),
                      ],
                    ),
                    
                    if (_enableExpiry) ...[
                      SizedBox(height: ArcoSpacing.m),
                      ArcoCellInput(
                        label: '保质期天数',
                        hintText: '如：365',
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() => _shelfLifeDays = int.tryParse(v)),
                        showDivider: false,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(ArcoSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: ArcoButton(
              label: '取消',
              onPressed: () => Navigator.pop(context),
              type: ArcoButtonType.secondary,
              size: ArcoButtonSize.large,
            ),
          ),
          SizedBox(width: ArcoSpacing.m),
          Expanded(
            child: ArcoButton(
              label: '保存',
              onPressed: _isLoading ? null : _saveProduct,
              type: ArcoButtonType.primary,
              size: ArcoButtonSize.large,
              loading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(ArcoSpacing.m),
              child: Row(
                children: [
                  Text('商品分类', style: ArcoTypography.title2),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Icon(Icons.close, color: ArcoColors.textSecondary),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: ArcoColors.border),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _categoryId == index.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() => _categoryId = index.toString());
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: EdgeInsets.all(ArcoSpacing.m),
                      child: Row(
                        children: [
                          Text(
                            _categories[index],
                            style: ArcoTypography.body2.copyWith(
                              color: isSelected ? ArcoColors.primary : ArcoColors.textPrimary,
                            ),
                          ),
                          Spacer(),
                          if (isSelected)
                            Icon(Icons.check, color: ArcoColors.primary, size: 20),
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

  void _showBaseUnitPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(ArcoSpacing.m),
              child: Row(
                children: [
                  Text('基础单位', style: ArcoTypography.title2),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Icon(Icons.close, color: ArcoColors.textSecondary),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: ArcoColors.border),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _commonUnits.length,
                itemBuilder: (context, index) {
                  final isSelected = _baseUnit == _commonUnits[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _baseUnit = _commonUnits[index]);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: EdgeInsets.all(ArcoSpacing.m),
                      child: Row(
                        children: [
                          Text(
                            _commonUnits[index],
                            style: ArcoTypography.body2.copyWith(
                              color: isSelected ? ArcoColors.primary : ArcoColors.textPrimary,
                            ),
                          ),
                          Spacer(),
                          if (isSelected)
                            Icon(Icons.check, color: ArcoColors.primary, size: 20),
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

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('商品描述'),
        content: TextField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: '请输入商品描述',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消'),
          ),
          ArcoButton(
            label: '确定',
            type: ArcoButtonType.primary,
            onPressed: () {
              setState(() {});
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入商品名称'), backgroundColor: ArcoColors.danger),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(Duration(seconds: 1)); // 模拟API调用
      
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存成功'), backgroundColor: ArcoColors.success),
      );
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败：$e'), backgroundColor: ArcoColors.danger),
      );
    }
  }
}
