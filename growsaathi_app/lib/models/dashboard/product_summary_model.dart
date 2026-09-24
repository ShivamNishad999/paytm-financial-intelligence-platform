import '../../core/utils/json_parsing.dart';

/// Maps the `products` block inside `GET /api/dashboard`.
class ProductSummaryModel {
  final int totalProducts;
  final int productsWithoutSales;

  const ProductSummaryModel({
    required this.totalProducts,
    required this.productsWithoutSales,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      totalProducts: asInt(json['totalProducts']),
      productsWithoutSales: asInt(json['productsWithoutSales']),
    );
  }

  factory ProductSummaryModel.empty() =>
      const ProductSummaryModel(totalProducts: 0, productsWithoutSales: 0);
}
