import 'package:aierp_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/shared/models/common_models.dart';

/// 基础资料列表页面基类
abstract class BaseListPage<T> extends StatefulWidget {
  final String title;
  final bool showAddButton;

  const BaseListPage({
    super.key,
    required this.title,
    this.showAddButton = true,
  });
}

/// 列表页面状态基类
abstract class BaseListPageState<T, W extends BaseListPage<T>> extends State<W> {
  String _keyword = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<T> _dataList = [];
  int _currentPage = 1;
  int _totalCount = 0;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadData(isRefresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String getItemId(T item);
  Future<PageResponse<T>> fetchData(String keyword, int page, int pageSize);
  Widget buildListItem(T item, int index);
  void navigateToAddPage();
  void navigateToEditPage(T item);
  Future<bool> deleteItem(T item);

  Future<void> _loadData({bool isRefresh = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (isRefresh) {
        _currentPage = 1;
        _hasMore = true;
      }
      final response = await fetchData(_keyword, _currentPage, 20);
      setState(() {
        if (isRefresh) _dataList = response.list;
        else _dataList.addAll(response.list);
        _totalCount = response.total;
        _hasMore = response.hasMore;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) TDToast.showText('加载失败: $e', context: context);
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isLoading) return;
    _currentPage++;
    await _loadData();
  }

  void _onSearch(String value) {
    _keyword = value;
    _loadData(isRefresh: true);
  }

  Future<void> _confirmDelete(T item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除此数据吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('确定')),
        ],
      ),
    );
    if (confirmed == true) {
      final success = await deleteItem(item);
      if (success && mounted) {
        TDToast.showSuccess('删除成功', context: context);
        _loadData(isRefresh: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: TDNavBar(
        title: widget.title,
        useDefaultBack: true,
        rightBarItems: widget.showAddButton
          ? [TDNavBarItem(icon: Icons.add, action: navigateToAddPage)]
          : null,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.bgContainer,
            child: TDSearchBar(
              placeHolder: '请输入关键词搜索',
              controller: _searchController,
              onTextChanged: (value) => _keyword = value,
              onSubmitted: _onSearch,
            ),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading && _dataList.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_dataList.isEmpty) return TDEmpty(type: TDEmptyType.plain, emptyText: _keyword.isEmpty ? '暂无数据' : '未找到相关数据');
    return RefreshIndicator(
      onRefresh: () => _loadData(isRefresh: true),
      child: ListView.builder(
        itemCount: _dataList.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _dataList.length) {
            _loadMore();
            return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
          }
          final item = _dataList[index];
          return InkWell(
            onTap: () => navigateToEditPage(item),
            onLongPress: () => _confirmDelete(item),
            child: buildListItem(item, index),
          );
        },
      ),
    );
  }
}
