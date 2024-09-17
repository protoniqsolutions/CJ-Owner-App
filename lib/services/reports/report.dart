import 'dart:convert';
import 'package:cjowner/models/daily_report_data.dart';
import 'package:cjowner/models/monthly_report_data.dart';
import 'package:cjowner/models/reportSalesRep.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;


class Report {
  static const String _baseUrl = 'http://147.79.66.105/api/reports';

  // Fetch the daily sales report with authentication headers
  Future<DailyReportData> fetchDailySalesReport() async {
    // Retrieve the token from AuthService
    final String? token = await AuthService.getToken();

    // Create headers with Authorization if the token is available
    final headers = token != null
        ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }
        : {
            'Content-Type': 'application/json',
          };

    // Make the HTTP GET request
    final response = await http.get(
      Uri.parse('$_baseUrl/getDailySales'),
      headers: headers, // Include the headers in the request
    );

    // Check if the response was successful
    if (response.statusCode == 200) {
      // Parse the response body and return the DailyReportData
      return DailyReportData.fromJson(json.decode(response.body));
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to load daily sales report');
    }
  }



  Future<MonthlyReportData> fetchMonthlyReport() async {
    final String? token = await AuthService.getToken(); // Assuming this method exists

    final headers = token != null
        ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }
        : {
            'Content-Type': 'application/json',
          };

    final response = await http.get(
      Uri.parse('http://147.79.66.105/api/reports/getMonthlyReport'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return MonthlyReportData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load monthly report');
    }
  }



  Future<List<ReportSalesRep>> fetchSalesReps() async {
  final String? token = await AuthService.getToken(); // Fetch the token from AuthService

  final response = await http.get(
    Uri.parse('http://147.79.66.105/api/reports/getSalesDataForSalesReps'),
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['success']) {
      return (data['salesData'] as List)
          .map((item) => ReportSalesRep.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load sales reps data');
    }
  } else {
    throw Exception('Failed to load sales reps data');
  }
}
}
