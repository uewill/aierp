/// 分页请求基类
class PageRequest {
  final int page;
  final int pageSize;
  final String? keyword;
  final String? sortBy;
  final String? sortOrder;

  PageRequest({
    this.page = 1,
    this.pageSize = 20,
    this.keyword,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() => {
    'page': page,
    'pageSize': pageSize,
    if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword,
    if (sortBy != null) 'sortBy': sortBy,
    if (sortOrder != null) 'sortOrder': sortOrder,
  };

  PageRequest copyWith({
    int? page,
    int? pageSize,
    String? keyword,
    String? sortBy,
    String? sortOrder,
  }) {
    return PageRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      keyword: keyword ?? this.keyword,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// 分页响应基类
class PageResponse<T> {
  final List<T> list;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasMore;

  PageResponse({
    required this.list,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasMore,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final list = (json['list'] as List?)
        ?.map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList() ?? [];
    final total = json['total'] as int? ?? 0;
    final page = json['page'] as int? ?? 1;
    final pageSize = json['pageSize'] as int? ?? 20;
    final totalPages = json['totalPages'] as int? ?? 0;

    return PageResponse(
      list: list,
      total: total,
      page: page,
      pageSize: pageSize,
      totalPages: totalPages,
      hasMore: page < totalPages,
    );
  }
}

/// API 响应基类
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  bool get isSuccess => code == 200 || code == 0;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse(
      code: json['code'] as int? ?? -1,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : json['data'] as T?,
    );
  }
}

/// 选择器结果
class SelectorResult<T> {
  final T? selected;
  final bool isConfirmed;

  SelectorResult({
    this.selected,
    this.isConfirmed = false,
  });

  bool get hasSelection => selected != null;
}