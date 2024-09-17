import 'dart:convert';
import 'package:cjowner/config/config.dart';
import 'package:cjowner/models/customer.dart';
import 'package:cjowner/models/manageCustomer.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  final String baseUrl = '${Config.baseurl}/customer';

//get customers
  Future<List<manageCustomer>> getCustomers() async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/getAllCustomers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => manageCustomer.fromJson(json)).toList();
    } else {
      print('Failed to fetch customers: ${response.body}');
      throw Exception('Failed to load customers');
    }
  }

//get single customer
  Future<Customer> getCustomer(String id) async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/getCustomerById/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load customer');
    }
  }

//add customer
  Future<void> addCustomer(Customer customer) async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse('$baseUrl/addCustomer'),
      headers: headers,
      body: json.encode(customer.toJson()),
    );

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 400) {
      String message = json.decode(response.body)['message'];
      throw Exception(message);
    } else {
      throw Exception('Failed to add customer');
    }
  }

//delete customer
  Future<void> deleteCustomer(String id) async {
    final String? token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response =
        await http.delete(Uri.parse('$baseUrl/deleteCustomer/$id'),     
        headers: headers,
        );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      String message = json.decode(response.body)['message'];
      throw Exception(message);
    } else {
      throw Exception('Failed to delete customer');
    }
  }
}
