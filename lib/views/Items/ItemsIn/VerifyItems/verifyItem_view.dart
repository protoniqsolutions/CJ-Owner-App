import 'package:cjowner/services/items/StockService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyitemView extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String stockId;

  const VerifyitemView({
    Key? key,
    required this.items,
    required this.stockId,
  }) : super(key: key);

  @override
  State<VerifyitemView> createState() => _VerifyitemViewState();
}

class _VerifyitemViewState extends State<VerifyitemView> {
  List<Map<String, dynamic>> itemsUpdates = [];

  // Handle failed verification with a dialog
  void handleVerifyFailed(Map<String, dynamic> item) async {
    final updatedItem = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return VerifyFailedDialog(item: item);
      },
    );

    // If an item was updated, add to the updates list
    if (updatedItem != null) {
      setState(() {
        itemsUpdates.add(updatedItem);
      });

      // Remove the verified item from the list
      widget.items.removeWhere((i) => i['_id'] == item['_id']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item marked as failed and updated!')),
      );
    }
  }

  // Handle correct verification by adding a zero entry
  void handleVerifyCorrect(Map<String, dynamic> item) {
    // Create a zero-value entry with the same item_name
    Map<String, dynamic> zeroValueEntry = {
      'item_name': item['item_name'],
      'qty': 0.00,
      'rate': 0.00,
      'price': 0.00,
    };

    // Add the zero-value entry to itemsUpdates list
    setState(() {
      itemsUpdates.add(zeroValueEntry);

      // Remove the verified item from the list
      widget.items.removeWhere((i) => i['_id'] == item['_id']);
      print(itemsUpdates);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item verified as correct!')),
    );
  }

  // Complete the verification process and call the API
  void handleCompleteVerification() async {
    print(widget.stockId);
    print(itemsUpdates);
    bool success =
        await StockService.updateVerifyItems(widget.stockId, itemsUpdates);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All items have been verified and updated!')),
      );
      GoRouter.of(context).pushNamed('itemsIn');

      // Optionally navigate to another screen or perform additional actions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update items. Please try again!')),
      );
      GoRouter.of(context).pushNamed('itemsIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Item Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: handleCompleteVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Complete Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text("Complete to all verify items",style: TextStyle(color: Colors.white),),
                       SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Name: ${item['item_name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Qty: ${item['qty']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Rate: ${item['rate']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Price: ${item['price']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  handleVerifyCorrect(item);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  'Verify',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  handleVerifyFailed(item);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class VerifyFailedDialog extends StatefulWidget {
  final Map<String, dynamic> item;

  const VerifyFailedDialog({Key? key, required this.item}) : super(key: key);

  @override
  _VerifyFailedDialogState createState() => _VerifyFailedDialogState();
}

class _VerifyFailedDialogState extends State<VerifyFailedDialog> {
  late TextEditingController itemNameController;
  late TextEditingController qtyController;
  late TextEditingController rateController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.item['item_name']);
    qtyController = TextEditingController(text: widget.item['qty'].toString());
    rateController =
        TextEditingController(text: widget.item['rate'].toString());
    priceController =
        TextEditingController(text: widget.item['price'].toString());
  }

  @override
  void dispose() {
    itemNameController.dispose();
    qtyController.dispose();
    rateController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Verify Failed Item Update'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: qtyController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: rateController,
              decoration: InputDecoration(
                labelText: 'Rate',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedItem = {
              'item_name': itemNameController.text,
              'qty': double.tryParse(qtyController.text) ?? 0.00,
              'rate': double.tryParse(rateController.text)?.toStringAsFixed(2) ?? 0.00,
            };
            Navigator.of(context).pop(updatedItem); // Return the updated item
          },
          child: Text('Update Item'),
        ),
      ],
    );
  }

}
