// lib/models/average_quantity_model.dart

class AverageQuantity {
  final int? currentQty;
  final double? averageQty;
  final double? difference;

  AverageQuantity({
    required this.currentQty,
    required this.averageQty,
    required this.difference,
  });

  factory AverageQuantity.fromJson(Map<String, dynamic> json) {
    return AverageQuantity(
      currentQty: json['currentQty'],
      averageQty: (json['averageQty'] as num).toDouble(),
      difference: (json['difference'] as num).toDouble()
    );
  }
}

class AverageQuantityResponse {
  final Map<String, AverageQuantity> items;

  AverageQuantityResponse({required this.items});

  factory AverageQuantityResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, AverageQuantity> items = {};
    json.forEach((key, value) {
      items[key] = AverageQuantity.fromJson(value);
    });
    return AverageQuantityResponse(items: items);
  }
}
