import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aierp_mobile/core/providers/app_state_provider.dart';
import 'package:aierp_mobile/core/routes/app_routes.dart';

/// 启动页 - 检查登录状态和公司选择
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    final appState = context.read<AppStateProvider>();
    
    // 检查是否已登录
    if (!appState.isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    
    // 检查是否已选择公司
    if (appState.selectedCompany == null) {
      Navigator.pushReplacementNamed(context, '/company/select');
      return;
    }
    
    // 已登录且已选择公司，进入主页
    Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text('进销存系统', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}