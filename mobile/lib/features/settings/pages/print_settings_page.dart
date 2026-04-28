import 'package:flutter/material.dart';

/// 打印设置页面
class PrintSettingsPage extends StatefulWidget {
  const PrintSettingsPage({super.key});

  @override
  State<PrintSettingsPage> createState() => _PrintSettingsPageState();
}

class _PrintSettingsPageState extends State<PrintSettingsPage> {
  bool _isConnected = false;
  String _connectedDevice = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('打印设置')),
      body: ListView(
        children: [
          // 连接状态
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                    color: _isConnected ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_isConnected ? '已连接' : '未连接'),
                        if (_isConnected) Text(_connectedDevice, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 设备列表
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('可用设备', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printer-001'),
            subtitle: const Text('热敏打印机'),
            trailing: ElevatedButton(
              onPressed: () => _connect('Printer-001'),
              child: const Text('连接'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Label-Printer'),
            subtitle: const Text('标签打印机'),
            trailing: ElevatedButton(
              onPressed: () => _connect('Label-Printer'),
              child: const Text('连接'),
            ),
          ),
        ],
      ),
    );
  }

  void _connect(String deviceName) {
    setState(() {
      _isConnected = true;
      _connectedDevice = deviceName;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已连接到 $deviceName')),
    );
  }
}