import '../../core/utils/json_parsing.dart';

/// Maps the `sales` block inside `GET /api/dashboard`.
/// Backend source: DashboardDataService.getDashboardData() -> "sales".
class SalesSummaryModel {
  final double totalSales;
  final int totalOrders;
  final double averageOrderValue;

  const SalesSummaryModel({
    required this.totalSales,
    required this.totalOrders,
    required this.averageOrderValue,
  });

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryModel(
      totalSales: asDouble(json['totalSales']),
      totalOrders: asInt(json['totalOrders']),
      averageOrderValue: asDouble(json['averageOrderValue']),
    );
  }

  factory SalesSummaryModel.empty() => const SalesSummaryModel(
        totalSales: 0,
        totalOrders: 0,
        averageOrderValue: 0,
      );
}
