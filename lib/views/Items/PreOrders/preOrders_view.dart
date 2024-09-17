import 'package:flutter/material.dart';
import 'package:cjowner/models/average_quantity_model.dart';
import 'package:cjowner/services/items/average_quantity_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PreordersView extends StatefulWidget {
  const PreordersView({super.key});

  @override
  _PreordersViewState createState() => _PreordersViewState();
}

class _PreordersViewState extends State<PreordersView> {
  final AverageQuantityService _service = AverageQuantityService();
  AverageQuantityResponse? _averageQuantityResponse;
  bool _isLoading = true;
  String _searchQuery = '';
  List<String> _filteredItemNames = [];
  List<SelectedItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await _service.fetchAverageQuantity();
    setState(() {
      _averageQuantityResponse = response;
      _filteredItemNames = response?.items.keys.toList() ?? [];
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredItemNames = _averageQuantityResponse?.items.keys
              .where((itemName) =>
                  itemName.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList() ??
          [];
    });
  }

  void _addItemToList(String itemName, int quantity) {
    setState(() {
      final existingItemIndex = _selectedItems.indexWhere((item) => item.itemName == itemName);
      if (existingItemIndex >= 0) {
        _selectedItems.removeAt(existingItemIndex); // Unselect if already selected
      } else {
        _selectedItems.add(SelectedItem(itemName, quantity));
      }
    });
  }

  void _showAddQuantityDialog(String itemName) {
    int quantity = 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Quantity for $itemName'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            quantity = int.parse(value);
          },
          decoration: const InputDecoration(hintText: "Enter quantity"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addItemToList(itemName, quantity);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm:ss');
    final currentDate = dateFormat.format(DateTime.now());
    final currentTime = timeFormat.format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'CJ System',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date: $currentDate',
                      style: pw.TextStyle(fontSize: 14)),
                  pw.Text('Time: $currentTime',
                      style: pw.TextStyle(fontSize: 14)),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey),
                headers: ['Item Name', 'Quantity'],
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 16),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                cellHeight: 40,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                },
                data: _selectedItems
                    .map((item) =>
                        [item.itemName, item.quantity.toString()])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total Items: ${_selectedItems.length}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey800,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Preorders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _selectedItems.isNotEmpty ? _generatePdf : null,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _averageQuantityResponse == null
              ? const Center(child: Text("Failed to load data"))
              : Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextField(
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search by item name...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredItemNames.length,
                          itemBuilder: (context, index) {
                            final itemName = _filteredItemNames[index];
                            final item =
                                _averageQuantityResponse!.items[itemName];
                            final isSelected = _selectedItems.any(
                                (selectedItem) => selectedItem.itemName == itemName);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 7),
                              child: ListTile(
                                onTap: () => _showAddQuantityDialog(itemName),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                leading: const Icon(
                                  Icons.fastfood,
                                  color: Colors.orangeAccent,
                                  size: 40.0,
                                ),
                                title: Text(
                                  itemName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: isSelected ? Colors.blue : Colors.blueGrey,
                                  ),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Current Qty: ${item?.currentQty}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Average Qty: ${item?.averageQty}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Difference: ${item?.difference}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: item!.difference!.isNegative ??
                                                false
                                            ? Colors.redAccent
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                  color: isSelected ? Colors.blue : Colors.green,
                                ),
                                tileColor: isSelected ? Colors.blue[50] : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.grey[300]!),
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

class SelectedItem {
  final String itemName;
  final int quantity;

  SelectedItem(this.itemName, this.quantity);
}
