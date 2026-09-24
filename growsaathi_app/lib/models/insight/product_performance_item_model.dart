import '../../core/utils/json_parsing.dart';

/// Mirrors the real `ProductPerformanceDTO` (`GET /api/product-performance`)
/// / `GET /api/products/top-selling` shapes.
class ProductPerformanceItemModel {
  final int productId;
  final String productName;
  final String category;
  final int quantitySold;
  final double revenue;

  const ProductPerformanceItemModel({
    required this.productId,
    required this.productName,
    required this.category,
    required this.quantitySold,
    required this.revenue,
  });

  factory ProductPerformanceItemModel.fromJson(Map<String, dynamic> json) {
    return ProductPerformanceItemModel(
      productId: asInt(json['productId']),
      productName: asString(json['productName'], 'Product'),
      category: asString(json['category'], 'General'),
      quantitySold: asInt(json['quantitySold'] ?? json['totalQuantitySold']),
      revenue: asDouble(json['revenue'] ?? json['totalRevenue']),
    );
  }
}
