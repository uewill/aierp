import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'arco_design/arco_design.dart';
import 'features/basic/product/pages/product_create_page.dart';

void main() {
  runApp(const AIERPApp());
}

class AIERPApp extends StatelessWidget {
  const AIERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI进销存',
      theme: ArcoTheme.lightTheme,
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
      backgroundColor: ArcoColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ArcoSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: ArcoColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.inventory,
                  size: 48,
                  color: ArcoColors.primary,
                ),
              ),
              SizedBox(height: ArcoSpacing.m),
              
              // Title
              Text(
                'AI进销存',
                style: ArcoTypography.display2,
              ),
              SizedBox(height: ArcoSpacing.xs),
              Text(
                '智能录入 · 快速开单',
                style: ArcoTypography.body3,
              ),
              SizedBox(height: ArcoSpacing.xxl),
              
              // Phone Input
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: '手机号',
                  prefixIcon: Icon(Icons.phone, color: ArcoColors.textTertiary),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: ArcoSpacing.m),
              
              // Code Input with Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: '验证码',
                        prefixIcon: Icon(Icons.lock, color: ArcoColors.textTertiary),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: ArcoSpacing.s),
                  SizedBox(
                    width: 100,
                    height: 48,
                    child: ArcoButton(
                      label: _countdown > 0 ? '${_countdown}s' : '获取',
                      onPressed: _countdown > 0 || _sendingCode ? null : _sendCode,
                      type: ArcoButtonType.secondary,
                      size: ArcoButtonSize.large,
                      loading: _sendingCode,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ArcoSpacing.xs),
              Text(
                '开发模式验证码: 1234',
                style: ArcoTypography.caption.copyWith(color: ArcoColors.warning),
              ),
              SizedBox(height: ArcoSpacing.l),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ArcoButton(
                  label: '登录',
                  onPressed: _loading ? null : _login,
                  type: ArcoButtonType.primary,
                  size: ArcoButtonSize.large,
                  loading: _loading,
                ),
              ),
              
              SizedBox(height: ArcoSpacing.xl),
            ],
          ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'AI录入',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: '销售单',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: '商品',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: '更多',
          ),
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
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('语音识别待对接')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('图片识别待对接')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ArcoSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(ArcoSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '输入订单内容',
                      style: ArcoTypography.title2,
                    ),
                    SizedBox(height: ArcoSpacing.s),
                    TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: '例如：销售可乐10箱@50元，批次:B20260401',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: ArcoSpacing.m),
                    ArcoButton(
                      label: '智能解析',
                      onPressed: _loading ? null : _parseInput,
                      type: ArcoButtonType.primary,
                      size: ArcoButtonSize.large,
                      loading: _loading,
                      icon: Icon(Icons.auto_fix_high, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_result != null) ...[
              SizedBox(height: ArcoSpacing.m),
              Card(
                color: ArcoColors.primaryLight,
                child: Padding(
                  padding: EdgeInsets.all(ArcoSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ArcoColors.success),
                          SizedBox(width: ArcoSpacing.s),
                          Text(
                            '识别成功 · 置信度 ${_result!['parsedOrder']['confidence']}%',
                            style: ArcoTypography.title2,
                          ),
                        ],
                      ),
                      SizedBox(height: ArcoSpacing.s),
                      Text('订单类型: ${_result!['parsedOrder']['orderType'] == 'SALES' ? '销售单' : '采购单'}'),
                      Divider(),
                      Text('商品明细:', style: ArcoTypography.title2),
                      ...(_result!['parsedOrder']['items'] as List).map((item) => 
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.inventory_2, color: ArcoColors.primary),
                          title: Text(item['productName'] ?? ''),
                          subtitle: Text('${item['quantity']} ${item['unit']}'),
                          trailing: item['price'] != null 
                              ? Text('￥${item['price']}', style: TextStyle(color: ArcoColors.primary))
                              : null,
                        ),
                      ),
                      if (_result!['parsedOrder']['items'][0]['batchNo'] != null)
                        Text(
                          '批次号: ${_result!['parsedOrder']['items'][0]['batchNo']}',
                          style: TextStyle(color: Color(0xFF722ED1)),
                        ),
                      SizedBox(height: ArcoSpacing.m),
                      Row(
                        children: [
                          Expanded(
                            child: ArcoButton(
                              label: '取消',
                              onPressed: () => setState(() => _result = null),
                              type: ArcoButtonType.secondary,
                            ),
                          ),
                          SizedBox(width: ArcoSpacing.s),
                          Expanded(
                            child: ArcoButton(
                              label: '确认生成',
                              onPressed: () async {
                                final res = await ApiService.confirmDraft(_result!['draftId']);
                                if (res['code'] == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('订单已生成！'),
                                      backgroundColor: ArcoColors.success,
                                    ),
                                  );
                                  setState(() {
                                    _result = null;
                                    _inputController.clear();
                                  });
                                }
                              },
                              type: ArcoButtonType.primary,
                              icon: Icon(Icons.check, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: ArcoSpacing.m),
            Card(
              child: Padding(
                padding: EdgeInsets.all(ArcoSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('录入示例', style: ArcoTypography.body2.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: ArcoSpacing.s),
                    Text('• 销售：可乐10箱@50元', style: ArcoTypography.body3),
                    Text('• 含批次：可乐10箱@50元，批次:B20260401', style: ArcoTypography.body3),
                    Text('• 含过期日期：矿泉水5瓶@3元，过期日期:2026-12-31', style: ArcoTypography.body3),
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
        ? Center(child: CircularProgressIndicator(color: ArcoColors.primary))
        : _orders.isEmpty
          ? Center(child: Text('暂无销售单', style: ArcoTypography.body2))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final isApproved = order['status'] == 'APPROVED';
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: ArcoSpacing.m,
                    vertical: ArcoSpacing.xs,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isApproved 
                            ? ArcoColors.successLight 
                            : ArcoColors.warningLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.receipt,
                        color: isApproved 
                            ? ArcoColors.success 
                            : ArcoColors.warning,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      order['orderNo'] ?? '',
                      style: ArcoTypography.body1,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          order['customerName'] ?? '未知客户',
                          style: ArcoTypography.body3,
                        ),
                        Text(
                          '¥${order['totalAmount'] ?? 0}',
                          style: TextStyle(
                            color: ArcoColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        order['status'] ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: isApproved
                              ? ArcoColors.success
                              : ArcoColors.warning,
                        ),
                      ),
                      backgroundColor: isApproved
                          ? ArcoColors.successLight
                          : ArcoColors.warningLight,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(order: order),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AIInputPage()),
        ),
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
        padding: EdgeInsets.all(ArcoSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(ArcoSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('基本信息', style: ArcoTypography.title2),
                    SizedBox(height: ArcoSpacing.s),
                    Text('客户: ${order['customerName'] ?? ''}', style: ArcoTypography.body2),
                    SizedBox(height: ArcoSpacing.xs),
                    Text('状态: ${order['status'] ?? ''}', style: ArcoTypography.body2),
                    SizedBox(height: ArcoSpacing.xs),
                    Text('日期: ${order['orderDate'] ?? ''}', style: ArcoTypography.body2),
                    if (order['aiSource'] != null) ...[
                      SizedBox(height: ArcoSpacing.xs),
                      Text(
                        'AI来源: ${order['aiSource']}',
                        style: TextStyle(color: Color(0xFF722ED1)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: ArcoSpacing.m),
            Card(
              child: Padding(
                padding: EdgeInsets.all(ArcoSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('商品明细', style: ArcoTypography.title2),
                    SizedBox(height: ArcoSpacing.s),
                    ...details.map((d) => ListTile(
                      dense: true,
                      leading: Icon(Icons.inventory_2, color: ArcoColors.primary, size: 20),
                      title: Text(d['productName'] ?? '', style: ArcoTypography.body2),
                      subtitle: Text('${d['quantity']} ${d['unit']} × ¥${d['price'] ?? 0}'),
                      trailing: Text(
                        '¥${d['amount'] ?? 0}',
                        style: TextStyle(
                          color: ArcoColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      isThreeLine: d['batchNo'] != null,
                      onTap: () {
                        if (d['batchNo'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('批次号: ${d['batchNo']}'),
                              backgroundColor: ArcoColors.textPrimary,
                            ),
                          );
                        }
                      },
                    )),
                    Divider(),
                    SizedBox(height: ArcoSpacing.s),
                    Text(
                      '合计: ¥${order['totalAmount'] ?? 0}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ArcoColors.primary,
                      ),
                    ),
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
      appBar: AppBar(
        title: const Text('商品管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductCreatePage(),
                ),
              );
              if (result == true) {
                _loadProducts();
              }
            },
          ),
        ],
      ),
      body: _loading 
        ? Center(child: CircularProgressIndicator(color: ArcoColors.primary))
        : _products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: ArcoColors.textPlaceholder),
                  SizedBox(height: ArcoSpacing.m),
                  Text('暂无商品', style: ArcoTypography.body2),
                  SizedBox(height: ArcoSpacing.s),
                  ArcoButton(
                    label: '添加商品',
                    type: ArcoButtonType.primary,
                    size: ArcoButtonSize.medium,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductCreatePage(),
                        ),
                      );
                      if (result == true) {
                        _loadProducts();
                      }
                    },
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final p = _products[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: ArcoSpacing.m,
                    vertical: ArcoSpacing.xs,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ArcoColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: ArcoColors.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      p['name'] ?? '',
                      style: ArcoTypography.body1,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          '编码: ${p['code'] ?? ''}',
                          style: ArcoTypography.body3,
                        ),
                        Text(
                          '${p['unit'] ?? ''}',
                          style: ArcoTypography.body3,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '¥${p['salePrice'] ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ArcoColors.primary,
                                fontSize: 16,
                              ),
                            ),
                            if (p['enableBatch'] == 1) ...[
                              SizedBox(height: 4),
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Color(0xFF722ED1),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(width: ArcoSpacing.s),
                        IconButton(
                          icon: Icon(Icons.edit, color: ArcoColors.primary, size: 20),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductCreatePage(),
                                settings: RouteSettings(arguments: p['id']),
                              ),
                            );
                            if (result == true) {
                              _loadProducts();
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: p),
                      ),
                    ),
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
        ? Center(child: CircularProgressIndicator(color: ArcoColors.primary))
        : SingleChildScrollView(
            padding: EdgeInsets.all(ArcoSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 基本信息
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(ArcoSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('基本信息', style: ArcoTypography.title2),
                        SizedBox(height: ArcoSpacing.s),
                        Text('编码: ${p['code'] ?? ''}', style: ArcoTypography.body2),
                        SizedBox(height: ArcoSpacing.xs),
                        Text('条码: ${p['barcode'] ?? ''}', style: ArcoTypography.body2),
                        SizedBox(height: ArcoSpacing.xs),
                        Text('单位: ${p['unit'] ?? ''}', style: ArcoTypography.body2),
                        SizedBox(height: ArcoSpacing.xs),
                        Text(
                          '销售价: ¥${p['salePrice'] ?? 0}',
                          style: TextStyle(color: ArcoColors.primary, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: ArcoSpacing.xs),
                        Text('进货价: ¥${p['purchasePrice'] ?? 0}', style: ArcoTypography.body2),
                        SizedBox(height: ArcoSpacing.xs),
                        Text('库存: ${p['stock'] ?? 0}', style: ArcoTypography.body2),
                      ],
                    ),
                  ),
                ),
                
                // 启用功能
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(ArcoSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('启用功能', style: ArcoTypography.title2),
                        SizedBox(height: ArcoSpacing.s),
                        _buildFeatureRow('多单位', p['enableMultiUnit'] == 1),
                        SizedBox(height: ArcoSpacing.xs),
                        _buildFeatureRow('批次管理', p['enableBatch'] == 1),
                        SizedBox(height: ArcoSpacing.xs),
                        _buildFeatureRow('保质期', p['enableExpiry'] == 1),
                        SizedBox(height: ArcoSpacing.xs),
                        _buildFeatureRow('序列号', p['enableSerial'] == 1),
                        if (p['shelfLifeDays'] != null) ...[
                          SizedBox(height: ArcoSpacing.xs),
                          Text('保质期天数: ${p['shelfLifeDays']}天', style: ArcoTypography.body3),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // 多单位
                if (_units.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(ArcoSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('单位换算', style: ArcoTypography.title2),
                          SizedBox(height: ArcoSpacing.s),
                          ..._units.map((u) => ListTile(
                            dense: true,
                            leading: Icon(Icons.swap_horiz, color: ArcoColors.primary, size: 20),
                            title: Text(u['unitName'] ?? '', style: ArcoTypography.body2),
                            subtitle: Text('换算比: ${u['ratio'] ?? 1}'),
                            trailing: Text(
                              '¥${u['salePrice'] ?? 0}',
                              style: TextStyle(color: ArcoColors.primary, fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                
                // 条码列表
                if (_barcodes.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(ArcoSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('条码列表', style: ArcoTypography.title2),
                          SizedBox(height: ArcoSpacing.s),
                          ..._barcodes.map((b) => ListTile(
                            dense: true,
                            leading: Icon(
                              b['isMain'] == 1 ? Icons.star : Icons.qr_code,
                              color: b['isMain'] == 1 ? ArcoColors.warning : ArcoColors.primary,
                              size: 20,
                            ),
                            title: Text(b['barcode'] ?? '', style: ArcoTypography.body2),
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

  Widget _buildFeatureRow(String label, bool enabled) {
    return Row(
      children: [
        Icon(
          enabled ? Icons.check_circle : Icons.cancel,
          color: enabled ? ArcoColors.success : ArcoColors.textPlaceholder,
          size: 20,
        ),
        SizedBox(width: ArcoSpacing.s),
        Text(
          label,
          style: TextStyle(
            color: enabled ? ArcoColors.textPrimary : ArcoColors.textTertiary,
          ),
        ),
      ],
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
          _buildMenuItem(Icons.people, '客户管理', '客户价格本、信用额度'),
          _buildMenuItem(Icons.business, '供应商管理', null),
          _buildMenuItem(Icons.store, '仓库管理', null),
          _buildMenuItem(Icons.inventory, '库存查询', '批次库存、过期预警'),
          _buildMenuItem(Icons.qr_code, '条码管理', '扫码录入、条码打印'),
          _buildMenuItem(Icons.settings, '系统设置', null),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String? subtitle) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ArcoSpacing.m,
        vertical: ArcoSpacing.xs,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ArcoColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: ArcoColors.primary, size: 20),
        ),
        title: Text(title, style: ArcoTypography.body1),
        subtitle: subtitle != null 
            ? Text(subtitle, style: ArcoTypography.body3)
            : null,
        trailing: Icon(Icons.chevron_right, color: ArcoColors.textTertiary),
        onTap: () {},
      ),
    );
  }
}
