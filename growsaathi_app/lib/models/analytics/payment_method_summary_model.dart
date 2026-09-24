import '../../core/utils/json_parsing.dart';

/// Maps one entry of `paymentMethods[]` inside `GET /api/dashboard`
/// (backend: PaymentMethodService.getPaymentMethodSummary()).
class PaymentMethodSummaryModel {
  final String paymentMethod;
  final int transactionCount;
  final double totalAmount;

  const PaymentMethodSummaryModel({
    required this.paymentMethod,
    required this.transactionCount,
    required this.totalAmount,
  });

  factory PaymentMethodSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodSummaryModel(
      paymentMethod: asString(json['paymentMethod'], 'UNKNOWN'),
      transactionCount: asInt(json['transactionCount']),
      totalAmount: asDouble(json['totalAmount']),
    );
  }
}
