import 'package:flutter/material.dart';

/// 商品单位选择组件
class UnitSelector extends StatefulWidget {
  final String? selectedUnit;
  final ValueChanged<String?>? onUnitSelected;
  
  const UnitSelector({
    super.key,
    this.selectedUnit,
    this.onUnitSelected,
  });

  @override
  State<UnitSelector> createState() => _UnitSelectorState();
}

class _UnitSelectorState extends State<UnitSelector> {
  String? _selectedUnit;
  
  // 常用单位列表
  final List<String> _units = [
    '个', '件', '包', '盒', '箱', '瓶', '袋', '台', '套', '张', '本', '支', '条', '根', '米', '千克', '克', '升', '毫升'
  ];

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.selectedUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('商品单位 *', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedUnit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '请选择商品单位',
          ),
          items: _units.map((unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedUnit = value;
            });
            widget.onUnitSelected?.call(value);
          },
        ),
      ],
    );
  }
}