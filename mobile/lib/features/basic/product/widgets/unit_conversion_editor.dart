import 'package:aierp_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:aierp_mobile/models/unit_conversion.dart';

/// 多单位配置编辑器 - 卡片式布局
class UnitConversionEditor extends StatefulWidget {
  final List<UnitConversion> conversions;
  final String baseUnit; // 基础单位，从基础信息 Tab 传入
  final ValueChanged<List<UnitConversion>> onConversionsChanged;

  const UnitConversionEditor({
    super.key,
    required this.conversions,
    this.baseUnit = '',
    required this.onConversionsChanged,
  });

  @override
  State<UnitConversionEditor> createState() => _UnitConversionEditorState();
}

class _UnitConversionEditorState extends State<UnitConversionEditor> {
  late List<UnitConversion> _conversions;

  @override
  void initState() {
    super.initState();
    _conversions = List.from(widget.conversions);
  }

  @override
  void didUpdateWidget(UnitConversionEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当基础单位变化时，更新现有换算的基础单位
    if (oldWidget.baseUnit != widget.baseUnit && widget.baseUnit.isNotEmpty) {
      for (int i = 0; i < _conversions.length; i++) {
        if (_conversions[i].baseUnit.isEmpty || _conversions[i].baseUnit == oldWidget.baseUnit) {
          _conversions[i] = _conversions[i].copyWith(baseUnit: widget.baseUnit);
        }
      }
      _notifyChanges();
    }
  }

  /// 显示添加/编辑换算弹窗
  void _showAddDialog(int? editIndex) {
    if (widget.baseUnit.isEmpty) {
      TDToast.showText('请先在基础信息中设置基础单位', context: context);
      return;
    }
    
    final targetUnitController = TextEditingController(
      text: editIndex != null ? _conversions[editIndex].targetUnit : '',
    );
    final rateController = TextEditingController(
      text: editIndex != null ? _conversions[editIndex].conversionRate.toString() : '1',
    );
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(editIndex != null ? '编辑单位换算' : '添加单位换算'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 基础单位提示
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.brandColor1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.brandColor8, size: 18),
                      const SizedBox(width: 8),
                      Text('基础单位：${widget.baseUnit}', style: TextStyle(color: AppTheme.brandColor8)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 换算单位输入
                TextField(
                  controller: targetUnitController,
                  decoration: const InputDecoration(
                    labelText: '换算单位',
                    hintText: '如：箱、包、打',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                
                const SizedBox(height: 12),
                
                // 换算比率输入
                TextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '换算比率',
                    hintText: '输入数量',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                
                const SizedBox(height: 12),
                
                // 预览卡片
                if (targetUnitController.text.isNotEmpty && rateController.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.brandColor1,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('1${targetUnitController.text}', style: TextStyle(color: AppTheme.brandColor8)),
                        ),
                        const SizedBox(width: 12),
                        const Text('=', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF2F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('${rateController.text}${widget.baseUnit}', style: const TextStyle(color: Color(0xFFFF4D4F))),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 8),
                
                Text(
                  '示例：1箱 = 24个，表示一箱包含24个基础单位',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                final targetUnit = targetUnitController.text.trim();
                final rate = double.tryParse(rateController.text) ?? 1.0;
                
                if (targetUnit.isEmpty) {
                  TDToast.showText('请输入换算单位', context: ctx);
                  return;
                }
                
                if (rate <= 0) {
                  TDToast.showText('换算比率必须大于0', context: ctx);
                  return;
                }
                
                if (editIndex != null) {
                  _updateConversion(editIndex, targetUnit, rate);
                } else {
                  _addConversion(targetUnit, rate);
                }
                
                Navigator.pop(ctx);
              },
              child: Text(editIndex != null ? '保存' : '确定'),
            ),
          ],
        ),
      ),
    );
  }

  void _addConversion(String targetUnit, double rate) {
    setState(() {
      _conversions.add(UnitConversion(
        baseUnit: widget.baseUnit,
        targetUnit: targetUnit,
        conversionRate: rate,
      ));
    });
    _notifyChanges();
  }

  void _updateConversion(int index, String targetUnit, double rate) {
    setState(() {
      _conversions[index] = UnitConversion(
        baseUnit: widget.baseUnit,
        targetUnit: targetUnit,
        conversionRate: rate,
      );
    });
    _notifyChanges();
  }

  void _removeConversion(int index) {
    setState(() {
      _conversions.removeAt(index);
    });
    _notifyChanges();
  }

  void _notifyChanges() {
    widget.onConversionsChanged(_conversions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 添加按钮
        ElevatedButton.icon(
          onPressed: () => _showAddDialog(null),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('添加单位换算'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.brandColor8,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        
        const SizedBox(height: 12),
        
        if (_conversions.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgPage,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.baseUnit.isEmpty 
                  ? '请在基础信息中设置基础单位' 
                  : '暂无单位换算',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          // 换算列表 - 卡片式布局
          ..._conversions.asMap().entries.map((entry) {
            final index = entry.key;
            final conversion = entry.value;
            
            return _buildConversionCard(context, index, conversion);
          }),
      ],
    );
  }

  /// 单位换算卡片 - 参考图片样式
  Widget _buildConversionCard(BuildContext context, int index, UnitConversion conversion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.bgPage,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.swap_horiz, color: AppTheme.brandColor8, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    conversion.targetUnit,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                // 编辑按钮
                GestureDetector(
                  onTap: () => _showAddDialog(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.brandColor1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('编辑', style: TextStyle(color: AppTheme.brandColor8, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                // 删除按钮
                GestureDetector(
                  onTap: () => _removeConversion(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('删除', style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          
          // 换算关系展示
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 换算单位
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.brandColor1,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.brandColor6),
                  ),
                  child: Text(
                    '1 ${conversion.targetUnit}',
                    style: TextStyle(
                      color: AppTheme.brandColor8,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // 等号
                const Text('=', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                
                const SizedBox(width: 16),
                
                // 基础单位数量
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2F0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF4D4F)),
                  ),
                  child: Text(
                    '${conversion.conversionRate} ${conversion.baseUnit}',
                    style: const TextStyle(
                      color: Color(0xFFFF4D4F),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}