class StockItemmodel {
  final String? id;
  final String itemName;
  final String companyName;
  final String companyAddress;
  final int qty;
  final String rate;
  final String amountOfItems;
  final String? discount;
  final String? margin; // Changed from String? to double?
  final String? price;
  final String customDate;
  final String customTime;

  StockItemmodel({
    required this.id,
    required this.itemName,
    required this.companyName,
    required this.companyAddress,
    required this.qty,
    required this.rate,
    required this.amountOfItems,
    this.discount,
    this.margin, // Updated type
    this.price,
    required this.customDate,
    required this.customTime,
  });

  // Factory method to create a StockItem from JSON
  factory StockItemmodel.fromJson(Map<String, dynamic> json) {
    return StockItemmodel(
      id: json['_id'],
      itemName: json['itemName'],
      companyName: json['companyName'],
      companyAddress: json['companyAddress'],
      qty: json['qty'],
      rate: json['rate'] ,
      amountOfItems: json['amountOfItems'] ,
      discount: json['discount'] ,
      margin: json['margin'], // Convert to double if it's a string
      price: json['price'],
      customDate: json['customDate'],
      customTime: json['customTime'],
    );
  }
}
