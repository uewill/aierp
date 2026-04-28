import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 销售开单页面
class SalesCreatePage extends StatefulWidget {
  const SalesCreatePage({super.key});

  @override
  State<SalesCreatePage> createState() => _SalesCreatePageState();
}

class _SalesCreatePageState extends State<SalesCreatePage> {
  final _formKey = GlobalKey<FormState>();
  
  // 表单数据
  final _billDateController = TextEditingController();
  final _remarkController = TextEditingController();
  
  String? _selectedCustomer;
  String? _selectedWarehouse;
  final List<OrderItem> _items = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _billDateController.text = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _billDateController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('销售开单', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.brandColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submitOrder,
            child: const Text('提交', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 基本信息
              _buildSection('基本信息', [
                _buildInputField(
                  label: '日期',
                  controller: _billDateController,
                  readOnly: true,
                  suffixIcon: Icons.calendar_today,
                  onTap: () => _selectDate(),
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  label: '客户',
                  hintText: '请选择客户',
                  controller: TextEditingController(text: _selectedCustomer ?? ''),
                  readOnly: true,
                  suffixIcon: Icons.arrow_forward_ios,
                  onTap: () => _selectCustomer(),
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  label: '仓库',
                  hintText: '请选择仓库',
                  controller: TextEditingController(text: _selectedWarehouse ?? ''),
                  readOnly: true,
                  suffixIcon: Icons.arrow_forward_ios,
                  onTap: () => _selectWarehouse(),
                ),
              ]),
              
              const SizedBox(height: 24),
              
              // 商品明细
              _buildDetailSection(),
              
              const SizedBox(height: 24),
              
              // 备注
              _buildSection('备注', [
                TextFormField(
                  controller: _remarkController,
                  decoration: const InputDecoration(
                    hintText: '请输入备注信息',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixIcon: suffixIcon != null 
          ? IconButton(
              icon: Icon(suffixIcon),
              onPressed: onTap,
            )
          : null,
        border: const OutlineInputBorder(),
      ),
      readOnly: readOnly,
      onTap: onTap,
    );
  }

  Widget _buildDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (_items.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('暂无商品，点击上方按钮添加'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _buildOrderItem(_items[index], index);
            },
          ),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text('¥${item.price.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('数量: ${item.quantity}'),
                const Spacer(),
                Text('小计: ¥${(item.price * item.quantity).toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _removeItem(index),
                  child: const Text('删除', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (selectedDate != null) {
      _billDateController.text = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _selectCustomer() async {
    // 模拟选择客户
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择客户'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ListTile(title: Text('客户A')),
              ListTile(title: Text('客户B')),
              ListTile(title: Text('客户C')),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, '客户A'),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    
    if (result != null) {
      setState(() {
        _selectedCustomer = result;
      });
    }
  }

  Future<void> _selectWarehouse() async {
    // 模拟选择仓库
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择仓库'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ListTile(title: Text('仓库1')),
              ListTile(title: Text('仓库2')),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, '仓库1'),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    
    if (result != null) {
      setState(() {
        _selectedWarehouse = result;
      });
    }
  }

  void _addProduct() {
    // 模拟添加商品
    setState(() {
      _items.add(OrderItem(
        productId: _items.length + 1,
        productName: '商品${_items.length + 1}',
        quantity: 1,
        price: 10.0 + _items.length,
        unit: '件',
      ));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _submitOrder() {
    if (_formKey.currentState?.validate() == true) {
      // 提交订单逻辑
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('订单提交成功！')),
      );
      Navigator.pop(context);
    }
  }
}

/// 订单商品项
class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final String unit;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.unit,
  });
}