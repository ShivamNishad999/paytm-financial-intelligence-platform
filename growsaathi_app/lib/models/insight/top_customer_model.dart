import '../../core/utils/json_parsing.dart';

/// Mirrors the shape of the real `CustomerInsightDTO`
/// (`GET /api/customer-insights`) so this model can be pointed at the
/// live endpoint later without changing its fields.
class TopCustomerModel {
  final int customerId;
  final String customerName;
  final String customerSegment;
  final int totalOrders;
  final double totalSpent;

  const TopCustomerModel({
    required this.customerId,
    required this.customerName,
    required this.customerSegment,
    required this.totalOrders,
    required this.totalSpent,
  });

  factory TopCustomerModel.fromJson(Map<String, dynamic> json) {
    return TopCustomerModel(
      customerId: asInt(json['customerId']),
      customerName: asString(json['customerName'], 'Customer'),
      customerSegment: asString(json['customerSegment'], 'REGULAR'),
      totalOrders: asInt(json['totalOrders']),
      totalSpent: asDouble(json['totalSpent']),
    );
  }
}
