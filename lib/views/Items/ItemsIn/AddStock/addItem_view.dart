import 'package:cjowner/components/ItemNameDropdown.dart';
import 'package:flutter/material.dart';
import 'package:cjowner/models/AddStockRequest.dart';
import 'package:cjowner/models/StockItem.dart';
import 'package:cjowner/services/items/StockService.dart';


class AdditemView extends StatefulWidget {
  const AdditemView({super.key});

  @override
  State<AdditemView> createState() => _AdditemViewState();
}

class _AdditemViewState extends State<AdditemView> {
  final _itemNameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _rateController = TextEditingController();

  final List<StockItem> _items = [];
  final StockService _stockService = StockService();
  bool _isCompleting = false;

  void _addItem() {
    final itemName = _itemNameController.text;
    final qty = double.tryParse(_qtyController.text) ?? 0;
    final rate = _rateController.text as String ?? "0.00";

    if (itemName.isEmpty || qty <= 0 ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid item details')),
      );
      return;
    }

    setState(() {
      _items.add(StockItem(itemName: itemName, qty: qty, rate: rate));
      _itemNameController.clear();
      _qtyController.clear();
      _rateController.clear();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _completeAndAddStock() {
    setState(() {
      _isCompleting = true;
    });

    final request = AddStockRequest(
      verification: 'pending',
      items: _items,
    );

    print(request);



    _stockService.addStock(request).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stock added successfully')),
      );
      setState(() {
        _items.clear(); // Clear the list after successful submission
        _isCompleting = false;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add stock: $error')),
      );
      setState(() {
        _isCompleting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Item",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(28.0),
          child: Column(
            children: [
              ItemNameDropdown(controller: _itemNameController),
              SizedBox(height: 20),
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Qty',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _rateController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Rate',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.green,
                height: 55,
                onPressed: _addItem,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                ),
                child: Text("Add Item", style: TextStyle(fontSize: 26, color: Colors.white)),
              ),
              SizedBox(height: 20),
              if (_items.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        title: Text(item.itemName),
                        subtitle: Text('Qty: ${item.qty}, Rate: ${item.rate}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.green,
                height: 55,
                onPressed: _isCompleting ? null : _completeAndAddStock,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                ),
                child: Text(
                  _isCompleting ? "Completing..." : "Complete",
                  style: TextStyle(fontSize: 26, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
