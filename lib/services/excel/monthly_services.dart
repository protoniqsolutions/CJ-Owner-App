import 'dart:convert';
import 'dart:io';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelGeneratormonthly {
  final String? token; // Token passed to the constructor

  ExcelGeneratormonthly({this.token});

  // Fetch monthly report data from the API with optional authorization
  Future<List<dynamic>> fetchMonthlyReport() async {
    final String? token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('http://147.79.66.105/api/excel/getAllMonthlyReport'),
      headers: token != null ? {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      } : {},
    );

    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load monthly reports');
    }
  }

  // Generate Excel file for monthly reports
  Future<void> generateExcel(List<dynamic> reports) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Monthly Reports'];

    // Add header row
    sheet.appendRow([
      "Month",
      "Year",
      "Total Margin",
      "Total Sales Amount",
      "Pie Chart Data",
      "Report Generated Date",
      "Report Generated Time"
    ]);

    // Add report data
    for (var report in reports) {
      String pieChartData = (report['pieChartData'] as List)
          .map((item) => "${item['itemName']} (${item['percentage']}%)")
          .join(', ');

      sheet.appendRow([
        report['month'],
        report['year'].toString(),
        report['totalMargin'].toString(),
        report['totalSalesAmount'].toString(),
        pieChartData,
        report['reportGeneratedDate'],
        report['reportGeneratedTime']
      ]);
    }

    // Get the document directory to save the file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/monthly_reports.xlsx";

    // Save the file
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);
    
    print('Excel file saved at: $filePath');

    // Share the file
    await Share.shareFiles([filePath], text: 'Here are the monthly reports.');
  }

  // Main function to fetch data and generate Excel for monthly reports
  Future<void> fetchAndGenerateExcel() async {
    try {
      List<dynamic> reports = await fetchMonthlyReport();
      await generateExcel(reports);
    } catch (e) {
      print('Error: $e');
    }
  }
}
