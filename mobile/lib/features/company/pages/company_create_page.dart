import 'package:flutter/material.dart';
import 'package:aierp_mobile/models/company.dart';

/// 公司创建页面 - 使用标准 Flutter 组件
class CompanyCreatePage extends StatefulWidget {
  const CompanyCreatePage({super.key});

  @override
  State<CompanyCreatePage> createState() => _CompanyCreatePageState();
}

class _CompanyCreatePageState extends State<CompanyCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  void _createCompany() {
    if (_formKey.currentState!.validate()) {
      // 创建公司对象
      final company = Company(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        createdAt: DateTime.now(),
      );
      
      // 这里应该调用 API 保存公司
      // 模拟成功后返回
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建公司'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('公司信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              // 公司名称
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '公司名称 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入公司名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 公司编码
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: '公司编码 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入公司编码';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 联系人
              TextFormField(
                controller: _contactPersonController,
                decoration: const InputDecoration(
                  labelText: '联系人 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入联系人';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 联系电话
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '联系电话 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入联系电话';
                  }
                  // 简单的手机号验证
                  if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value.trim())) {
                    return '请输入有效的手机号码';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 公司地址
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: '公司地址 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入公司地址';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // 创建按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createCompany,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052D9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('创建公司', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}