class ItemModel {
  final String itemName;
  final String companyName;
  final String companyAddress;

  ItemModel({
    required this.itemName,
    required this.companyName,
    required this.companyAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'companyName': companyName,
      'companyAddress': companyAddress,
    };
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemName: json['itemName'],
      companyName: json['companyName'],
      companyAddress: json['companyAddress'],
    );
  }
}
