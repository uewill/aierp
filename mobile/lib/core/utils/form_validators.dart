/// 表单验证工具类
class FormValidators {
  /// 验证手机号
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    final phoneRegExp = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegExp.hasMatch(value)) {
      return '手机号格式不正确';
    }
    return null;
  }

  /// 验证邮箱
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱';
    }
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return '邮箱格式不正确';
    }
    return null;
  }

  /// 验证密码
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度不能少于6位';
    }
    return null;
  }

  /// 验证必填字段
  static String? validateRequired(String? value, {String fieldName = '字段'}) {
    if (value == null || value.isEmpty) {
      return '请输入$fieldName';
    }
    return null;
  }

  /// 验证数字
  static String? validateNumber(String? value, {String fieldName = '数值'}) {
    if (value == null || value.isEmpty) {
      return '请输入$fieldName';
    }
    final numRegExp = RegExp(r'^\d+(\.\d+)?$');
    if (!numRegExp.hasMatch(value)) {
      return '$fieldName必须是数字';
    }
    return null;
  }
}