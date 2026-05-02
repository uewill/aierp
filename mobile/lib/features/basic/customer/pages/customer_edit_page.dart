import 'package:aierp_mobile/core/theme/app_theme.dart';
import 'package:aierp_mobile/shared/widgets/card_input_field.dart';
/// 客户编辑页面 - 卡片式风格

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
          _nameController.text = data?['name']?.toString() ?? '';
          _contactController.text = data?['contact']?.toString() ?? '';
          _phoneController.text = data?['phone']?.toString() ?? '';
          _addressController.text = data?['address']?.toString() ?? '';
          _creditLimitController.text = (data?['creditLimit'] ?? 0).toString();
          _bankNameController.text = data?['bankName']?.toString() ?? '';
          _bankAccountController.text = data?['bankAccount']?.toString() ?? '';
          _taxNumberController.text = data?['taxNumber']?.toString() ?? '';
          _enabled = data?['enabled'] as bool? ?? true;
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
      backgroundColor: const Color(0xFFF7F8FA),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分组标题
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '基本信息',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4E5969),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // 客户名称 - 必填
              CardInputField(
                title: '客户名称',
                controller: _nameController,
                required: true,
                onChanged: (v) {},
              ),
              
              // 联系人
              CardInputField(
                title: '联系人',
                controller: _contactController,
              ),
              
              // 电话
              CardInputField(
                title: '电话',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              
              // 地址
              CardInputField(
                title: '地址',
                controller: _addressController,
                maxLines: 2,
              ),
              
              // 启用状态
              CardSwitchField(
                title: '启用状态',
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
              ),
              
              const SizedBox(height: 24),
              
              // 分组标题
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '财务信息',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4E5969),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // 信用额度 - 带单位
              CardNumberField(
                title: '信用额度',
                value: _creditLimitController.text,
                unit: '元',
                onChanged: (v) => _creditLimitController.text = v,
              ),
              
              // 开户银行
              CardInputField(
                title: '开户银行',
                controller: _bankNameController,
              ),
              
              // 银行账号
              CardInputField(
                title: '银行账号',
                controller: _bankAccountController,
                keyboardType: TextInputType.number,
              ),
              
              // 税号
              CardInputField(
                title: '税号',
                controller: _taxNumberController,
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      bottomNavigationBar: _buildBottomActions(context),
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
      child: SafeArea(
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