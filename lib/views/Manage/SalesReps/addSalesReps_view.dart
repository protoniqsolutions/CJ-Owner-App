import 'package:cjowner/models/salesRep.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:cjowner/services/salesrep/salesrepservice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddsalesrepsView extends StatefulWidget {
  const AddsalesrepsView({super.key});

  @override
  AddsalesrepsViewState createState() => AddsalesrepsViewState();
}

class AddsalesrepsViewState extends State<AddsalesrepsView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final SalesRepService _salesRepService = SalesRepService();

  List<String> _branches = [];
  String? _selectedBranch;

  @override
  void initState() {
    super.initState();
    _fetchBranches();
  }

  Future<void> _fetchBranches() async {
    try {
      final String? token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('http://147.79.66.105/api/branch/getAllBranches'),
      headers: token != null ? {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      } : {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> branchList = json.decode(response.body);
      setState(() {
        _branches = List<String>.from(branchList);
        _selectedBranch = _branches.isNotEmpty ? _branches[0] : null; // Select the first branch by default
      });
      
    } else {
      throw Exception('Failed to load branches');

    }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load branches: $e')),
      );
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dobController.text =
            '${pickedDate.toLocal()}'.split(' ')[0]; // Format: YYYY-MM-DD
      });
    }
  }

  void _addSalesRep() async {
    if (_formKey.currentState!.validate()) {
      final salesRep = SalesRepModel(
        name: _nameController.text,
        nic: _nicController.text,
        address: _addressController.text,
        dob: _dobController.text,
        mobileNumber: _mobileNumberController.text,
        branchname: _selectedBranch ?? '',
        email: _emailController.text,
        password: _passwordController.text,
      );

      final success = await _salesRepService.addSalesRep(salesRep);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sales representative added successfully')),
        );
        GoRouter.of(context).pushReplacementNamed("manage");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add sales representative')),
        );
        GoRouter.of(context).pushReplacementNamed("manage");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Sales Representative')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter name' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nicController,
                  decoration: InputDecoration(
                    labelText: 'NIC',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter NIC' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter address' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDateOfBirth(context),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter date of birth' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter mobile number' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedBranch,
                  items: _branches.map((branch) {
                    return DropdownMenuItem<String>(
                      value: branch,
                      child: Text(branch),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBranch = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? 'Please select a branch' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter email' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter password' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(height: 10),
                MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.green,
                  height: 55,
                  onPressed: _addSalesRep,
                  child: Text(
                    'Add Sales Rep',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
