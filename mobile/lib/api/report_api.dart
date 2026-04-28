/// 报表统计 API
import 'api_client.dart';

/// 报表 API 服务
class ReportApi {
  final ApiClient _client = ApiClient();
  
  /// 获取今日统计
  Future<TodayStatistics> getTodayStatistics() async {
    final response = await _client.get('/api/report/today');
    
    if (response.isSuccess && response.data != null) {
      return TodayStatistics.fromJson(response.data as Map<String, dynamic>);
    }
    return TodayStatistics.empty();
  }
  
  /// 获取本月统计
  Future<MonthStatistics> getMonthStatistics() async {
    final response = await _client.get('/api/report/month');
    
    if (response.isSuccess && response.data != null) {
      return MonthStatistics.fromJson(response.data as Map<String, dynamic>);
    }
    return MonthStatistics.empty();
  }
  
  /// 获取商品销售排行 TOP10
  Future<List<SalesRankItem>> getSalesRankTop10() async {
    final response = await _client.get('/api/report/sales/rank', queryParameters: {
      'limit': 10,
    });
    
    if (response.isSuccess && response.data != null) {
      final data = response.data as List?;
      return data?.map((e) => SalesRankItem.fromJson(e)).toList() ?? [];
    }
    return [];
  }
  
  /// 获取综合统计数据（首页/报表共用）
  Future<ReportStatistics> getStatistics() async {
    final response = await _client.get('/api/report/statistics');
    
    if (response.isSuccess && response.data != null) {
      return ReportStatistics.fromJson(response.data as Map<String, dynamic>);
    }
    return ReportStatistics.empty();
  }
}

/// 今日统计数据
class TodayStatistics {
  final double salesAmount;
  final double purchaseAmount;
  final int salesCount;
  final int purchaseCount;
  
  TodayStatistics({
    this.salesAmount = 0,
    this.purchaseAmount = 0,
    this.salesCount = 0,
    this.purchaseCount = 0,
  });
  
  factory TodayStatistics.fromJson(Map<String, dynamic> json) {
    return TodayStatistics(
      salesAmount: (json['salesAmount'] as num?)?.toDouble() ?? 0,
      purchaseAmount: (json['purchaseAmount'] as num?)?.toDouble() ?? 0,
      salesCount: json['salesCount'] as int? ?? 0,
      purchaseCount: json['purchaseCount'] as int? ?? 0,
    );
  }
  
  factory TodayStatistics.empty() => TodayStatistics();
}

/// 本月统计数据
class MonthStatistics {
  final double salesAmount;
  final double purchaseAmount;
  final int salesCount;
  final int purchaseCount;
  
  MonthStatistics({
    this.salesAmount = 0,
    this.purchaseAmount = 0,
    this.salesCount = 0,
    this.purchaseCount = 0,
  });
  
  factory MonthStatistics.fromJson(Map<String, dynamic> json) {
    return MonthStatistics(
      salesAmount: (json['salesAmount'] as num?)?.toDouble() ?? 0,
      purchaseAmount: (json['purchaseAmount'] as num?)?.toDouble() ?? 0,
      salesCount: json['salesCount'] as int? ?? 0,
      purchaseCount: json['purchaseCount'] as int? ?? 0,
    );
  }
  
  factory MonthStatistics.empty() => MonthStatistics();
}

/// 综合统计数据（兼容 Statistics model）
class ReportStatistics {
  final double todaySales;
  final double todayPurchase;
  final int todaySalesCount;
  final int todayPurchaseCount;
  final double monthSales;
  final double monthPurchase;
  final int pendingBills;
  final int lowStockCount;
  final double totalInventoryValue;
  
  ReportStatistics({
    this.todaySales = 0,
    this.todayPurchase = 0,
    this.todaySalesCount = 0,
    this.todayPurchaseCount = 0,
    this.monthSales = 0,
    this.monthPurchase = 0,
    this.pendingBills = 0,
    this.lowStockCount = 0,
    this.totalInventoryValue = 0,
  });
  
  factory ReportStatistics.fromJson(Map<String, dynamic> json) {
    return ReportStatistics(
      todaySales: (json['todaySales'] as num?)?.toDouble() ?? 0,
      todayPurchase: (json['todayPurchase'] as num?)?.toDouble() ?? 0,
      todaySalesCount: json['todaySalesCount'] as int? ?? 0,
      todayPurchaseCount: json['todayPurchaseCount'] as int? ?? 0,
      monthSales: (json['monthSales'] as num?)?.toDouble() ?? 0,
      monthPurchase: (json['monthPurchase'] as num?)?.toDouble() ?? 0,
      pendingBills: json['pendingBills'] as int? ?? 0,
      lowStockCount: json['lowStockCount'] as int? ?? 0,
      totalInventoryValue: (json['totalInventoryValue'] as num?)?.toDouble() ?? 0,
    );
  }
  
  factory ReportStatistics.empty() => ReportStatistics();
}

/// 商品销售排行项
class SalesRankItem {
  final int productId;
  final String productName;
  final double salesAmount;
  final double salesQuantity;
  final int rank;
  
  SalesRankItem({
    required this.productId,
    required this.productName,
    this.salesAmount = 0,
    this.salesQuantity = 0,
    this.rank = 0,
  });
  
  factory SalesRankItem.fromJson(Map<String, dynamic> json) {
    return SalesRankItem(
      productId: json['productId'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      salesAmount: (json['salesAmount'] as num?)?.toDouble() ?? 0,
      salesQuantity: (json['salesQuantity'] as num?)?.toDouble() ?? 0,
      rank: json['rank'] as int? ?? 0,
    );
  }
}