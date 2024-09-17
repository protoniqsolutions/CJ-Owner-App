// lib/services/sales_rep_service.dart
import 'dart:convert';
import 'package:cjowner/models/manage_salesrep.dart';
import 'package:cjowner/models/salesRep.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class ManageSalesRepService {
  final String _baseUrl = 'http://147.79.66.105/api/salesrep';

  // Update Sales Rep
  Future<bool> updateSalesRep(ManageSalesRepModel salesRep) async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$_baseUrl/updateSalesRepById/${salesRep.id}');
    final body = jsonEncode(salesRep.toJson());

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update sales rep: ${response.body}');
      return false;
    }
  }

  // Delete Sales Rep
  Future<bool> deleteSalesRep(String id) async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$_baseUrl/deleteSalesRepById/$id');

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to delete sales rep: ${response.body}');
      return false;
    }
  }
}
