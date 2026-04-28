import 'package:flutter/material.dart';
import '../../theme/arco_theme.dart';

/// Arco Design Cell - 单元格输入项（Picker样式）
/// 白色背景，左右布局，右侧箭头，底部边框分隔
class ArcoCell extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool showArrow;
  final bool showDivider;
  final bool enabled;

  const ArcoCell({
    super.key,
    required this.label,
    this.value,
    this.placeholder = '请选择',
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.showArrow = true,
    this.showDivider = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(
              horizontal: ArcoSpacing.m,
            ),
            decoration: BoxDecoration(
              color: enabled ? Colors.white : ArcoColors.fill2,
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon!,
                  SizedBox(width: ArcoSpacing.s),
                ],
                Text(
                  label,
                  style: ArcoTypography.body2.copyWith(
                    color: ArcoColors.textPrimary,
                  ),
                ),
                SizedBox(width: ArcoSpacing.s),
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: ArcoTypography.body2.copyWith(
                      color: value == null ? ArcoColors.textSecondary : ArcoColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: ArcoSpacing.xs),
                if (suffixIcon != null)
                  suffixIcon!
                else if (showArrow && enabled)
                  Icon(
                    Icons.chevron_right,
                    color: ArcoColors.textPlaceholder,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 0,
            thickness: 1,
            color: ArcoColors.border,
          ),
      ],
    );
  }
}

/// Arco Design Cell Group - 单元格组
/// 圆角卡片包裹的多个 Cell
class ArcoCellGroup extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const ArcoCellGroup({
    super.key,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

/// Arco Design Cell Input - 可编辑的单元格输入
class ArcoCellInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final bool showDivider;
  final ValueChanged<String>? onChanged;

  const ArcoCellInput({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.prefixIcon,
    this.showDivider = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(
            horizontal: ArcoSpacing.m,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                SizedBox(width: ArcoSpacing.s),
              ],
              Text(
                label,
                style: ArcoTypography.body2,
              ),
              SizedBox(width: ArcoSpacing.m),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: ArcoTypography.body2,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: ArcoTypography.body2.copyWith(
                      color: ArcoColors.textPlaceholder,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 0,
            thickness: 1,
            color: ArcoColors.border,
          ),
      ],
    );
  }
}
