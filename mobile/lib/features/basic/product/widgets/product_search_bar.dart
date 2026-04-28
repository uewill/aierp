import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final VoidCallback? onFilterPressed;

  const ProductSearchBar({
    super.key,
    required this.controller,
    this.onSearch,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 搜索输入框
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '搜索商品名称、编码或条码',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onSubmitted: (_) => onSearch?.call(),
        ),
        const SizedBox(height: 16),
        // 搜索和筛选按钮
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('搜索'),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: onFilterPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('筛选'),
            ),
          ],
        ),
      ],
    );
  }
}