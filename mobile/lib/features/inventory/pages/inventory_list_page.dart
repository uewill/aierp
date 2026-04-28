import 'package:aierp_mobile/core/theme/app_theme.dart';
/// 库存列表页面 - 使用真实 API
/// 功能：分页加载、仓库筛选、商品搜索、下拉刷新

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/data/providers/app_providers.dart';
import 'package:aierp_mobile/api/inventory_api.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedWarehouseId;
  
  @override
  void initState() {
    super.initState();
    // 加载仓库列表
    context.read<WarehouseProvider>().loadWarehouses();
    // 加载库存数据
    context.read<InventoryPageProvider>().loadInventoryPage();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TDNavBar(
        title: '库存查询',
        backgroundColor: AppTheme.brandColor,
        leftBarItems: [TDNavBarItem(icon: TDIcons.chevron_left, action: () => Navigator.pop(context))],
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          Expanded(child: _buildInventoryList(context)),
        ],
      ),
    );
  }
  
  /// 筛选栏：仓库选择 + 搜索
  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Row(
        children: [
          // 仓库选择
          Expanded(
            flex: 2,
            child: Consumer<WarehouseProvider>(
              builder: (context, warehouseProvider, child) {
                final warehouses = warehouseProvider.warehouses;
                return DropdownButtonFormField<String>(
                  value: _selectedWarehouseId?.toString() ?? '',
                  decoration: InputDecoration(
                    hintText: '全部仓库',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  items: [
                    const DropdownMenuItem(value: '', child: Text('全部仓库')),
                    ...warehouses.map((w) => DropdownMenuItem(
                      value: w.id,
                      child: Text(w.name),
                    )),
                  ],
                  onChanged: (value) {
                    final id = value!.isEmpty ? null : int.tryParse(value);
                    setState(() => _selectedWarehouseId = id);
                    context.read<InventoryPageProvider>().setWarehouseFilter(id);
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // 搜索框
          Expanded(
            flex: 3,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索商品名称',
                prefixIcon: const Icon(TDIcons.search),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        context.read<InventoryPageProvider>().search('');
                      },
                      child: const Icon(TDIcons.close_circle),
                    )
                  : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (text) {
                context.read<InventoryPageProvider>().search(text);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  /// 库存列表（支持分页和下拉刷新）
  Widget _buildInventoryList(BuildContext context) {
    return Consumer<InventoryPageProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text('暂无库存数据', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100 &&
                  provider.hasMore &&
                  !provider.isLoading) {
                provider.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.records.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.records.length) {
                  // 加载更多指示器
                  return Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: provider.isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('已加载全部', style: TextStyle(color: Colors.grey)),
                  );
                }
                
                final item = provider.records[index];
                return _buildItem(context, item);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, InventoryItem item) {
    final productName = item.productName;
    final skuName = item.skuName ?? '';
    final warehouseName = item.warehouseName;
    final quantity = item.quantity;
    final available = item.availableQuantity;
    
    // 库存不足判断（低于50）
    final isLowStock = quantity < 50;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isLowStock ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              if (isLowStock) TDTag('库存不足', theme: TDTagTheme.warning, size: TDTagSize.small),
            ],
          ),
          const SizedBox(height: 8),
          if (skuName.isNotEmpty) Text('规格: $skuName', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.store, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(warehouseName, style: TextStyle(fontSize: 12, color: Colors.blue[700])),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    quantity.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isLowStock ? Colors.orange : const Color(0xFF0052D9),
                    ),
                  ),
                  Text(
                    '可用: ${available.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}