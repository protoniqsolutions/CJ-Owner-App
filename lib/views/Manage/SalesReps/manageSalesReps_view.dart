// lib/views/manage_salesrep_view.dart
import 'package:cjowner/services/salesrep/managesalesrep.dart';
import 'package:flutter/material.dart';
import 'package:cjowner/models/manage_salesrep.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cjowner/services/auth/auth_service.dart'; // Import AuthService

class ManagesalesrepsView extends StatefulWidget {
  final ManageSalesRepModel salesRep; // Add this line to receive the sales rep data

  const ManagesalesrepsView({super.key, required this.salesRep});

  @override
  State<ManagesalesrepsView> createState() => _ManagesalesrepsViewState();
}

class _ManagesalesrepsViewState extends State<ManagesalesrepsView> {
  late TextEditingController nameController;
  late TextEditingController nicController;
  late TextEditingController addressController;
  late TextEditingController dobController;
  late TextEditingController mobileNumberController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late String id;
  bool isLoading = false; // New loading state

  final ManageSalesRepService _service = ManageSalesRepService();

  List<String> _branches = [];
  String? _selectedBranch;

  @override
  void initState() {
    super.initState();
    id = widget.salesRep.id;
    nameController = TextEditingController(text: widget.salesRep.name);
    nicController = TextEditingController(text: widget.salesRep.nic);
    addressController = TextEditingController(text: widget.salesRep.address);
    dobController = TextEditingController(text: widget.salesRep.dob);
    mobileNumberController =
        TextEditingController(text: widget.salesRep.mobileNumber);
    emailController = TextEditingController(text: widget.salesRep.email);
    passwordController = TextEditingController(text: '');
    _fetchBranches();
  }

  @override
  void dispose() {
    nameController.dispose();
    nicController.dispose();
    addressController.dispose();
    dobController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchBranches() async {
    try {
      final String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('http://147.79.66.105/api/branch/getAllBranches'),
        headers: token != null
            ? {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              }
            : {},
      );

      if (response.statusCode == 200) {
        final List<dynamic> branchList = json.decode(response.body);
        setState(() {
          _branches = List<String>.from(branchList);
          // Set the selected branch to the one from the salesRep or the first in the list
          _selectedBranch = _branches.contains(widget.salesRep.branchname)
              ? widget.salesRep.branchname
              : (_branches.isNotEmpty ? _branches[0] : null);
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

  Future<void> updateSalesRep() async {
    setState(() {
      isLoading = true;
    });

    final salesRep = ManageSalesRepModel(
      id: id,
      name: nameController.text,
      nic: nicController.text,
      address: addressController.text,
      dob: dobController.text,
      mobileNumber: mobileNumberController.text,
      email: emailController.text,
      branchname: _selectedBranch ?? '',
      password: passwordController.text ?? '', // New password field
    );

    final success = await _service.updateSalesRep(salesRep);

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sales rep updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      GoRouter.of(context).pushReplacementNamed("manage");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update sales rep. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      GoRouter.of(context).pushReplacementNamed("manage");
    }
  }

  Future<void> deleteSalesRep() async {
    setState(() {
      isLoading = true;
    });

    final success = await _service.deleteSalesRep(id);

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sales rep deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Go back after deletion
      GoRouter.of(context).pushReplacementNamed("manage");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete sales rep. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      GoRouter.of(context).pushReplacementNamed("manage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Manage Sales Reps",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nicController,
                      decoration: const InputDecoration(
                        labelText: 'NIC',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: dobController,
                      decoration: const InputDecoration(
                        labelText: 'DOB',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                       keyboardType: TextInputType.number,
                      controller: mobileNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
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
                      decoration: const InputDecoration(
                        labelText: 'Branch Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select a branch' : null,
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      minWidth: double.infinity,
                      color: Colors.green,
                      height: 55,
                      onPressed: updateSalesRep,
                      child: const Text(
                        "Update Sales Rep",
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                    const SizedBox(height: 15),
                    MaterialButton(
                      minWidth: double.infinity,
                      color: Colors.red,
                      height: 55,
                      onPressed: deleteSalesRep,
                      child: const Text(
                        "Delete Sales Rep",
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
