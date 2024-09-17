// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cjowner/services/auth/auth_service.dart'; // Import AuthService

class HomeService {
  static const String baseUrl = 'http://147.79.66.105/api/reports/getTotalSalesAndMargin';

  static Future<Map<String, dynamic>> fetchTotalSalesAndMargin() async {
    final String? token = await AuthService.getToken();
    
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
