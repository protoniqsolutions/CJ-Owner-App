import 'dart:convert';
import 'dart:io';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelGeneratorstock {
  final String? token; // Token passed to the constructor

  ExcelGeneratorstock({this.token});

  // Fetch stock data from the API with optional authorization
  Future<List<dynamic>> fetchStocks() async {
    final String? token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('http://147.79.66.105/api/excel/getAllStocks'),
      headers: token != null ? {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      } : {},
    );

    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  // Generate Excel file for stock data
  Future<void> generateExcelForStocks(List<dynamic> stocks) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Stocks'];

    // Add header row
    sheet.appendRow([
      "Item Name",
      "Company Name",
      "Company Address",
      "Quantity",
      "Rate",
      "Amount of Items",
      "Margin",
      "Price",
      "Date",
      "Time"
    ]);

    // Add stock data
    for (var stock in stocks) {
      sheet.appendRow([
        stock['itemName'],
        stock['companyName'],
        stock['companyAddress'],
        stock['qty'].toString(),
        stock['rate'].toString(),
        stock['amountOfItems'].toString(),
        stock['margin'].toString(),
        stock['price'].toString(),
        stock['customDate'],
        stock['customTime']
      ]);
    }

    // Get the document directory to save the file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/stocks.xlsx";

    // Save the file
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);
    
    print('Excel file saved at: $filePath');

    // Share the file
    await Share.shareFiles([filePath], text: 'Here are the stock details.');
  }

  // Main function to fetch data and generate Excel for stocks
  Future<void> fetchAndGenerateExcelForStocks() async {
    try {
      List<dynamic> stocks = await fetchStocks();
      await generateExcelForStocks(stocks);
    } catch (e) {
      print('Error: $e');
    }
  }
}
