import '../../core/utils/json_parsing.dart';

/// Maps the `inventory` block inside `GET /api/dashboard`.
class InventorySummaryModel {
  final int lowStockProducts;
  final int outOfStockProducts;

  const InventorySummaryModel({
    required this.lowStockProducts,
    required this.outOfStockProducts,
  });

  factory InventorySummaryModel.fromJson(Map<String, dynamic> json) {
    return InventorySummaryModel(
      lowStockProducts: asInt(json['lowStockProducts']),
      outOfStockProducts: asInt(json['outOfStockProducts']),
    );
  }

  factory InventorySummaryModel.empty() =>
      const InventorySummaryModel(lowStockProducts: 0, outOfStockProducts: 0);
}
