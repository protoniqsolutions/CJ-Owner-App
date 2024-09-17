import 'dart:convert';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class UpdatePricingItemService {
  static const String _baseUrl = 'http://147.79.66.105/api/stock/updatePricingItemByName';

  Future<bool> updatePricingItem({
    required String itemName,
    required String discount,
    required String price,
    required String margin,
  }) async {
    final String? token = await AuthService.getToken();
    try {
      final response = await http.put(
        Uri.parse(_baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'itemName': itemName,
          'discount': discount,
          'price': price,
          'margin': margin,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Update successful
      } else {
        print('Failed to update item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating pricing item: $e');
      return false;
    }
  }
}
