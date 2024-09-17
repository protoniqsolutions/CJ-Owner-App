import 'package:cjowner/models/customer.dart';
import 'package:cjowner/models/manageCustomer.dart';
import 'package:cjowner/services/customer/customerService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({super.key});

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  final CustomerService _customerService = CustomerService();
  List<manageCustomer> _customers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final customers = await _customerService.getCustomers();
      setState(() {
        _customers = customers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCustomers() async {
    setState(() {
      _isLoading = true;  // Optionally set loading state while refreshing
    });
    await _fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Customers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            // MaterialButton(
            //   minWidth: double.infinity,
            //   color: Colors.green,
            //   height: 55,
            //   onPressed: () {
            //     GoRouter.of(context).pushNamed('addCustomers');
            //   },
            //   child: const Text("Add Customers", style: TextStyle(fontSize: 26)),
            // ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshCustomers, // Add the refresh callback
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage.isNotEmpty
                        ? Center(child: Text('Error: $_errorMessage'))
                        : _customers.isEmpty
                            ? const Center(child: Text('No customer data available'))
                            : ListView.builder(
                                itemCount: _customers.length,
                                itemBuilder: (context, index) {
                                  final customer = _customers[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 20,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        GoRouter.of(context).pushNamed(
                                          'manageCustomers',
                                          extra: customer,
                                        );
                                      },
                                      title: Text(
                                        customer.shopName ?? 'No Shop',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        customer.address ?? 'No Address',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
