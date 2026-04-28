import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 选择器页面基类
/// 用于基础资料选择（客户、商品、仓库等）
/// 支持分页查询、搜索
abstract class BaseSelectorPage<T> extends StatefulWidget {
  /// 是否多选
  final bool multiSelect;
  
  /// 已选中的项
  final List<T> selectedItems;
  
  /// 标题
  final String title;

  const BaseSelectorPage({
    super.key,
    this.multiSelect = false,
    this.selectedItems = const [],
    this.title = '请选择',
  });
}

/// 选择器页面状态基类
abstract class BaseSelectorPageState<T, W extends BaseSelectorPage<T>> extends State<W> {
  /// 搜索关键词
  String _keyword = '';
  
  /// 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  
  /// 是否加载中
  bool _isLoading = false;
  
  /// 数据列表
  List<T> _dataList = [];
  
  /// 当前页码
  int _currentPage = 1;
  
  /// 总数量
  int _totalCount = 0;
  
  /// 是否有更多数据
  bool _hasMore = true;
  
  /// 已选中的项
  final Set<T> _selectedSet = {};

  @override
  void initState() {
    super.initState();
    _selectedSet.addAll(widget.selectedItems);
    _loadData(isRefresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 获取列表项的唯一标识
  String getItemId(T item);

  /// 获取列表项的显示名称
  String getItemName(T item);
  
  /// 获取列表项的副标题
  String? getItemSubtitle(T item) => null;

  /// 加载数据的方法（子类实现）
  Future<List<T>> fetchData(String keyword, int page, int pageSize);

  /// 刷新数据
  Future<void> _loadData({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (isRefresh) {
        _currentPage = 1;
        _hasMore = true;
      }

      final list = await fetchData(_keyword, _currentPage, 20);

      setState(() {
        if (isRefresh) {
          _dataList = list;
        } else {
          _dataList.addAll(list);
        }
        _hasMore = list.length >= 20;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        TDToast.showText('加载失败: $e', context: context);
      }
    }
  }

  /// 加载更多
  Future<void> _loadMore() async {
    if (!_hasMore || _isLoading) return;
    _currentPage++;
    await _loadData();
  }

  /// 搜索
  void _onSearch(String value) {
    _keyword = value;
    _loadData(isRefresh: true);
  }

  /// 切换选中状态
  void _toggleSelection(T item) {
    setState(() {
      final id = getItemId(item);
      if (_selectedSet.any((e) => getItemId(e) == id)) {
        _selectedSet.removeWhere((e) => getItemId(e) == id);
      } else {
        if (widget.multiSelect) {
          _selectedSet.add(item);
        } else {
          _selectedSet.clear();
          _selectedSet.add(item);
        }
      }
    });
  }

  /// 确认选择
  void _confirmSelection() {
    Navigator.of(context).pop(_selectedSet.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: TDNavBar(
        title: widget.title,
        useDefaultBack: true,
        rightBarItems: [
          TDNavBarItem(
            icon: TDIcons.check,
            action: _confirmSelection,
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),
          
          // 已选择数量提示
          if (_selectedSet.isNotEmpty) _buildSelectedBar(),
          
          // 列表
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacer3),
      color: AppTheme.bgContainer,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '请输入关键词搜索',
          prefixIcon: const Icon(TDIcons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) => _keyword = value,
        onSubmitted: (value) => _onSearch(value),
      ),
    );
  }

  /// 构建已选择提示栏
  Widget _buildSelectedBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacer4,
        vertical: AppTheme.spacer2,
      ),
      color: AppTheme.brandColorLight,
      child: Row(
        children: [
          Text(
            '已选择 ${_selectedSet.length} 项',
            style: const TextStyle(
              color: AppTheme.brandColor,
              fontSize: AppTheme.fontSizeS,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _selectedSet.clear()),
            child: const Text(
              '清空',
              style: TextStyle(
                color: AppTheme.brandColor,
                fontSize: AppTheme.fontSizeS,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建列表
  Widget _buildList() {
    if (_isLoading && _dataList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_dataList.isEmpty) {
      return TDEmpty(
        type: TDEmptyType.plain,
        emptyText: _keyword.isEmpty ? '暂无数据' : '未找到相关数据',
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _dataList.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _dataList.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spacer4),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final item = _dataList[index];
          final isSelected = _selectedSet.any((e) => getItemId(e) == getItemId(item));

          return _buildListItem(item, isSelected);
        },
      ),
    );
  }

  /// 构建列表项
  Widget _buildListItem(T item, bool isSelected) {
    return TDCell(
      title: getItemName(item),
      note: getItemSubtitle(item),
      arrow: false,
      onClick: (_) => _toggleSelection(item),
    );
  }
}