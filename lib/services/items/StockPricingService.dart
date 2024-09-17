// lib/services/items/update_pricing_item_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdatePricingItemService {
  final String _updateUrl = "http://147.79.66.105/api/stock/updatePricingItemByName";

  Future<bool> updatePricingItem({
    required String itemName,
    required String discount,
    required String price,
    required String margin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_updateUrl),
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
