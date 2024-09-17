import 'package:cjowner/services/auth/auth_service.dart';
import 'package:cjowner/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cjowner/models/stockitemmodel.dart';
import 'package:cjowner/services/items/pricing_item_service.dart';
import 'package:http/http.dart' as http;

class PricingitemView extends StatefulWidget {
  const PricingitemView({super.key});

  @override
  _PricingitemViewState createState() => _PricingitemViewState();
}

class _PricingitemViewState extends State<PricingitemView> {
  final StockPricingService _service = StockPricingService();
  List<StockItemmodel> _stockItems = [];
  List<StockItemmodel> _filteredStockItems = [];
  bool _isLoading = false;
  String _searchQuery = "";

  Future<void> _loadStockItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _stockItems = await _service.fetchStockItems();
      _filteredStockItems = _stockItems; // Initially show all items
    } catch (e) {
      // Handle errors here
      print('Error loading stock items: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStockItems();
  }

  void _filterStockItems(String query) {
    List<StockItemmodel> results;
    if (query.isEmpty) {
      results = _stockItems;
    } else {
      results = _stockItems.where((item) {
        final itemName = item.itemName.toLowerCase();
        final searchQuery = query.toLowerCase();
        return itemName.contains(searchQuery);
      }).toList();
    }

    setState(() {
      _filteredStockItems = results;
      _searchQuery = query;
    });
  }

  void _openEditPage(StockItemmodel item) {
    GoRouter.of(context).pushNamed('editpricingItem', extra: item);
  }

  Future<void> _deleteItem(String id) async {
    // Retrieve the token
    final String? token = await AuthService.getToken();

    // Define headers with conditional Authorization
    final headers = token != null
        ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }
        : {
            'Content-Type': 'application/json',
          };

    final url = Uri.parse('http://147.79.66.105/api/stock/deleteRegisterItem/$id');

    try {
      // Send the DELETE request with headers
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        // Successfully deleted the item
        setState(() {
          _stockItems.removeWhere((item) => item.id == id);
          _filteredStockItems.removeWhere((item) => item.id == id);
        });
      } else {
        // Handle the error
        showSnackbar(context, 'faild to delete because item count is greater than 0');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Pricing Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterStockItems,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredStockItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredStockItems[index];
                      return GestureDetector(
                        onTap: () => _openEditPage(item),
                        child: Card(
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text('Company: ${item.companyName}'),
                                Text('Address: ${item.companyAddress}'),
                                Text('Quantity: ${item.qty}'),
                                Text('Rate: ${item.rate}'),
                                Text('Amount of Items: ${double.tryParse(item.amountOfItems)?.toStringAsFixed(2)}'),
                                if (item.margin != null)
                                  Text('Margin: ${double.tryParse(item.margin!)?.toStringAsFixed(2)}'),
                                if (item.price != null)
                                  Text('Price: ${item.price}'),
                                Text('Date: ${item.customDate}'),
                                Text('Time: ${item.customTime}'),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (item.qty < 1)
                                      ElevatedButton(
                                      onPressed: () => _deleteItem(item.id!),
                                      child: Icon(Icons.delete),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _openEditPage(item),
                                      child: Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadStockItems,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
