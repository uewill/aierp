import 'package:aierp_mobile/arco_design/arco_design.dart';
/// 商品创建/编辑页面 - 重构版
/// 使用 Arco Design Mobile 规范

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
          _buildCard(
            title: '商品信息',
            icon: Icons.inventory_2,
            children: [
              ArcoInputItem(
                label: '商品名称',
                hintText: '请输入商品名称',
                controller: _nameController,
                showClear: true,
              ),
              SizedBox(height: ArcoSpacing.s),
              
              ArcoPicker<String>(
                title: '商品分类',
                items: _categories,
                value: _categoryId != null ? _categories[int.tryParse(_categoryId!) ?? 0] : null,
                itemLabel: (c) => c,
                placeholder: '请选择分类',
                prefixIcon: Icon(Icons.category_outlined, color: ArcoColors.textSecondary, size: 18),
                onSelected: (category) {
                  if (category != null) {
                    setState(() => _categoryId = _categories.indexOf(category).toString());
                  }
                },
              ),
              SizedBox(height: ArcoSpacing.s),
              
              ArcoInputItem(
                label: '品牌',
                hintText: '可选',
                controller: _brandController,
                showClear: true,
              ),
              SizedBox(height: ArcoSpacing.s),
              
              ArcoInputItem(
                label: '条码',
                hintText: '可选',
                controller: _barCodeController,
                showClear: true,
              ),
              SizedBox(height: ArcoSpacing.s),
              
              ArcoTextArea(
                label: '商品描述',
                hintText: '可选',
                controller: _descriptionController,
                maxLines: 2,
              ),
            ],
          ),
          
          SizedBox(height: ArcoSpacing.m),
          
          // 价格卡片
          _buildCard(
            title: '价格信息',
            icon: Icons.payments_outlined,
            children: [
              ArcoInputItem(
                label: '售价',
                hintText: '0.00',
                controller: _priceController,
                keyboardType: TextInputType.number,
                prefixIcon: Text('¥', style: TextStyle(color: ArcoColors.textSecondary)),
              ),
              SizedBox(height: ArcoSpacing.s),
              
              ArcoInputItem(
                label: '成本价',
                hintText: '0.00',
                controller: _costPriceController,
                keyboardType: TextInputType.number,
                prefixIcon: Text('¥', style: TextStyle(color: ArcoColors.textSecondary)),
              ),
            ],
          ),
          
          SizedBox(height: ArcoSpacing.m),
          
          // 单位设置卡片
          _buildCard(
            title: '单位设置',
            icon: Icons.straighten,
            children: [
              ArcoPicker<String>(
                title: '基础单位',
                items: _commonUnits,
                value: _baseUnit,
                itemLabel: (u) => u,
                onSelected: (unit) {
                  if (unit != null) setState(() => _baseUnit = unit);
                },
              ),
              SizedBox(height: ArcoSpacing.m),
              
              Row(
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
              
              if (_enableMultiUnit) ...[
                SizedBox(height: ArcoSpacing.m),
                Divider(),
                SizedBox(height: ArcoSpacing.s),
                
                ..._units.asMap().entries.map((entry) {
                  final index = entry.key;
                  final unit = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: ArcoSpacing.s),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ArcoInputItem(
                            label: '单位',
                            hintText: '如：箱',
                            controller: TextEditingController(text: unit['name']),
                            onChanged: (v) => setState(() => _units[index]['name'] = v),
                          ),
                        ),
                        SizedBox(width: ArcoSpacing.s),
                        Expanded(
                          flex: 1,
                          child: ArcoInputItem(
                            label: '换算率',
                            hintText: '1',
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: unit['ratio'].toString()),
                            onChanged: (v) => setState(() => _units[index]['ratio'] = double.tryParse(v) ?? 1.0),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: ArcoColors.danger, size: 20),
                          onPressed: () => setState(() => _units.removeAt(index)),
                        ),
                      ],
                    ),
                  );
                }),
                
                SizedBox(height: ArcoSpacing.s),
                ArcoButton(
                  label: '+ 添加单位',
                  type: ArcoButtonType.secondary,
                  size: ArcoButtonSize.small,
                  onPressed: () => setState(() => _units.add({'name': '', 'ratio': 1.0})),
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
          _buildCard(
            title: '规格设置',
            icon: Icons.view_module,
            children: [
              Row(
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
              
              if (_hasSpec) ...[
                SizedBox(height: ArcoSpacing.m),
                Divider(),
                SizedBox(height: ArcoSpacing.s),
                
                ..._specList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final spec = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: ArcoSpacing.m),
                    child: Container(
                      padding: EdgeInsets.all(ArcoSpacing.s),
                      decoration: BoxDecoration(
                        color: ArcoColors.fill1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ArcoInputItem(
                                  label: '规格名',
                                  hintText: '如：颜色',
                                  controller: TextEditingController(text: spec['name']),
                                  onChanged: (v) => setState(() => _specList[index]['name'] = v),
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
                          ArcoInputItem(
                            label: '',
                            hintText: '如：红色,蓝色,绿色',
                            controller: TextEditingController(text: (spec['values'] as List?)?.join(',') ?? ''),
                            onChanged: (v) {
                              setState(() {
                                _specList[index]['values'] = v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                
                SizedBox(height: ArcoSpacing.s),
                ArcoButton(
                  label: '+ 添加规格',
                  type: ArcoButtonType.secondary,
                  size: ArcoButtonSize.small,
                  onPressed: () => setState(() => _specList.add({'name': '', 'values': []})),
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
          _buildCard(
            title: '批次管理',
            icon: Icons.calendar_today,
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
          
          SizedBox(height: ArcoSpacing.m),
          
          _buildCard(
            title: '保质期设置',
            icon: Icons.access_time,
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
                ArcoInputItem(
                  label: '保质期天数',
                  hintText: '如：365',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() => _shelfLifeDays = int.tryParse(v)),
                ),
              ],
            ],
          ),
          
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)],
      ),
      padding: EdgeInsets.all(ArcoSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ArcoColors.primary, size: 20),
              SizedBox(width: ArcoSpacing.s),
              Text(title, style: ArcoTypography.title2),
            ],
          ),
          SizedBox(height: ArcoSpacing.m),
          ...children,
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
