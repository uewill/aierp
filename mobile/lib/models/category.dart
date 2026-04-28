/// 商品分类模型
class Category {
  final int? id;
  final String name;
  final int? parentId;
  final String code;
  final int level;
  final bool hasChildren;
  final DateTime createdAt;
  final List<Category>? children;

  Category({
    this.id,
    required this.name,
    this.parentId,
    required this.code,
    required this.level,
    this.hasChildren = false,
    DateTime? createdAt,
    this.children,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      parentId: json['parentId'],
      code: json['code'] ?? '',
      level: json['level'] ?? 1,
      hasChildren: json['hasChildren'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      children: json['children'] != null
          ? (json['children'] as List).map((e) => Category.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'code': code,
      'level': level,
      'hasChildren': hasChildren,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    int? parentId,
    String? code,
    int? level,
    bool? hasChildren,
    DateTime? createdAt,
    List<Category>? children,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      code: code ?? this.code,
      level: level ?? this.level,
      hasChildren: hasChildren ?? this.hasChildren,
      createdAt: createdAt ?? this.createdAt,
      children: children ?? this.children,
    );
  }
}