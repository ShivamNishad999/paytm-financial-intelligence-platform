import '../../core/utils/json_parsing.dart';

/// One point on the Insights screen's customer-growth chart:
/// how many new vs. repeat customers transacted on [date].
/// Mock-data only for now (see `services/insight/insight_service.dart`) —
/// the real backend has no endpoint that buckets customers by day yet.
class CustomerGrowthPointModel {
  final DateTime date;
  final int newCustomers;
  final int repeatCustomers;

  const CustomerGrowthPointModel({
    required this.date,
    required this.newCustomers,
    required this.repeatCustomers,
  });

  factory CustomerGrowthPointModel.fromJson(Map<String, dynamic> json) {
    return CustomerGrowthPointModel(
      date: asDateTime(json['date']) ?? DateTime.now(),
      newCustomers: asInt(json['newCustomers']),
      repeatCustomers: asInt(json['repeatCustomers']),
    );
  }

  int get total => newCustomers + repeatCustomers;
}
