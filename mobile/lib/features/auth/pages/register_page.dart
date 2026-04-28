import 'package:flutter/material.dart';
import 'package:aierp_mobile/core/utils/form_validators.dart';

/// 注册页面 - 使用标准 Flutter 组件
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户注册'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('创建新账户', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              // 用户名
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '用户名 *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => FormValidators.validateRequired(value, fieldName: '用户名'),
              ),
              const SizedBox(height: 16),
              
              // 手机号
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '手机号 *',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: FormValidators.validatePhone,
              ),
              const SizedBox(height: 16),
              
              // 邮箱
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: FormValidators.validateEmail,
              ),
              const SizedBox(height: 16),
              
              // 密码
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '密码 *',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => FormValidators.validatePassword(value),
              ),
              const SizedBox(height: 16),
              
              // 确认密码
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '确认密码 *',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请确认密码';
                  }
                  if (value != _passwordController.text) {
                    return '两次输入的密码不一致';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // 注册按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('注册', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              
              // 已有账户提示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('已有账户？'),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('立即登录', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      // 这里应该调用注册 API
      // 模拟注册成功
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('注册成功！')),
      );
      Navigator.pop(context);
    }
  }
}