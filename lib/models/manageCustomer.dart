class manageCustomer {
  final String? id;
  final String? shopName;
  final String? ownerName;
  final String? address;
  final String? berNumber;
  final String? mobileNumber;
  final String? landNumber;

  manageCustomer({
    this.id,
    this.shopName,
    this.ownerName,
    this.address,
    this.berNumber,
    this.mobileNumber,
    this.landNumber,
  });

  factory manageCustomer.fromJson(Map<String, dynamic> json) {
    return manageCustomer(
      id: json['_id'],
      shopName: json['shopName'],
      ownerName: json['ownerName'],
      address: json['address'],
      berNumber: json['berNumber'],
      mobileNumber: json['mobileNumber'],
      landNumber: json['landNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'ownerName': ownerName,
      'address': address,
      'berNumber': berNumber,
      'mobileNumber': mobileNumber,
      'landNumber': landNumber,
    };
  }
}
