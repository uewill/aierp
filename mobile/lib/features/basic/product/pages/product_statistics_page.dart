import 'package:flutter/material.dart';
import 'package:aierp_mobile/core/theme/app_theme.dart';

/// 商品统计页面
class ProductStatisticsPage extends StatefulWidget {
  const ProductStatisticsPage({super.key});

  @override
  State<ProductStatisticsPage> createState() => _ProductStatisticsPageState();
}

class _ProductStatisticsPageState extends State<ProductStatisticsPage> {
  final List<Map<String, dynamic>> _salesData = [
    {'month': '1月', 'sales': 1200},
    {'month': '2月', 'sales': 1500},
    {'month': '3月', 'sales': 1800},
    {'month': '4月', 'sales': 2100},
    {'month': '5月', 'sales': 1900},
    {'month': '6月', 'sales': 2300},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品统计'),
        backgroundColor: AppTheme.brandColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 统计概览卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('商品总数', '156'),
                      _buildStatItem('今日销量', '45'),
                      _buildStatItem('库存预警', '3'),
                      _buildStatItem('热销商品', '12'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 销售趋势图表（模拟）
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('销售趋势', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      // 简单的柱状图模拟
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _salesData.length,
                          itemBuilder: (context, index) {
                            final data = _salesData[index];
                            final maxHeight = 200.0;
                            final barHeight = (data['sales'] as int) / 2300 * maxHeight;
                            
                            return Container(
                              width: 40,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Container(
                                    height: maxHeight - barHeight,
                                    color: Colors.transparent,
                                  ),
                                  Container(
                                    height: barHeight,
                                    color: AppTheme.brandColor,
                                    child: Center(
                                      child: Text(
                                        '${data['sales']}',
                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(data['month'] as String),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 分类销售排行
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('分类销售排行', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      ...List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Text('${index + 1}.', style: const TextStyle(color: Colors.grey)),
                              const SizedBox(width: 8),
                              Text(['饮料', '方便食品', '零食'][index]),
                              const Spacer(),
                              Text(['¥2,340', '¥1,890', '¥1,560'][index]),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}