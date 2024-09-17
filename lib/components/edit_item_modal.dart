import 'package:flutter/material.dart';
import 'package:cjowner/models/stockitemmodel.dart';
import 'package:cjowner/services/items/update_pricing_item_service.dart';

class EditItemModal extends StatefulWidget {
  final StockItemmodel item;
  final Function onUpdate;

  const EditItemModal({Key? key, required this.item, required this.onUpdate})
      : super(key: key);

  @override
  _EditItemModalState createState() => _EditItemModalState();
}

class _EditItemModalState extends State<EditItemModal> {
  final _formKey = GlobalKey<FormState>();
  final UpdatePricingItemService _updateService = UpdatePricingItemService();

  late TextEditingController _discountController;
  late TextEditingController _priceController;

  bool _isUpdating = false;
  double? _calculatedMargin;

  @override
  void initState() {
    super.initState();
    _discountController =
        TextEditingController(text: widget.item.discount?.toString() ?? '');
    _priceController =
        TextEditingController(text: widget.item.price?.toString() ?? '');
  }

  @override
  void dispose() {
    _discountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double _calculateMargin(double price, double discount) {
    return ((price - discount) / price) * 100;
  }

  void _updateMargin() {
    final double discount = double.tryParse(_discountController.text) ?? 0;
    final double price = double.tryParse(_priceController.text) ?? 0;
    setState(() {
      _calculatedMargin = _calculateMargin(price, discount);
    });
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUpdating = true;
      });

      final double discount = double.tryParse(_discountController.text) ?? 0;
      final double price = double.tryParse(_priceController.text) ?? 0;

      final double margin = _calculateMargin(price, discount);

      final success = await _updateService.updatePricingItem(
        itemName: widget.item.itemName,
        discount: _discountController.text,
        price: _priceController.text,
        margin: margin.toStringAsFixed(2), // Rounded to 2 decimal places
      );

      setState(() {
        _isUpdating = false;
      });

      if (success) {
        widget.onUpdate(); // Callback to refresh the list
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update the item. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate margin on price or discount change
    _updateMargin();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit ${widget.item.itemName}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _discountController,
                    decoration: InputDecoration(
                      labelText: 'Discount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.percent),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a discount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (_) => _updateMargin(), // Update margin on change
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (_) => _updateMargin(), // Update margin on change
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Margin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bar_chart),
                    ),
                    initialValue: _calculatedMargin != null
                        ? _calculatedMargin!.toStringAsFixed(2)
                        : '',
                    enabled: false, // Make it read-only
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _isUpdating ? null : _updateItem,
                        child: _isUpdating
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text('Update'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
