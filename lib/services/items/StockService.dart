import 'dart:convert';
import 'package:cjowner/config/config.dart';
import 'package:cjowner/models/AddStockRequest.dart';
import 'package:cjowner/models/StockInfo.dart';
import 'package:cjowner/models/viewstock_model.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class StockService {
  final String apiUrl = '${Config.baseurl}/stock/addStock';

  Future<void> addStock(AddStockRequest request) async {
    final String? token = await AuthService.getToken();
    print(request);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        print('Stock added successfully');
      } else {
        print('Failed to add stock: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<StockInfo>> fetchStockData() async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    // Make the HTTP GET request
    final response = await http.get(
      Uri.parse('http://147.79.66.105/api/stock/verifyItems'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> stockDataList = data['data'];

      return stockDataList
          .map((stockItem) => StockInfo.fromJson(stockItem))
          .toList();
    } else {
      throw Exception('Failed to load stock data');
    }
  }


  static Future<bool> updateVerifyItems(String id, List<Map<String, dynamic>> itemsUpdates) async {
    final url = 'http://147.79.66.105/api/stock/updateVerifyItems';
    final String? token = await AuthService.getToken();

    // print("-----------------------------------------------------");
    // print(id);
    // print(itemsUpdates);

    final body = jsonEncode({
      "id": id,
      "itemsUpdates": itemsUpdates,
    });

    print(body);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Items updated successfully');
        return true;
      } else {
        print('Failed to update items: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error updating items: $error');
      return false;
    }
  }



  /// Function to register items
  static Future<http.Response> registerItems({
    required String itemName,
    required String companyName,
    required String companyAddress,
  }) async {
    final String? token = await AuthService.getToken();
    final url = Uri.parse('${Config.baseurl}/stock/registerItems');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'itemName': itemName,
      'companyName': companyName,
      'companyAddress': companyAddress,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        print('Item registered successfully: ${response.body}');
      } else {
        // Handle error
        print('Failed to register item: ${response.statusCode}');
      }
      
      return response;
    } catch (e) {
      // Handle exception
      throw Exception('Failed to register item: $e');
    }
  }


  Future<List<ViewStock>> getAllStockItems() async {
  final String? token = await AuthService.getToken();

  final response = await http.get(
    Uri.parse('http://147.79.66.105/api/stock/getAllStockItems'),
    headers: token != null
        ? {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
        : {
            'Content-Type': 'application/json',
          },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => ViewStock.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load items');
  }
}



   

}
