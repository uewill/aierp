import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 仓库编辑页面 - 新建/编辑仓库信息

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/api/warehouse_api.dart';

class WarehouseEditPage extends StatefulWidget {
  const WarehouseEditPage({super.key});

  @override
  State<WarehouseEditPage> createState() => _WarehouseEditPageState();
}

class _WarehouseEditPageState extends State<WarehouseEditPage> {
  final WarehouseApi _warehouseApi = WarehouseApi();
  
  // 表单数据
  int? _warehouseId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _managerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _enabled = true;
  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _addressController.dispose();
    _managerController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _warehouseId = args['id'] as int?;
      if (_warehouseId != null) {
        setState(() => _isLoading = true);
        try {
          final data = await _warehouseApi.getWarehouse(_warehouseId!);
          final nameVal = data?['name'];
          final codeVal = data?['code'];
          final addressVal = data?['address'];
          final managerVal = data?['manager'];
          final phoneVal = data?['phone'];
          final enabledVal = data?['enabled'];
          final isDefaultVal = data?['isDefault'];
          _nameController.text = nameVal?.toString() ?? '';
          _codeController.text = codeVal?.toString() ?? '';
          _addressController.text = addressVal?.toString() ?? '';
          _managerController.text = managerVal?.toString() ?? '';
          _phoneController.text = phoneVal?.toString() ?? '';
          _enabled = enabledVal as bool? ?? true;
          _isDefault = isDefaultVal as bool? ?? false;
        } catch (e) {
          TDToast.showFail('加载仓库数据失败', context: context);
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TDNavBar(
        title: _warehouseId == null ? '新建仓库' : '编辑仓库',
        backgroundColor: AppTheme.brandColor,
        leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))],
      ),
      body: _isLoading 
        ? const Center(child: TDLoading(size: TDLoadingSize.large))
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildBasicInfoCard(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  /// 基础信息卡片
  Widget _buildBasicInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(TDIcons.home, color: AppTheme.brandColor8, size: 20),
              const SizedBox(width: 8),
              const Text('仓库信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          
          // 仓库名称
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '仓库名称 *',
              hintText: '请输入仓库名称',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 仓库编码
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: '仓库编码',
              hintText: '可选，如 CK001',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 地址
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: '地址',
              hintText: '可选',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            maxLines: 2,
          ),
          
          const SizedBox(height: 12),
          
          // 管理员
          TextField(
            controller: _managerController,
            decoration: InputDecoration(
              labelText: '管理员',
              hintText: '可选',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
              prefixIcon: const Icon(TDIcons.user),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 电话
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: '电话',
              hintText: '可选',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
              prefixIcon: const Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          
          const SizedBox(height: 16),
          
          // 启用状态
          Row(
            children: [
              const Text('启用状态', style: TextStyle(fontSize: 14)),
              const Spacer(),
              Switch(
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
                activeColor: AppTheme.brandColor8,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 默认仓库
          Row(
            children: [
              const Text('默认仓库', style: TextStyle(fontSize: 14)),
              const Spacer(),
              Switch(
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
                activeColor: AppTheme.brandColor8,
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '默认仓库将在新建单据时自动选中',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
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
              onTap: () => _saveWarehouse(),
            ),
          ),
        ],
      ),
    );
  }

  /// 保存仓库
  Future<void> _saveWarehouse() async {
    // 验证必填项
    if (_nameController.text.isEmpty) {
      TDToast.showFail('请输入仓库名称', context: context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text,
        'code': _codeController.text.isNotEmpty ? _codeController.text : null,
        'address': _addressController.text.isNotEmpty ? _addressController.text : null,
        'manager': _managerController.text.isNotEmpty ? _managerController.text : null,
        'phone': _phoneController.text.isNotEmpty ? _phoneController.text : null,
        'enabled': _enabled,
        'isDefault': _isDefault,
      };

      if (_warehouseId != null) {
        await _warehouseApi.updateWarehouse(_warehouseId!, data);
        TDToast.showSuccess('更新成功', context: context);
      } else {
        await _warehouseApi.createWarehouse(data);
        TDToast.showSuccess('创建成功', context: context);
      }

      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
      TDToast.showFail('保存失败：$e', context: context);
    }
  }
}