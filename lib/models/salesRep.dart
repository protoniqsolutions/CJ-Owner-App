// lib/models/sales_rep_model.dart
class SalesRepModel {
  final String name;
  final String nic;
  final String address;
  final String dob;
  final String mobileNumber;
  final String branchname;
  final String email;
  final String password;
  final String customDate;
  final String customTime;

  SalesRepModel({
    required this.name,
    required this.nic,
    required this.address,
    required this.dob,
    required this.mobileNumber,
    required this.branchname,
    required this.email,
    required this.password,
    this.customDate = '', // Optional with default value
    this.customTime = '', // Optional with default value
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nic': nic,
      'address': address,
      'dob': dob,
      'mobileNumber': mobileNumber,
      'branchname': branchname,
      'email': email,
      'password': password,
      'customDate': customDate,
      'customTime': customTime,
    };
  }

  factory SalesRepModel.fromJson(Map<String, dynamic> json) {
    return SalesRepModel(
      name: json['name'],
      nic: json['nic'],
      address: json['address'],
      dob: json['dob'],
      mobileNumber: json['mobileNumber'],
      branchname: json['branchname'],
      email: json['email'],
      password: json['password'],
      customDate: json['customDate'] ?? '',
      customTime: json['customTime'] ?? '',
    );
  }
}
