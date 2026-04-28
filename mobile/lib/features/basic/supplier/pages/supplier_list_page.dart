import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 供应商列表页面 - 支持增删改查

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/api/partner_api.dart';
import 'package:aierp_mobile/features/basic/supplier/pages/supplier_edit_page.dart';

class SupplierListPage extends StatefulWidget {
  const SupplierListPage({super.key});

  @override
  State<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  final PartnerApi _partnerApi = PartnerApi();
  
  List<Map<String, dynamic>> _suppliers = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers({String? keyword}) async {
    setState(() => _isLoading = true);
    try {
      _suppliers = await _partnerApi.getSupplierList(keyword: keyword);
    } catch (e) {
      TDToast.showFail('加载供应商列表失败', context: context);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TDNavBar(
        title: '供应商管理',
        backgroundColor: AppTheme.brandColor,
        leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(child: _buildSupplierList(context)),
        ],
      ),
      floatingActionButton: TDButton(
        text: '添加',
        icon: TDIcons.add,
        theme: TDButtonTheme.primary,
        shape: TDButtonShape.circle,
        onTap: () => _navigateToEdit(null),
      ),
    );
  }

  /// 搜索栏
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索供应商名称/电话',
          prefixIcon: const Icon(TDIcons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: (keyword) {
          _loadSuppliers(keyword: keyword.isNotEmpty ? keyword : null);
        },
      ),
    );
  }

  /// 供应商列表
  Widget _buildSupplierList(BuildContext context) {
    if (_isLoading && _suppliers.isEmpty) {
      return const Center(child: TDLoading(size: TDLoadingSize.large));
    }

    if (_suppliers.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => _loadSuppliers(keyword: _searchController.text.isNotEmpty ? _searchController.text : null),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _suppliers.length,
        itemBuilder: (context, index) => _buildSupplierItem(context, _suppliers[index]),
      ),
    );
  }

  /// 供应商卡片
  Widget _buildSupplierItem(BuildContext context, Map<String, dynamic> supplier) {
    final id = supplier['id'] as int?;
    final name = supplier['name'] ?? '';
    final phone = supplier['phone'] ?? '-';
    final contact = supplier['contact'] ?? '';
    final address = supplier['address'] ?? '';
    final enabled = supplier['enabled'] ?? true;

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
              // 供应商图标
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.brandColor1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(TDIcons.user, color: AppTheme.brandColor8, size: 28),
              ),
              const SizedBox(width: 12),
              // 供应商信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名称 + 启用标签
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
                    
                    const SizedBox(height: 4),
                    
                    // 电话
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey.shade500, size: 14),
                        const SizedBox(width: 4),
                        Text(phone, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        if (contact.isNotEmpty)
                          const SizedBox(width: 8),
                        if (contact.isNotEmpty)
                          Text('($contact)', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
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
                    onTap: () => _showDeleteConfirm(context, id, name),
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
          Icon(TDIcons.user, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('暂无供应商数据', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 24),
          TDButton(
            text: '添加供应商',
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
        builder: (context) => const SupplierEditPage(),
        settings: RouteSettings(arguments: args),
      ),
    );
    
    if (result == true) {
      _loadSuppliers(keyword: _searchController.text.isNotEmpty ? _searchController.text : null);
    }
  }

  /// 删除确认
  void _showDeleteConfirm(BuildContext context, int? id, String name) {
    if (id == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('是否删除供应商「$name」？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _partnerApi.deletePartner(id);
                TDToast.showSuccess('删除成功', context: context);
                _loadSuppliers(keyword: _searchController.text.isNotEmpty ? _searchController.text : null);
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