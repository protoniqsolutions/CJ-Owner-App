import 'package:cjowner/models/manageCustomer.dart';
import 'package:cjowner/services/customer/customerService.dart';
import 'package:cjowner/services/customer/updateCustomerServise.dart';
import 'package:flutter/material.dart';
import 'package:cjowner/models/customer.dart';
import 'package:go_router/go_router.dart';

class ManagecustomersView extends StatefulWidget {
  final manageCustomer customer;

  const ManagecustomersView({super.key, required this.customer});

  @override
  State<ManagecustomersView> createState() => _ManagecustomersViewState();
}

class _ManagecustomersViewState extends State<ManagecustomersView> {
  late TextEditingController _shopNameController;
  late TextEditingController _ownerNameController;
  late TextEditingController _addressController;
  late TextEditingController _berNumberController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _landNumberController;

  final CustomerService _customerService = CustomerService();

  // Function to update customer details
  Future<void> _updateCustomer() async {
    print(" update function is call");
    final updatedCustomer = manageCustomer(
      id: widget.customer.id,
      shopName: _shopNameController.text,
      ownerName: _ownerNameController.text,
      address: _addressController.text,
      berNumber: _berNumberController.text,
      mobileNumber: _mobileNumberController.text,
      landNumber: _landNumberController.text,
    );

    // Call the updateCustomer function from the service
    bool success = await UpdateCustomerService.updateCustomer(
        widget.customer.id as String, updatedCustomer);

    // Show a success or failure message
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer updated successfully')),
      );
      GoRouter.of(context).pushNamed('customers');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update customer')),
      );
      GoRouter.of(context).pushNamed('customers');
    }
  }

  // Function to delete customer
  Future<void> _deleteCustomer() async {
    try {
      await _customerService.deleteCustomer(widget.customer.id
          as String); // Use the instance to call deleteCustomer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer deleted successfully')),
      );
      GoRouter.of(context).pushNamed('customers');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete customer: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _shopNameController = TextEditingController(text: widget.customer.shopName);
    _ownerNameController =
        TextEditingController(text: widget.customer.ownerName);
    _addressController = TextEditingController(text: widget.customer.address);
    _berNumberController =
        TextEditingController(text: widget.customer.berNumber);
    _mobileNumberController =
        TextEditingController(text: widget.customer.mobileNumber);
    _landNumberController =
        TextEditingController(text: widget.customer.landNumber);
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _ownerNameController.dispose();
    _addressController.dispose();
    _berNumberController.dispose();
    _mobileNumberController.dispose();
    _landNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Manage Customers",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
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
                  onPressed: _updateCustomer,
                  child:
                      Text("Update Customer", style: TextStyle(fontSize: 26)),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.green,
                  height: 55,
                  onPressed: _deleteCustomer,
                  child:
                      Text("Delete Customer", style: TextStyle(fontSize: 26)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
