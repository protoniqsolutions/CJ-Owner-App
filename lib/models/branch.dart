
class Branch {
  final String branchId;
  final String branchName;

  Branch({required this.branchId, required this.branchName});

  // Convert a Branch object to a Map
  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
    };
  }

  // Create a Branch object from a Map
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchId: json['branchId'],
      branchName: json['branchName'],
    );
  }
}
