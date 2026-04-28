import 'package:equatable/equatable.dart';

/// 单位换算模型
class UnitConversion extends Equatable {
  final String baseUnit; // 基础单位
  final String targetUnit; // 目标单位
  final double conversionRate; // 换算率（目标单位 = 基础单位 × 换算率）

  const UnitConversion({
    required this.baseUnit,
    required this.targetUnit,
    required this.conversionRate,
  });

  /// 从JSON创建单位换算实例
  factory UnitConversion.fromJson(Map<String, dynamic> json) {
    return UnitConversion(
      baseUnit: json['baseUnit'] as String? ?? '',
      targetUnit: json['targetUnit'] as String? ?? '',
      conversionRate: json['conversionRate'] as double? ?? 1.0,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'baseUnit': baseUnit,
      'targetUnit': targetUnit,
      'conversionRate': conversionRate,
    };
  }

  /// 创建副本并更新指定字段
  UnitConversion copyWith({
    String? baseUnit,
    String? targetUnit,
    double? conversionRate,
  }) {
    return UnitConversion(
      baseUnit: baseUnit ?? this.baseUnit,
      targetUnit: targetUnit ?? this.targetUnit,
      conversionRate: conversionRate ?? this.conversionRate,
    );
  }

  @override
  List<Object?> get props => [baseUnit, targetUnit, conversionRate];
}