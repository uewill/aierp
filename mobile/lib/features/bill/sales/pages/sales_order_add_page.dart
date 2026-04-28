import 'package:flutter/material.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 销售开单页面
class SalesOrderAddPage extends StatefulWidget {
  const SalesOrderAddPage({super.key});

  @override
  State<SalesOrderAddPage> createState() => _SalesOrderAddPageState();
}

class _SalesOrderAddPageState extends State<SalesOrderAddPage> {
  final _customerController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _remarkController = TextEditingController();
  
  @override
  void dispose() {
    _customerController.dispose();
    _warehouseController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('销售开单'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('提交', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本信息
            const Text('基本信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _customerController,
              decoration: const InputDecoration(
                labelText: '客户',
                suffixIcon: Icon(Icons.chevron_right),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: _selectCustomer,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _warehouseController,
              decoration: const InputDecoration(
                labelText: '仓库',
                suffixIcon: Icon(Icons.chevron_right),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: _selectWarehouse,
            ),
            
            const SizedBox(height: 24),
            
            // 商品明细
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('商品明细', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('添加商品'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('暂无商品，点击上方按钮添加'),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 备注
            const Text('备注', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _remarkController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '请输入备注',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectCustomer() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 250,
        child: Column(
          children: [
            const ListTile(title: Text('选择客户')),
            const Divider(),
            Expanded(
              child: ListView(
                children: ['客户A', '客户B', '客户C'].map((name) {
                  return ListTile(
                    title: Text(name),
                    onTap: () {
                      setState(() => _customerController.text = name);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectWarehouse() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Column(
          children: [
            const ListTile(title: Text('选择仓库')),
            const Divider(),
            Expanded(
              child: ListView(
                children: ['主仓库', '分仓库'].map((name) {
                  return ListTile(
                    title: Text(name),
                    onTap: () {
                      setState(() => _warehouseController.text = name);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('商品选择功能开发中')),
    );
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('提交成功')),
    );
    Navigator.pop(context);
  }
}