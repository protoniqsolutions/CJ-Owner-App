// lib/services/sales_rep_service.dart
import 'dart:convert';
import 'package:cjowner/models/manage_salesrep.dart';
import 'package:cjowner/models/salesRep.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class SalesRepService {
  final String _baseUrl = 'http://147.79.66.105/api/salesrep';

  Future<bool> addSalesRep(SalesRepModel salesRep) async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$_baseUrl/addSalesRep');
    final body = jsonEncode(salesRep.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return true;
    } else {
      // Handle error response
      print('Failed to add sales rep: ${response.body}');
      return false;
    }
  }

  Future<List<ManageSalesRepModel>> getAllSalesReps() async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$_baseUrl/getAllSalesReps');

    final response = await http.get(url, headers: headers);
    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ManageSalesRepModel.fromJson(json)).toList();
    } else {
      print('Failed to fetch sales reps: ${response.body}');
      return [];
    }
  }
}
