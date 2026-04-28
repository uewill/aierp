/// 规格属性模型
class SpecAttribute {
  final String name;
  final List<String> values;

  const SpecAttribute({
    required this.name,
    required this.values,
  });

  /// 从JSON创建规格属性实例
  factory SpecAttribute.fromJson(Map<String, dynamic> json) {
    return SpecAttribute(
      name: json['name'] as String? ?? '',
      values: (json['values'] as List?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'values': values,
    };
  }

  /// 创建副本并更新指定字段
  SpecAttribute copyWith({
    String? name,
    List<String>? values,
  }) {
    return SpecAttribute(
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }
}