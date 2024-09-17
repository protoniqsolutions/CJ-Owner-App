import 'dart:convert';
import 'package:cjowner/models/stockitemmodel.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class StockPricingService {
  final String baseUrl = 'http://147.79.66.105/api/stock';

  // Method to fetch all stock items
  Future<List<StockItemmodel>> fetchStockItems() async {
    // Get the token from the AuthService
    final String? token = await AuthService.getToken();

    // Set up the headers with Authorization if token is not null
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Add any other necessary headers
    };

    // Make the API request with the headers
    final response = await http.get(
      Uri.parse('$baseUrl/getAllStockItems'),
      headers: headers,
    );
    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => StockItemmodel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load stock items');
    }
  }

  Future<bool> updatePricingItem({
    required String itemName,
    required String discount,
    required String price,
    required String margin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("http://147.79.66.105/api/stock/updatePricingItemByName"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'itemName': itemName,
          'discount': discount,
          'price': price,
          'margin': margin,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating item: $e');
      return false;
    }
  }
}
