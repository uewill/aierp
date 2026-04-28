/// 商品单位模型
class Unit {
  final int? id;
  final String name;
  final String code;
  final int status;
  
  Unit({
    this.id,
    required this.name,
    required this.code,
    this.status = 1,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      status: json['status'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'status': status,
    };
  }

  Unit copyWith({
    int? id,
    String? name,
    String? code,
    int? status,
  }) {
    return Unit(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      status: status ?? this.status,
    );
  }
}