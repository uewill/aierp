import 'package:flutter/material.dart';
import '../../theme/arco_theme.dart';

/// Arco Design 按钮类型
enum ArcoButtonType {
  primary,
  secondary,
  danger,
  text,
}

/// Arco Design 按钮尺寸
enum ArcoButtonSize {
  small,
  medium,
  large,
}

/// Arco Design 按钮组件
class ArcoButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ArcoButtonType type;
  final ArcoButtonSize size;
  final bool loading;
  final bool disabled;
  final Widget? icon;

  const ArcoButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.type = ArcoButtonType.primary,
    this.size = ArcoButtonSize.medium,
    this.loading = false,
    this.disabled = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || loading;
    
    return SizedBox(
      height: _getHeight(),
      child: type == ArcoButtonType.text
          ? TextButton(
              onPressed: isDisabled ? null : onPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: _getHorizontalPadding(),
                ),
              ),
              child: _buildChild(),
            )
          : type == ArcoButtonType.secondary
              ? OutlinedButton(
                  onPressed: isDisabled ? null : onPressed,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: type == ArcoButtonType.danger
                          ? ArcoColors.danger
                          : ArcoColors.primary,
                    ),
                    foregroundColor: type == ArcoButtonType.danger
                        ? ArcoColors.danger
                        : ArcoColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: _getHorizontalPadding(),
                    ),
                  ),
                  child: _buildChild(),
                )
              : ElevatedButton(
                  onPressed: isDisabled ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getBackgroundColor(),
                    foregroundColor: _getForegroundColor(),
                    padding: EdgeInsets.symmetric(
                      horizontal: _getHorizontalPadding(),
                    ),
                  ),
                  child: _buildChild(),
                ),
    );
  }

  Widget _buildChild() {
    if (loading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ArcoButtonType.text || type == ArcoButtonType.secondary
                ? (type == ArcoButtonType.danger
                    ? ArcoColors.danger
                    : ArcoColors.primary)
                : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: ArcoSpacing.s),
          Text(
            label,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Text(
      label,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case ArcoButtonSize.small:
        return 28;
      case ArcoButtonSize.medium:
        return 32;
      case ArcoButtonSize.large:
        return 40;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ArcoButtonSize.small:
        return 12;
      case ArcoButtonSize.medium:
      case ArcoButtonSize.large:
        return 14;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ArcoButtonSize.small:
        return 12;
      case ArcoButtonSize.medium:
        return 16;
      case ArcoButtonSize.large:
        return 20;
    }
  }

  Color _getBackgroundColor() {
    if (disabled) {
      return ArcoColors.border;
    }
    switch (type) {
      case ArcoButtonType.primary:
        return ArcoColors.primary;
      case ArcoButtonType.danger:
        return ArcoColors.danger;
      case ArcoButtonType.secondary:
      case ArcoButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    if (disabled) {
      return ArcoColors.textPlaceholder;
    }
    switch (type) {
      case ArcoButtonType.primary:
      case ArcoButtonType.danger:
        return Colors.white;
      case ArcoButtonType.secondary:
      case ArcoButtonType.text:
        return type == ArcoButtonType.danger
            ? ArcoColors.danger
            : ArcoColors.primary;
    }
  }
}
