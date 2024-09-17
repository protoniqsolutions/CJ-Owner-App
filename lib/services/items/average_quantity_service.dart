// lib/services/average_quantity_service.dart

import 'dart:convert';
import 'package:cjowner/models/average_quantity_model.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class AverageQuantityService {
  final String _url = 'http://147.79.66.105/api/stock/average-quantity';

  Future<AverageQuantityResponse?> fetchAverageQuantity() async {
    final String? token = await AuthService.getToken();

    // Set up the headers with Authorization if the token is not null
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: headers,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AverageQuantityResponse.fromJson(jsonData);
      } else {
        // Handle error
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
