import 'package:flutter/material.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 应用主页
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const HomePage(),
    const ProductPage(),
    const MePage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: '商品'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

/// 首页
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('进销存')),
      body: GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuItem(context, '销售开单', Icons.point_of_sale, '/sales/create'),
          _buildMenuItem(context, '采购入库', Icons.inbox, '/purchase/create'),
          _buildMenuItem(context, '库存查询', Icons.inventory, '/inventory'),
          _buildMenuItem(context, '商品管理', Icons.inventory_2, '/product'),
          _buildMenuItem(context, '往来单位', Icons.people, '/partner'),
          _buildMenuItem(context, '仓库管理', Icons.warehouse, '/warehouse'),
          _buildMenuItem(context, '财务管理', Icons.account_balance_wallet, '/finance'),
          _buildMenuItem(context, '报表中心', Icons.bar_chart, '/report'),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.brandColor, size: 32),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

/// 商品页
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品管理')),
      body: const Center(child: Text('商品列表')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/product/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 我的页面
class MePage extends StatelessWidget {
  const MePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('打印设置'),
            onTap: () => Navigator.pushNamed(context, '/settings/print'),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}