import 'package:flutter/material.dart';
import 'package:aierp_mobile/models/company.dart';

/// 公司选择页面
class CompanySelectPage extends StatefulWidget {
  const CompanySelectPage({super.key});

  @override
  State<CompanySelectPage> createState() => _CompanySelectPageState();
}

class _CompanySelectPageState extends State<CompanySelectPage> {
  final List<Company> _companies = [
    Company(
      id: '1', 
      name: '北京分公司', 
      code: 'BJ001', 
      address: '北京市朝阳区xxx',
      phone: '010-12345678',
      contactPerson: '张经理',
      createdAt: DateTime.now(),
    ),
    Company(
      id: '2', 
      name: '上海分公司', 
      code: 'SH001', 
      address: '上海市浦东新区xxx',
      phone: '021-12345678',
      contactPerson: '李经理',
      createdAt: DateTime.now(),
    ),
    Company(
      id: '3', 
      name: '广州分公司', 
      code: 'GZ001', 
      address: '广州市天河区xxx',
      phone: '020-12345678',
      contactPerson: '王经理',
      createdAt: DateTime.now(),
    ),
  ];
  
  String? _selectedCompanyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择公司'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: _companies.length,
        itemBuilder: (context, index) {
          final company = _companies[index];
          return RadioListTile<String>(
            title: Text(company.name),
            subtitle: Text('${company.code} | ${company.address}'),
            value: company.id,
            groupValue: _selectedCompanyId,
            onChanged: (value) {
              setState(() {
                _selectedCompanyId = value;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedCompanyId != null ? _selectCompany : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('确认选择', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  void _selectCompany() {
    // 这里应该保存选中的公司到状态管理中
    Navigator.pushReplacementNamed(context, '/main');
  }
}