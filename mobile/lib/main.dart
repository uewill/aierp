import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AIERPApp());
}

class AIERPApp extends StatelessWidget {
  const AIERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI进销存',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// API 服务
class ApiService {
  static const baseUrl = 'http://42.193.169.78:8090/api';
  
  static Future<Map<String, dynamic>> sendCode(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> login(String phone, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'code': code}),
    );
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> aiTextInput(String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/text-input'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content}),
    );
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> getProductUnits(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/extend/units/$productId'));
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> getProductBarcodes(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/extend/barcodes/$productId'));
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> getAvailableBatches(int productId, int warehouseId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/extend/batches/$productId/$warehouseId'));
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> getCustomerPrice(int customerId, int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/extend/customer-price/$customerId/$productId'));
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> getProductList() async {
    final response = await http.get(Uri.parse('$baseUrl/business/product/list'));
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> getSalesOrderPage(int pageNum, int pageSize) async {
    final response = await http.get(Uri.parse('$baseUrl/business/sales-order/page?pageNum=$pageNum&pageSize=$pageSize'));
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> confirmDraft(int draftId) async {
    final response = await http.post(Uri.parse('$baseUrl/ai/draft/$draftId/confirm'));
    return jsonDecode(response.body);
  }
}

/// 登录页
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController(text: '18190780080');
  final _codeController = TextEditingController(text: '1234');
  bool _loading = false;
  bool _sendingCode = false;
  int _countdown = 0;

  Future<void> _sendCode() async {
    if (_phoneController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入正确的手机号')));
      return;
    }
    
    setState(() => _sendingCode = true);
    try {
      final result = await ApiService.sendCode(_phoneController.text);
      if (result['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('验证码已发送')));
        setState(() => _countdown = 60);
        _startCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? '发送失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('网络错误: $e')));
    }
    setState(() => _sendingCode = false);
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _countdown--);
      return _countdown > 0;
    });
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final result = await ApiService.login(_phoneController.text, _codeController.text);
      if (result['code'] == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? '登录失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('网络错误: $e')));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text('AI进销存', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Text('智能录入 · 快速开单', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 48),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: '手机号',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: '验证码',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _countdown > 0 || _sendingCode ? null : _sendCode,
                    child: _sendingCode 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_countdown > 0 ? '${_countdown}s' : '获取'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('开发模式验证码: 1234', style: TextStyle(color: Colors.orange, fontSize: 12)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('登录', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  
  final _pages = [
    const AIInputPage(),
    const SalesOrderListPage(),
    const ProductListPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.edit_note), label: 'AI录入'),
          NavigationDestination(icon: Icon(Icons.sell), label: '销售单'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: '商品'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: '更多'),
        ],
      ),
    );
  }
}

/// AI 录入页
class AIInputPage extends StatefulWidget {
  const AIInputPage({super.key});

  @override
  State<AIInputPage> createState() => _AIInputPageState();
}

class _AIInputPageState extends State<AIInputPage> {
  final _inputController = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;

  Future<void> _parseInput() async {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入订单内容')));
      return;
    }
    
    setState(() => _loading = true);
    try {
      final response = await ApiService.aiTextInput(_inputController.text);
      if (response['code'] == 200) {
        setState(() => _result = response['data']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? '解析失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('网络错误: $e')));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI智能录入'),
        actions: [
          IconButton(icon: const Icon(Icons.mic), onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('语音识别待对接')));
          }),
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('图片识别待对接')));
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('输入订单内容', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        hintText: '例如：销售可乐10箱@50元，批次:B20260401',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loading ? null : _parseInput,
                      icon: _loading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_fix_high),
                      label: const Text('智能解析'),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_result != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            '识别成功 · 置信度 ${_result!['parsedOrder']['confidence']}%',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('订单类型: ${_result!['parsedOrder']['orderType'] == 'SALES' ? '销售单' : '采购单'}'),
                      const Divider(),
                      const Text('商品明细:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...(_result!['parsedOrder']['items'] as List).map((item) => 
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.inventory_2),
                          title: Text(item['productName'] ?? ''),
                          subtitle: Text('${item['quantity']} ${item['unit']}'),
                          trailing: item['price'] != null ? Text('¥${item['price']}') : null,
                        ),
                      ),
                      if (_result!['parsedOrder']['items'][0]['batchNo'] != null)
                        Text('批次号: ${_result!['parsedOrder']['items'][0]['batchNo']}', style: const TextStyle(color: Colors.purple)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => _result = null),
                              child: const Text('取消'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final res = await ApiService.confirmDraft(_result!['draftId']);
                                if (res['code'] == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('订单已生成！')));
                                  setState(() {
                                    _result = null;
                                    _inputController.clear();
                                  });
                                }
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('确认生成'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('录入示例', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('• 销售：可乐10箱@50元'),
                    Text('• 含批次：可乐10箱@50元，批次:B20260401'),
                    Text('• 含过期日期：矿泉水5瓶@3元，过期日期:2026-12-31'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 销售单列表页
class SalesOrderListPage extends StatefulWidget {
  const SalesOrderListPage({super.key});

  @override
  State<SalesOrderListPage> createState() => _SalesOrderListPageState();
}

class _SalesOrderListPageState extends State<SalesOrderListPage> {
  List<dynamic> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final response = await ApiService.getSalesOrderPage(1, 20);
      if (response['code'] == 200 && response['data']['list'] != null) {
        setState(() {
          _orders = response['data']['list'];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('销售单')),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : _orders.isEmpty
          ? const Center(child: Text('暂无销售单'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return ListTile(
                  leading: Icon(Icons.receipt, color: order['status'] == 'APPROVED' ? Colors.green : Colors.orange),
                  title: Text(order['orderNo'] ?? ''),
                  subtitle: Text('${order['customerName'] ?? '未知客户'} | ¥${order['totalAmount'] ?? 0}'),
                  trailing: Chip(label: Text(order['status'] ?? '')),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderDetailPage(order: order)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIInputPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 订单详情页
class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final details = order['details'] as List? ?? [];
    
    return Scaffold(
      appBar: AppBar(title: Text(order['orderNo'] ?? '订单详情')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('基本信息', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('客户: ${order['customerName'] ?? ''}'),
                    Text('状态: ${order['status'] ?? ''}'),
                    Text('日期: ${order['orderDate'] ?? ''}'),
                    if (order['aiSource'] != null)
                      Text('AI来源: ${order['aiSource']}', style: const TextStyle(color: Colors.purple)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('商品明细', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...details.map((d) => ListTile(
                      dense: true,
                      title: Text(d['productName'] ?? ''),
                      subtitle: Text('${d['quantity']} ${d['unit']} × ¥${d['price'] ?? 0}'),
                      trailing: Text('¥${d['amount'] ?? 0}'),
                      isThreeLine: d['batchNo'] != null,
                      onTap: () {
                        if (d['batchNo'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('批次号: ${d['batchNo']}')),
                          );
                        }
                      },
                    )),
                    const Divider(),
                    Text('合计: ¥${order['totalAmount'] ?? 0}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 商品列表页
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final response = await ApiService.getProductList();
      if (response['code'] == 200) {
        setState(() {
          _products = response['data'] ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品管理')),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : _products.isEmpty
          ? const Center(child: Text('暂无商品'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final p = _products[index];
                return ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: Text(p['name'] ?? ''),
                  subtitle: Text('编码: ${p['code'] ?? ''} | ${p['unit'] ?? ''}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('¥${p['salePrice'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (p['enableBatch'] == 1)
                        const Icon(Icons.calendar_today, size: 16, color: Colors.purple),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                  ),
                );
              },
            ),
    );
  }
}

/// 商品详情页（含批次、单位、条码）
class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<dynamic> _units = [];
  List<dynamic> _barcodes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExtensions();
  }

  Future<void> _loadExtensions() async {
    final productId = widget.product['id'];
    try {
      final unitsRes = await ApiService.getProductUnits(productId);
      final barcodesRes = await ApiService.getProductBarcodes(productId);
      setState(() {
        _units = unitsRes['data'] ?? [];
        _barcodes = barcodesRes['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    
    return Scaffold(
      appBar: AppBar(title: Text(p['name'] ?? '商品详情')),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 基本信息
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('基本信息', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text('编码: ${p['code'] ?? ''}'),
                        Text('条码: ${p['barcode'] ?? ''}'),
                        Text('单位: ${p['unit'] ?? ''}'),
                        Text('销售价: ¥${p['salePrice'] ?? 0}'),
                        Text('进货价: ¥${p['purchasePrice'] ?? 0}'),
                        Text('库存: ${p['stock'] ?? 0}'),
                      ],
                    ),
                  ),
                ),
                
                // 启用功能
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('启用功能', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(p['enableMultiUnit'] == 1 ? Icons.check_circle : Icons.cancel, 
                                 color: p['enableMultiUnit'] == 1 ? Colors.green : Colors.grey),
                            const SizedBox(width: 8),
                            const Text('多单位'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(p['enableBatch'] == 1 ? Icons.check_circle : Icons.cancel,
                                 color: p['enableBatch'] == 1 ? Colors.green : Colors.grey),
                            const SizedBox(width: 8),
                            const Text('批次管理'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(p['enableExpiry'] == 1 ? Icons.check_circle : Icons.cancel,
                                 color: p['enableExpiry'] == 1 ? Colors.green : Colors.grey),
                            const SizedBox(width: 8),
                            const Text('保质期'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(p['enableSerial'] == 1 ? Icons.check_circle : Icons.cancel,
                                 color: p['enableSerial'] == 1 ? Colors.green : Colors.grey),
                            const SizedBox(width: 8),
                            const Text('序列号'),
                          ],
                        ),
                        if (p['shelfLifeDays'] != null)
                          Text('保质期天数: ${p['shelfLifeDays']}天'),
                      ],
                    ),
                  ),
                ),
                
                // 多单位
                if (_units.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('单位换算', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          ..._units.map((u) => ListTile(
                            dense: true,
                            title: Text(u['unitName'] ?? ''),
                            subtitle: Text('换算比: ${u['ratio'] ?? 1}'),
                            trailing: Text('¥${u['salePrice'] ?? 0}'),
                          )),
                        ],
                      ),
                    ),
                  ),
                
                // 条码列表
                if (_barcodes.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('条码列表', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          ..._barcodes.map((b) => ListTile(
                            dense: true,
                            leading: Icon(b['isMain'] == 1 ? Icons.star : Icons.qr_code),
                            title: Text(b['barcode'] ?? ''),
                            subtitle: Text('${b['unitName'] ?? ''} | ¥${b['salePrice'] ?? 0}'),
                          )),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}

/// 更多页面
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('更多')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('客户管理'),
            subtitle: const Text('客户价格本、信用额度'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('供应商管理'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('仓库管理'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('库存查询'),
            subtitle: const Text('批次库存、过期预警'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('条码管理'),
            subtitle: const Text('扫码录入、条码打印'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('系统设置'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('API地址'),
            subtitle: const Text('http://42.193.169.78:8090'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}