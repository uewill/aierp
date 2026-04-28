/// 字段配置模型
class FieldConfig {
  final String fieldCode;
  final String fieldName;
  final String fieldType;
  final String fieldGroup;
  final bool isRequired;
  final bool isVisible;
  final bool editable;
  final int sortOrder;
  final bool canRename;
  final bool canHide;
  final bool canRequired;

  FieldConfig({
    required this.fieldCode,
    required this.fieldName,
    required this.fieldType,
    required this.fieldGroup,
    required this.isRequired,
    required this.isVisible,
    required this.editable,
    required this.sortOrder,
    required this.canRename,
    required this.canHide,
    required this.canRequired,
  });

  factory FieldConfig.fromJson(Map<String, dynamic> json) {
    return FieldConfig(
      fieldCode: json['fieldCode'] as String,
      fieldName: json['fieldName'] as String,
      fieldType: json['fieldType'] as String,
      fieldGroup: json['fieldGroup'] as String,
      isRequired: json['isRequired'] as bool,
      isVisible: json['isVisible'] as bool,
      editable: json['editable'] as bool,
      sortOrder: json['sortOrder'] as int,
      canRename: json['canRename'] as bool,
      canHide: json['canHide'] as bool,
      canRequired: json['canRequired'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldCode': fieldCode,
      'fieldName': fieldName,
      'fieldType': fieldType,
      'fieldGroup': fieldGroup,
      'isRequired': isRequired,
      'isVisible': isVisible,
      'editable': editable,
      'sortOrder': sortOrder,
      'canRename': canRename,
      'canHide': canHide,
      'canRequired': canRequired,
    };
  }
}