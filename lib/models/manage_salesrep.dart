class ManageSalesRepModel {
  final String id; // Add this field
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

  ManageSalesRepModel({
    required this.id, // Include id in the constructor
    required this.name,
    required this.nic,
    required this.address,
    required this.dob,
    required this.mobileNumber,
    required this.branchname,
    required this.email,
    required this.password,
    this.customDate = '',
    this.customTime = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id in the JSON representation
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

  factory ManageSalesRepModel.fromJson(Map<String, dynamic> json) {
    return ManageSalesRepModel(
      id: json['_id'], // Map the id field
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
