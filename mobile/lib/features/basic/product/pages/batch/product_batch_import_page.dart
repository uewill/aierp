import 'package:flutter/material.dart';

/// 商品批量导入页面
class ProductBatchImportPage extends StatefulWidget {
  const ProductBatchImportPage({super.key});

  @override
  State<ProductBatchImportPage> createState() => _ProductBatchImportPageState();
}

class _ProductBatchImportPageState extends State<ProductBatchImportPage> {
  final List<String> _templateColumns = [
    '商品名称',
    '商品编码',
    '规格',
    '单位',
    '采购价',
    '销售价',
    '条码',
    '分类',
    '品牌',
    '描述'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('批量导入商品'),
        backgroundColor: const Color(0xFF0052D9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '批量导入说明',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                '1. 下载模板文件，按照模板格式填写商品信息\n'
                '2. 确保必填字段不为空\n'
                '3. 分类必须是系统中存在的分类名称\n'
                '4. 上传Excel文件完成批量导入',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              // 模板下载按钮
              ElevatedButton(
                onPressed: _downloadTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('下载导入模板', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
              
              // 模板列说明
              const Text(
                '模板列说明:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._templateColumns.map((column) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(column),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              
              // 文件上传区域
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.file_upload, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('点击或拖拽文件到此区域'),
                    const SizedBox(height: 8),
                    Text(
                      '支持 .xlsx, .xls 格式',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _uploadFile,
                      child: const Text('选择文件'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // 导入按钮
              ElevatedButton(
                onPressed: _importProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('开始导入', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadTemplate() {
    // TODO: 实现模板下载逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('模板下载功能待实现')),
    );
  }

  void _uploadFile() {
    // TODO: 实现文件上传逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('文件上传功能待实现')),
    );
  }

  void _importProducts() {
    // TODO: 实现批量导入逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('批量导入功能待实现')),
    );
  }
}