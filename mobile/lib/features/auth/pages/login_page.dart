import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 登录页面 - 简洁设计

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '123456');
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandColor7,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.inventory, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              const Text('FocusJXC', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 8),
              Text('进销存管理系统', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
              const SizedBox(height: 60),
              
              // 登录表单
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // 用户名输入
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: '用户名',
                        prefixIcon: const Icon(Icons.person, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    
                    // 密码输入
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '密码',
                        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    
                    // 登录按钮
                    SizedBox(
                      width: double.infinity,
                      child: TDButton(
                        text: '登录',
                        theme: TDButtonTheme.primary,
                        size: TDButtonSize.large,
                        onTap: () => _login(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              Text('默认账号: admin / 123456', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final appState = context.read<AppState>();
      final success = await appState.login(
        _usernameController.text,
        _passwordController.text,
      );
      
      setState(() => _isLoading = false);
      
      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('登录失败: ${appState.loginError ?? "请检查网络连接"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('登录异常: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}