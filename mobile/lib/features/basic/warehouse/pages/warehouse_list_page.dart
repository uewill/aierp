import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 仓库列表页面 - 支持增删改查

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/api/warehouse_api.dart';
import 'package:aierp_mobile/features/basic/warehouse/pages/warehouse_edit_page.dart';

class WarehouseListPage extends StatefulWidget {
  const WarehouseListPage({super.key});

  @override
  State<WarehouseListPage> createState() => _WarehouseListPageState();
}

class _WarehouseListPageState extends State<WarehouseListPage> {
  final WarehouseApi _warehouseApi = WarehouseApi();
  
  List<Map<String, dynamic>> _warehouses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  Future<void> _loadWarehouses() async {
    setState(() => _isLoading = true);
    try {
      _warehouses = await _warehouseApi.getWarehouseList();
    } catch (e) {
      TDToast.showFail('加载仓库列表失败', context: context);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TDNavBar(
        title: '仓库管理',
        backgroundColor: AppTheme.brandColor,
        leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))],
      ),
      body: _buildWarehouseList(context),
      floatingActionButton: TDButton(
        text: '添加',
        icon: TDIcons.add,
        theme: TDButtonTheme.primary,
        shape: TDButtonShape.circle,
        onTap: () => _navigateToEdit(null),
      ),
    );
  }

  /// 仓库列表
  Widget _buildWarehouseList(BuildContext context) {
    if (_isLoading && _warehouses.isEmpty) {
      return const Center(child: TDLoading(size: TDLoadingSize.large));
    }

    if (_warehouses.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => _loadWarehouses(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _warehouses.length,
        itemBuilder: (context, index) => _buildWarehouseItem(context, _warehouses[index]),
      ),
    );
  }

  /// 仓库卡片
  Widget _buildWarehouseItem(BuildContext context, Map<String, dynamic> warehouse) {
    final id = warehouse['id'] as int?;
    final name = warehouse['name'] ?? '';
    final code = warehouse['code'] ?? '';
    final address = warehouse['address'] ?? '';
    final manager = warehouse['manager'] ?? '-';
    final phone = warehouse['phone'] ?? '';
    final isDefault = warehouse['isDefault'] ?? false;
    final enabled = warehouse['enabled'] ?? true;

    return GestureDetector(
      onTap: () => _navigateToEdit({'id': id}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 仓库图标
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDefault ? AppTheme.brandColor1 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  TDIcons.home,
                  color: isDefault ? AppTheme.brandColor8 : Colors.grey.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              // 仓库信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名称 + 标签
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isDefault)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.brandColor1,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.brandColor6),
                            ),
                            child: Text('默认', style: TextStyle(color: AppTheme.brandColor8, fontSize: 11)),
                          ),
                        if (!enabled)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('已禁用', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ),
                      ],
                    ),
                    
                    if (code.isNotEmpty)
                      const SizedBox(height: 4),
                    if (code.isNotEmpty)
                      Text('编码: $code', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    
                    const SizedBox(height: 4),
                    
                    // 管理员
                    Row(
                      children: [
                        Icon(TDIcons.user, color: Colors.grey.shade500, size: 14),
                        const SizedBox(width: 4),
                        Text(manager, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        if (phone.isNotEmpty)
                          const SizedBox(width: 8),
                        if (phone.isNotEmpty)
                          Icon(Icons.phone, color: Colors.grey.shade500, size: 14),
                        if (phone.isNotEmpty)
                          const SizedBox(width: 4),
                        if (phone.isNotEmpty)
                          Text(phone, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                    
                    if (address.isNotEmpty)
                      const SizedBox(height: 4),
                    if (address.isNotEmpty)
                      Row(
                        children: [
                          Icon(TDIcons.location, color: Colors.grey.shade500, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              address,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // 操作按钮
              Column(
                children: [
                  // 编辑按钮
                  GestureDetector(
                    onTap: () => _navigateToEdit({'id': id}),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.brandColor1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(TDIcons.edit, color: AppTheme.brandColor8, size: 18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 删除按钮
                  GestureDetector(
                    onTap: () => _showDeleteConfirm(context, id, name, isDefault),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(TDIcons.delete, color: Color(0xFFFF4D4F), size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(TDIcons.home, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('暂无仓库数据', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 24),
          TDButton(
            text: '添加仓库',
            theme: TDButtonTheme.primary,
            size: TDButtonSize.large,
            onTap: () => _navigateToEdit(null),
          ),
        ],
      ),
    );
  }

  /// 导航到编辑页面
  Future<void> _navigateToEdit(Map<String, dynamic>? args) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WarehouseEditPage(),
        settings: RouteSettings(arguments: args),
      ),
    );
    
    if (result == true) {
      _loadWarehouses();
    }
  }

  /// 删除确认
  void _showDeleteConfirm(BuildContext context, int? id, String name, bool isDefault) {
    if (id == null) return;
    
    if (isDefault) {
      TDToast.showFail('默认仓库不能删除', context: context);
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('是否删除仓库「$name」？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _warehouseApi.deleteWarehouse(id);
                TDToast.showSuccess('删除成功', context: context);
                _loadWarehouses();
              } catch (e) {
                TDToast.showFail('删除失败：$e', context: context);
              }
            },
            child: const Text('删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }
}