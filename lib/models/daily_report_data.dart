// models/daily_report_data.dart

class DailyReportData {
  final double totalSalesAmount;
  final double totalMargin;
  final List<PieChartData> pieChartData;

  DailyReportData({
    required this.totalSalesAmount,
    required this.totalMargin,
    required this.pieChartData,
  });

  factory DailyReportData.fromJson(Map<String, dynamic> json) {
    return DailyReportData(
      totalSalesAmount: (json['totalSalesAmount'] ?? 0.0).toDouble(),
      totalMargin: (json['totalMargin'] ?? 0.0).toDouble(),
      pieChartData: (json['pieChartData'] as List<dynamic>?)
              ?.map((data) => PieChartData.fromJson(data))
              .toList() ??
          [],
    );
  }
}

class PieChartData {
  final String itemName;
  final double percentage;

  PieChartData({
    required this.itemName,
    required this.percentage,
  });

  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      itemName: json['itemName'] ?? 'Unknown Item',
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }
}
