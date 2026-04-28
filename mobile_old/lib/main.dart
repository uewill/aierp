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
  
  static Future<Map<String, dynamic>> confirmDraft(int draftId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/draft/$draftId/confirm'),
    );
    return jsonDecode(response.body);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController(text: '18190780080');
  final _codeController = TextEditingController(text: '123456');
  bool _loading = false;

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
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: '验证码',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('开发模式验证码: 123456', style: TextStyle(color: Colors.orange, fontSize: 12)),
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
    const PlaceholderPage('商品管理'),
    const PlaceholderPage('更多'),
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

/// AI 录入页 - 核心功能
class AIInputPage extends StatefulWidget {
  const AIInputPage({super.key});

  @override
  State<AIInputPage> createState() => _AIInputPageState();
}

class _AIInputPageState extends State<AIInputPage> {
  final _inputController = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  int? _draftId;

  Future<void> _parseInput() async {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入订单内容')));
      return;
    }
    
    setState(() => _loading = true);
    try {
      final response = await ApiService.aiTextInput(_inputController.text);
      if (response['code'] == 200) {
        setState(() {
          _result = response['data'];
          _draftId = response['data']['draftId'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? '解析失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('网络错误: $e')));
    }
    setState(() => _loading = false);
  }

  Future<void> _confirmOrder() async {
    if (_draftId == null) return;
    
    try {
      final response = await ApiService.confirmDraft(_draftId!);
      if (response['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('订单已生成！')));
        setState(() {
          _result = null;
          _draftId = null;
          _inputController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? '确认失败')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('网络错误: $e')));
    }
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
                        hintText: '例如：销售可乐10箱@50元，矿泉水5瓶@3元',
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
                          title: Text(item['productName']),
                          subtitle: Text('${item['quantity']} ${item['unit']}'),
                          trailing: item['price'] != null ? Text('¥${item['price']}') : null,
                        ),
                      ),
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
                              onPressed: _confirmOrder,
                              icon: const Icon(Icons.check),
                              label: const Text('确认生成订单'),
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
                    Text('• 销售：可乐10箱@50元，矿泉水5瓶@3元'),
                    Text('• 采购：可乐20箱@45元，来自供应商李四'),
                    Text('• 卖给张三：可乐5箱单价50元'),
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
class SalesOrderListPage extends StatelessWidget {
  const SalesOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('销售单')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.receipt, color: Colors.orange),
            title: const Text('SO202604280001'),
            subtitle: const Text('可乐10箱@50元 | ¥500'),
            trailing: const Chip(label: Text('待审核')),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.receipt, color: Colors.green),
            title: const Text('SO202604280002'),
            subtitle: const Text('矿泉水100瓶@3元 | ¥300'),
            trailing: const Chip(label: Text('已通过')),
            onTap: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 跳转到 AI 录入页
          DefaultTabController.of(context).animateTo(0);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('$title 功能开发中...', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}