import 'package:flutter/material.dart';
import 'package:cjowner/models/viewstock_model.dart';
import 'package:cjowner/services/items/StockService.dart';

class ViewitemsView extends StatefulWidget {
  const ViewitemsView({super.key});

  @override
  _ViewitemsViewState createState() => _ViewitemsViewState();
}

class _ViewitemsViewState extends State<ViewitemsView> {
  late Future<List<ViewStock>> _futureItems;
  final StockService _apiService = StockService();
  List<ViewStock> _allItems = [];
  List<ViewStock> _filteredItems = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureItems = _apiService.getAllStockItems();
    _futureItems.then((items) {
      setState(() {
        _allItems = items;
        _filteredItems = items;
      });
    });
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        return item.itemName.toLowerCase().contains(query) ||
               item.companyName.toLowerCase().contains(query) ||
               item.companyAddress.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "View Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ViewStock>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          }

          return ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(item.itemName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(item.itemName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Company: ${item.companyName}'),
                        Text('Address: ${item.companyAddress}'),
                        Text('Quantity: ${item.qty}'),
                        Text('Rate: Rs ${item.rate}'),
                        Text('Amount: ${item.amountOfItems}'),
                        if (item.margin != null)
                          Text('Margin: ${double.tryParse(item.margin!)?.toStringAsFixed(1)} %'),
                        if (item.price != null)
                          Text('Price: Rs ${double.tryParse(item.price!)?.toStringAsFixed(2)}'),
                        Text('Date: ${item.customDate}'),
                        Text('Time: ${item.customTime}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
