import 'package:cjowner/models/customer.dart';
import 'package:cjowner/services/customer/customerService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddcustomerView extends StatefulWidget {
  const AddcustomerView({super.key});

  @override
  State<AddcustomerView> createState() => _AddcustomerViewState();
}

class _AddcustomerViewState extends State<AddcustomerView> {
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _berNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _landNumberController = TextEditingController();

  final CustomerService _customerService = CustomerService();

  void _addCustomer() async {
    final customer = Customer(
      shopName: _shopNameController.text,
      ownerName: _ownerNameController.text,
      address: _addressController.text,
      berNumber: _berNumberController.text,
      mobileNumber: _mobileNumberController.text,
      landNumber: _landNumberController.text,
    );

    try {
      await _customerService.addCustomer(customer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer added successfully')),
      );
      GoRouter.of(context).pushNamed("customers");
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add customer')),
      );
    }
  }

  void _clearForm() {
    _shopNameController.clear();
    _ownerNameController.clear();
    _addressController.clear();
    _berNumberController.clear();
    _mobileNumberController.clear();
    _landNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Customers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              children: [
                TextField(
                  controller: _shopNameController,
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _ownerNameController,
                  decoration: InputDecoration(
                    labelText: 'Owner Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _berNumberController,
                  decoration: InputDecoration(
                    labelText: 'BER Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _landNumberController,
                  decoration: InputDecoration(
                    labelText: 'Land Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.green,
                  height: 55,
                  onPressed: _addCustomer,
                  child: Text("Add Customer", style: TextStyle(fontSize: 26)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
