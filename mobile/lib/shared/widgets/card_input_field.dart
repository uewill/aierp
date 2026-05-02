import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 卡片式输入框组件 - 符合Arco Design Mobile风格
/// 每个字段独立卡片，标题在上，输入区域在下
class CardInputField extends StatelessWidget {
  /// 标题
  final String title;
  
  /// 提示文字
  final String? hint;
  
  /// 当前值
  final String? value;
  
  /// 值变更回调
  final ValueChanged<String>? onChanged;
  
  /// 输入类型
  final TextInputType? keyboardType;
  
  /// 是否必填
  final bool required;
  
  /// 最大行数
  final int? maxLines;
  
  /// 是否禁用
  final bool disabled;
  
  /// 右侧图标
  final Widget? suffixIcon;
  
  /// 点击回调（用于选择器）
  final VoidCallback? onTap;
  
  /// 控制器
  final TextEditingController? controller;

  const CardInputField({
    Key? key,
    required this.title,
    this.hint,
    this.value,
    this.onChanged,
    this.keyboardType,
    this.required = false,
    this.maxLines = 1,
    this.disabled = false,
    this.suffixIcon,
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用传入的controller或根据value创建临时controller
    final effectiveController = controller ?? TextEditingController(text: value ?? '');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // 轻微阴影效果（可选）
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Text(
                  required ? '$title *' : title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4E5969), // Arco Gray-8
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (required)
                  const SizedBox(width: 4),
              ],
            ),
          ),
          
          // 输入区域
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: GestureDetector(
              onTap: disabled ? null : onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA), // Arco Gray-1 浅灰背景
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFFE5E6EB), // Arco Gray-3 边框
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: effectiveController,
                  enabled: !disabled && onTap == null,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  minLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1D2129), // Arco Gray-10
                  ),
                  decoration: InputDecoration(
                    hintText: hint ?? '请输入$title',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFC9CDD4), // Arco Gray-4 placeholder
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    suffixIcon: suffixIcon,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 卡片式选择器组件
class CardSelectField extends StatelessWidget {
  /// 标题
  final String title;
  
  /// 提示文字
  final String? hint;
  
  /// 当前显示值
  final String? displayValue;
  
  /// 是否必填
  final bool required;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  /// 右侧图标
  final Widget? suffixIcon;

  const CardSelectField({
    Key? key,
    required this.title,
    this.hint,
    this.displayValue,
    this.required = false,
    this.onTap,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              required ? '$title *' : title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4E5969),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 选择区域（可点击）
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFFE5E6EB),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          displayValue ?? (hint ?? '请选择$title'),
                          style: TextStyle(
                            fontSize: 14,
                            color: displayValue != null
                              ? const Color(0xFF1D2129)
                              : const Color(0xFFC9CDD4),
                          ),
                        ),
                      ),
                    ),
                    suffixIcon ?? const Icon(
                      TDIcons.chevron_right,
                      size: 20,
                      color: Color(0xFF86909C), // Arco Gray-6
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 卡片式开关组件
class CardSwitchField extends StatelessWidget {
  /// 标题
  final String title;
  
  /// 当前值
  final bool value;
  
  /// 变更回调
  final ValueChanged<bool>? onChanged;
  
  /// 说明文字
  final String? description;

  const CardSwitchField({
    Key? key,
    required this.title,
    required this.value,
    this.onChanged,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4E5969),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF86909C),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            TDSwitch(
              size: TDSwitchSize.medium,
              isOn: value,
              onChanged: (bool v) {
                if (onChanged != null) {
                  onChanged!(v);
                }
                return v;
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 卡片式日期选择组件
class CardDateField extends StatelessWidget {
  /// 标题
  final String title;
  
  /// 当前值（格式化后的日期字符串）
  final String? displayValue;
  
  /// 提示文字
  final String? hint;
  
  /// 是否必填
  final bool required;
  
  /// 点击回调
  final VoidCallback? onTap;

  const CardDateField({
    Key? key,
    required this.title,
    this.displayValue,
    this.hint,
    this.required = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardSelectField(
      title: title,
      hint: hint,
      displayValue: displayValue,
      required: required,
      onTap: onTap,
      suffixIcon: const Icon(
        TDIcons.calendar,
        size: 20,
        color: Color(0xFF86909C),
      ),
    );
  }
}

/// 卡片式数字输入组件（带单位）
class CardNumberField extends StatelessWidget {
  /// 标题
  final String title;
  
  /// 当前值
  final String? value;
  
  /// 单位
  final String? unit;
  
  /// 提示文字
  final String? hint;
  
  /// 是否必填
  final bool required;
  
  /// 值变更回调
  final ValueChanged<String>? onChanged;
  
  /// 最小值
  final num? min;
  
  /// 最大值
  final num? max;

  const CardNumberField({
    Key? key,
    required this.title,
    this.value,
    this.unit,
    this.hint,
    this.required = false,
    this.onChanged,
    this.min,
    this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardInputField(
      title: title,
      hint: hint,
      value: value,
      required: required,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      suffixIcon: unit != null
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              unit!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF86909C),
              ),
            ),
          )
        : null,
    );
  }
}

/// 使用示例
class ExampleFormPage extends StatefulWidget {
  const ExampleFormPage({Key? key}) : super(key: key);

  @override
  State<ExampleFormPage> createState() => _ExampleFormPageState();
}

class _ExampleFormPageState extends State<ExampleFormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  String? _selectedCustomer;
  bool _autoNotify = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: TDNavBar(
        title: '客户信息',
        useDefaultBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 选择器类型
            CardSelectField(
              title: '客户',
              displayValue: _selectedCustomer,
              required: true,
              onTap: () => _showCustomerPicker(),
            ),
            
            // 文本输入
            CardInputField(
              title: '客户名称',
              controller: _nameController,
              required: true,
              onChanged: (v) => setState(() {}),
            ),
            
            // 电话输入
            CardInputField(
              title: '联系电话',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              required: true,
            ),
            
            // 地址输入（多行）
            CardInputField(
              title: '地址',
              controller: _addressController,
              maxLines: 2,
            ),
            
            // 日期选择
            CardDateField(
              title: '生日',
              displayValue: _selectedDate != null 
                ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                : null,
              onTap: () => _showDatePicker(),
            ),
            
            // 开关
            CardSwitchField(
              title: '自动通知',
              value: _autoNotify,
              description: '订单变动时自动发送短信通知',
              onChanged: (v) => setState(() => _autoNotify = v),
            ),
            
            // 数字输入（带单位）
            CardNumberField(
              title: '信用额度',
              value: '10000',
              unit: '元',
            ),
            
            const SizedBox(height: 32),
            
            // 提交按钮
            TDButton(
              text: '保存',
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              onTap: () => _submit(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerPicker() {
    // TODO: 实现客户选择器
  }

  void _showDatePicker() {
    // TODO: 实现日期选择
  }

  void _submit() {
    // TODO: 保存表单
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}