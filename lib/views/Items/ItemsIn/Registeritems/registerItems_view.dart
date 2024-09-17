import 'package:cjowner/services/items/StockService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class RegisterItemsView extends StatefulWidget {
  const RegisterItemsView({Key? key}) : super(key: key);

  @override
  _RegisterItemsViewState createState() => _RegisterItemsViewState();
}

class _RegisterItemsViewState extends State<RegisterItemsView> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final itemName = _itemNameController.text;
      final companyName = _companyNameController.text;
      final companyAddress = _companyAddressController.text;

      try {
        final response = await StockService.registerItems(
          itemName: itemName,
          companyName: companyName,
          companyAddress: companyAddress,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Display success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item registered successfully!')),
          );
          // Optionally, clear the form fields
          _itemNameController.clear();
          _companyNameController.clear();
          _companyAddressController.clear();
          GoRouter.of(context).goNamed('itemsIn');
        } else {
          // Display error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register item: ${response.statusCode}')),
          );
          GoRouter.of(context).goNamed('itemsIn');
        }
      } catch (e) {
        // Display exception message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Register Items',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyAddressController,
                decoration: const InputDecoration(
                  labelText: 'Company Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      4.0), // Adjust the radius as needed
                ),
                minWidth: double.infinity,
                onPressed: _submitForm,
                child: const Text('Register Item',style: TextStyle(color: Colors.white,fontSize: 20),),
                color: Colors.green,
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
