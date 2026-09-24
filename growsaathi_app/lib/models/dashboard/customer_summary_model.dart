import '../../core/utils/json_parsing.dart';

/// Maps the `customers` block inside `GET /api/dashboard`.
class CustomerSummaryModel {
  final int totalCustomers;
  final int atRiskCustomers;

  const CustomerSummaryModel({
    required this.totalCustomers,
    required this.atRiskCustomers,
  });

  factory CustomerSummaryModel.fromJson(Map<String, dynamic> json) {
    return CustomerSummaryModel(
      totalCustomers: asInt(json['totalCustomers']),
      atRiskCustomers: asInt(json['atRiskCustomers']),
    );
  }

  factory CustomerSummaryModel.empty() =>
      const CustomerSummaryModel(totalCustomers: 0, atRiskCustomers: 0);
}
