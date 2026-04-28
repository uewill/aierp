import 'package:flutter/material.dart';
import '../../theme/arco_theme.dart';

/// Arco Design InputItem - 左右结构表单输入项
/// 
/// 布局：左侧标签 + 右侧输入框
/// 支持图标、清除按钮、验证提示等
class ArcoInputItem extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showClear;
  final String? errorText;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final double labelWidth;
  final EdgeInsetsGeometry? contentPadding;

  const ArcoInputItem({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.showClear = false,
    this.errorText,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.labelStyle,
    this.inputStyle,
    this.labelWidth = 80,
    this.contentPadding,
  });

  @override
  State<ArcoInputItem> createState() => _ArcoInputItemState();
}

class _ArcoInputItemState extends State<ArcoInputItem> {
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _updateClearButtonVisibility();
    _controller.addListener(_updateClearButtonVisibility);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    if (widget.showClear && !widget.readOnly) {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty;
      });
    }
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasError
              ? ArcoColors.danger
              : _controller.text.isNotEmpty
                  ? ArcoColors.primary
                  : ArcoColors.border,
          width: hasError ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // 左侧标签
          SizedBox(
            width: widget.labelWidth,
            child: Padding(
              padding: EdgeInsets.only(left: ArcoSpacing.m),
              child: Text(
                widget.label,
                style: widget.labelStyle ??
                    TextStyle(
                      fontSize: 14,
                      color: ArcoColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),

          // 右侧输入区域
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              style: widget.inputStyle ??
                  TextStyle(
                    fontSize: 14,
                    color: hasError ? ArcoColors.danger : ArcoColors.textPrimary,
                  ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: ArcoColors.textPlaceholder,
                ),
                border: InputBorder.none,
                contentPadding: widget.contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: ArcoSpacing.m,
                      vertical: ArcoSpacing.s,
                    ),
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: EdgeInsets.only(right: ArcoSpacing.xs),
                        child: widget.prefixIcon,
                      )
                    : null,
                suffixIcon: _buildSuffixIcon(),
              ),
              onChanged: widget.onChanged,
              onTap: widget.onTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    // 错误提示优先显示
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      return Icon(Icons.error_outline, color: ArcoColors.danger, size: 18);
    }

    // 清除按钮
    if (_showClearButton) {
      return GestureDetector(
        onTap: _clearText,
        child: Icon(Icons.close, color: ArcoColors.textTertiary, size: 18),
      );
    }

    // 自定义后缀图标
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    return null;
  }
}

/// Arco Design TextArea - 多行文本输入
class ArcoTextArea extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final int maxLines;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const ArcoTextArea({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.maxLines = 3,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: ArcoSpacing.xs, bottom: ArcoSpacing.xs),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: ArcoColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError
                  ? ArcoColors.danger
                  : ArcoColors.border,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 14,
              color: hasError ? ArcoColors.danger : ArcoColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14,
                color: ArcoColors.textPlaceholder,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(ArcoSpacing.m),
            ),
            onChanged: onChanged,
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(left: ArcoSpacing.xs, top: ArcoSpacing.xs),
            child: Text(
              errorText!,
              style: TextStyle(
                fontSize: 12,
                color: ArcoColors.danger,
              ),
            ),
          ),
      ],
    );
  }
}
