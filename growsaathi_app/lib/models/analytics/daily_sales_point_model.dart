import '../../core/utils/json_parsing.dart';

/// Maps one entry of `dailySales[]` inside `GET /api/dashboard`
/// (backend: DailySalesService.getDailySales() — date, sales, orders).
class DailySalesPointModel {
  final DateTime date;
  final double sales;
  final int orders;

  const DailySalesPointModel({
    required this.date,
    required this.sales,
    required this.orders,
  });

  factory DailySalesPointModel.fromJson(Map<String, dynamic> json) {
    return DailySalesPointModel(
      date: asDateTime(json['date']) ?? DateTime.now(),
      sales: asDouble(json['sales']),
      orders: asInt(json['orders']),
    );
  }
}
