import 'package:flutter/material.dart';
import 'package:cjowner/models/stockitemmodel.dart';
import 'package:cjowner/services/items/update_pricing_item_service.dart';

class EditPricingItem extends StatefulWidget {
  final StockItemmodel item;

  const EditPricingItem({Key? key, required this.item}) : super(key: key);

  @override
  _EditPricingItemState createState() => _EditPricingItemState();
}

class _EditPricingItemState extends State<EditPricingItem> {
  final _formKey = GlobalKey<FormState>();
  final UpdatePricingItemService _updateService = UpdatePricingItemService();

  late TextEditingController _discountController;
  late TextEditingController _priceController;
  late TextEditingController _rateController;

  bool _isUpdating = false;
  double? _calculatedMargin;

  @override
  void initState() {
    super.initState();
    _discountController =
        TextEditingController(text: widget.item.discount?.toString() ?? '');
    _priceController =
        TextEditingController(text: widget.item.price?.toString() ?? '');
    _rateController =
        TextEditingController(text: widget.item.rate.toString() ?? '');
  }

  @override
  void dispose() {
    _discountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double _calculateMargin(double price, double discount,double rate) {
    // print("price ${price} discount${discount} rate ${rate}");
    // print(((price - rate)/rate) * 100);
    // print(((price - rate)/rate) * 100);
    return ((price - rate)/rate) * 100 ;
  }

  void _updateMargin() {
    final double discount =  0;
    final double price = double.tryParse(_priceController.text) ?? 0;
    final double rate = double.tryParse(_rateController.text) ?? 0;
    setState(() {
      _calculatedMargin = _calculateMargin(price, discount ,rate);
    });
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUpdating = true;
      });

      final double discount = double.tryParse(_discountController.text) ?? 0;
      final double price = double.tryParse(_priceController.text) ?? 0.00;
      final double rate = double.tryParse(_rateController.text) ?? 0.00;
      final double margin = _calculateMargin(price, discount,rate) ?? 0.00;
      print(margin);

      final success = await _updateService.updatePricingItem(
        itemName: widget.item.itemName,
        discount: _discountController.text,
        price: _priceController.text,
        margin: margin.toStringAsFixed(1), // Rounded to 2 decimal places
      );

      setState(() {
        _isUpdating = false;
      });

      if (success) {
        // Pop the screen to return to the view page
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.item.itemName}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _rateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Rate',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                )),
                SizedBox(height: 15),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
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
              SizedBox(height: 20),
              if (_calculatedMargin != null)
                Text(
                  'Calculated Margin: ${_calculatedMargin!.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUpdating ? null : _updateItem,
                child: _isUpdating
                    ? CircularProgressIndicator()
                    : Text('Update Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
