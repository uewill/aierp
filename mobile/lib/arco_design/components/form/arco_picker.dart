import 'package:flutter/material.dart';
import '../../theme/arco_theme.dart';

/// Arco Design Picker - 底部弹窗选择器
class ArcoPicker<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? value;
  final String Function(T) itemLabel;
  final String? placeholder;
  final ValueChanged<T?> onSelected;
  final Widget? prefixIcon;
  final bool enabled;

  const ArcoPicker({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.value,
    this.placeholder = '请选择',
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.where((item) => item == value).firstOrNull;
    
    return GestureDetector(
      onTap: enabled ? () => _showPicker(context) : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ArcoSpacing.m,
          vertical: ArcoSpacing.s,
        ),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : ArcoColors.fill2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? ArcoColors.border : ArcoColors.fill3,
          ),
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: ArcoSpacing.xs),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: ArcoColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              selectedItem != null ? itemLabel(selectedItem) : placeholder!,
              style: TextStyle(
                fontSize: 14,
                color: selectedItem != null 
                    ? ArcoColors.primary 
                    : ArcoColors.textPlaceholder,
              ),
            ),
            SizedBox(width: ArcoSpacing.xs),
            Icon(
              Icons.chevron_right,
              color: enabled ? ArcoColors.textTertiary : ArcoColors.textPlaceholder,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: EdgeInsets.all(ArcoSpacing.m),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: ArcoColors.border)),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: ArcoTypography.title2,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: EdgeInsets.all(ArcoSpacing.xs),
                      decoration: BoxDecoration(
                        color: ArcoColors.fill2,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.close, size: 18, color: ArcoColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            
            // 列表
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == value;
                  
                  return GestureDetector(
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ArcoSpacing.m,
                        vertical: ArcoSpacing.s,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? ArcoColors.primaryLight : Colors.white,
                        border: Border(
                          bottom: BorderSide(color: ArcoColors.border, width: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              itemLabel(item),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? ArcoColors.primary : ArcoColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check, color: ArcoColors.primary, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
