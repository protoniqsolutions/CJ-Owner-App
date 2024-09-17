import 'dart:convert';
import 'package:cjowner/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = '${Config.baseurl}/owner';

  // Login API Call
  static Future<String?> applogin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['accessToken'];
      } else {
        return null; // Invalid credentials
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Store Token
  static Future<void> storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }


  // Get Token from Shared Preferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> applogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove the JWT token from SharedPreferences
    await prefs.remove('jwt_token');
  }


  static Future<bool> checkMaintenanceStatus() async {
  final response = await http.get(Uri.parse('http://147.79.66.105/api/status'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['maintenance'] ?? false;
  } else {
    throw Exception('Failed to load maintenance status');
  }
}
  


  
}