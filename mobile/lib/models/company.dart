import 'package:equatable/equatable.dart';

/// 公司模型
class Company extends Equatable {
  final String id;
  final String name;
  final String code;
  final String address;
  final String phone;
  final String contactPerson;
  final DateTime createdAt;
  final bool isActive;

  const Company({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.phone,
    required this.contactPerson,
    required this.createdAt,
    this.isActive = true,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'phone': phone,
      'contactPerson': contactPerson,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [id, name, code, address, phone, contactPerson, createdAt, isActive];
}