import '../../core/utils/json_parsing.dart';

enum InventoryHealthStatus { healthy, low, outOfStock }

/// Mirrors the real `Product` entity fields the Inventory screen needs
/// (`GET /api/inventory-insights`, `GET /api/products`).
class InventoryHealthItemModel {
  final int productId;
  final String productName;
  final int stock;
  final int reorderLevel;

  const InventoryHealthItemModel({
    required this.productId,
    required this.productName,
    required this.stock,
    required this.reorderLevel,
  });

  factory InventoryHealthItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryHealthItemModel(
      productId: asInt(json['productId']),
      productName: asString(json['productName'], 'Product'),
      stock: asInt(json['stock']),
      reorderLevel: asInt(json['reorderLevel'], 10),
    );
  }

  InventoryHealthStatus get status {
    if (stock <= 0) return InventoryHealthStatus.outOfStock;
    if (stock <= reorderLevel) return InventoryHealthStatus.low;
    return InventoryHealthStatus.healthy;
  }
}
