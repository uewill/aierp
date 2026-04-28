import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 客户编辑页面 - 新建/编辑客户信息

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/api/partner_api.dart';

class CustomerEditPage extends StatefulWidget {
  const CustomerEditPage({super.key});

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  final PartnerApi _partnerApi = PartnerApi();
  
  // 表单数据
  int? _customerId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController(text: '0');
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  
  bool _enabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _creditLimitController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _taxNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _customerId = args['id'] as int?;
      if (_customerId != null) {
        setState(() => _isLoading = true);
        try {
          final data = await _partnerApi.getPartner(_customerId!);
          final nameVal = data?['name'];
          final contactVal = data?['contact'];
          final phoneVal = data?['phone'];
          final addressVal = data?['address'];
          final creditLimitVal = data?['creditLimit'];
          final bankNameVal = data?['bankName'];
          final bankAccountVal = data?['bankAccount'];
          final taxNumberVal = data?['taxNumber'];
          final enabledVal = data?['enabled'];
          _nameController.text = nameVal?.toString() ?? '';
          _contactController.text = contactVal?.toString() ?? '';
          _phoneController.text = phoneVal?.toString() ?? '';
          _addressController.text = addressVal?.toString() ?? '';
          _creditLimitController.text = (creditLimitVal ?? 0).toString();
          _bankNameController.text = bankNameVal?.toString() ?? '';
          _bankAccountController.text = bankAccountVal?.toString() ?? '';
          _taxNumberController.text = taxNumberVal?.toString() ?? '';
          _enabled = enabledVal as bool? ?? true;
        } catch (e) {
          TDToast.showFail('加载客户数据失败', context: context);
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
        title: _customerId == null ? '新建客户' : '编辑客户',
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
              const SizedBox(height: 16),
              _buildFinanceInfoCard(context),
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
              Icon(TDIcons.user, color: AppTheme.brandColor8, size: 20),
              const SizedBox(width: 8),
              const Text('基本信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          
          // 客户名称
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '客户名称 *',
              hintText: '请输入客户名称',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 联系人
          TextField(
            controller: _contactController,
            decoration: InputDecoration(
              labelText: '联系人',
              hintText: '可选',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
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
        ],
      ),
    );
  }

  /// 财务信息卡片
  Widget _buildFinanceInfoCard(BuildContext context) {
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
              Icon(TDIcons.money, color: AppTheme.brandColor8, size: 20),
              const SizedBox(width: 8),
              const Text('财务信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          
          // 信用额度
          TextField(
            controller: _creditLimitController,
            decoration: InputDecoration(
              labelText: '信用额度',
              hintText: '0',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
              prefixText: '¥ ',
            ),
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 12),
          
          // 开户银行
          TextField(
            controller: _bankNameController,
            decoration: InputDecoration(
              labelText: '开户银行',
              hintText: '可选',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 银行账号
          TextField(
            controller: _bankAccountController,
            decoration: InputDecoration(
              labelText: '银行账号',
              hintText: '可选',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 12),
          
          // 税号
          TextField(
            controller: _taxNumberController,
            decoration: InputDecoration(
              labelText: '税号',
              hintText: '可选',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '财务信息可用于生成发票和对账单',
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
              onTap: () => _saveCustomer(),
            ),
          ),
        ],
      ),
    );
  }

  /// 保存客户
  Future<void> _saveCustomer() async {
    // 验证必填项
    if (_nameController.text.isEmpty) {
      TDToast.showFail('请输入客户名称', context: context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        'name': _nameController.text,
        'type': 'customer',
        'contact': _contactController.text.isNotEmpty ? _contactController.text : null,
        'phone': _phoneController.text.isNotEmpty ? _phoneController.text : null,
        'address': _addressController.text.isNotEmpty ? _addressController.text : null,
        'creditLimit': double.tryParse(_creditLimitController.text) ?? 0,
        'bankName': _bankNameController.text.isNotEmpty ? _bankNameController.text : null,
        'bankAccount': _bankAccountController.text.isNotEmpty ? _bankAccountController.text : null,
        'taxNumber': _taxNumberController.text.isNotEmpty ? _taxNumberController.text : null,
        'enabled': _enabled,
      };

      if (_customerId != null) {
        await _partnerApi.updatePartner(_customerId!, data);
        TDToast.showSuccess('更新成功', context: context);
      } else {
        await _partnerApi.createPartner(data);
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