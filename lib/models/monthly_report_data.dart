class MonthlyReportData {
  final String id;
  final int year;
  final String month;
  final List<PieChartData> pieChartData;
  final String reportGeneratedDate;
  final String reportGeneratedTime;
  final double totalMargin;
  final double totalSalesAmount;

  MonthlyReportData({
    required this.id,
    required this.year,
    required this.month,
    required this.pieChartData,
    required this.reportGeneratedDate,
    required this.reportGeneratedTime,
    required this.totalMargin,
    required this.totalSalesAmount,
  });

  factory MonthlyReportData.fromJson(Map<String, dynamic> json) {
    return MonthlyReportData(
      id: json['_id'],
      year: json['year'],
      month: json['month'],
      pieChartData: List<PieChartData>.from(
        json['pieChartData'].map((data) => PieChartData.fromJson(data)),
      ),
      reportGeneratedDate: json['reportGeneratedDate'],
      reportGeneratedTime: json['reportGeneratedTime'],
      totalMargin: json['totalMargin'].toDouble(),
      totalSalesAmount: json['totalSalesAmount'].toDouble(),
    );
  }
}

class PieChartData {
  final String itemName;
  final double percentage;
  final String id;

  PieChartData({
    required this.itemName,
    required this.percentage,
    required this.id,
  });

  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      itemName: json['itemName'],
      percentage: json['percentage'].toDouble(),
      id: json['_id'],
    );
  }
}
