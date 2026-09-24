import 'campaign_summary_model.dart';
import 'customer_summary_model.dart';
import 'inventory_summary_model.dart';
import 'product_summary_model.dart';
import 'sales_summary_model.dart';
import '../analytics/daily_sales_point_model.dart';
import '../analytics/payment_method_summary_model.dart';
import '../recommendation/opportunity_model.dart';

/// Maps the full response of `GET /api/dashboard`
/// (backend: DashboardDataService.getDashboardData()).
///
/// NOTE — no merchant filter: the backend endpoint currently returns
/// whole-business totals (all merchants combined), not the logged-in
/// merchant's own numbers. See the backend API mapping, Section 7 #2.
/// This is called out in the UI (see DashboardScreen) rather than
/// silently presented as one merchant's data.
class DashboardDataModel {
  final SalesSummaryModel sales;
  final CustomerSummaryModel customers;
  final ProductSummaryModel products;
  final InventorySummaryModel inventory;
  final CampaignSummaryModel campaigns;
  final List<DailySalesPointModel> dailySales;
  final List<PaymentMethodSummaryModel> paymentMethods;
  final List<OpportunityModel> opportunities;

  const DashboardDataModel({
    required this.sales,
    required this.customers,
    required this.products,
    required this.inventory,
    required this.campaigns,
    required this.dailySales,
    required this.paymentMethods,
    required this.opportunities,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      sales: SalesSummaryModel.fromJson(
        Map<String, dynamic>.from(json['sales'] as Map? ?? {}),
      ),
      customers: CustomerSummaryModel.fromJson(
        Map<String, dynamic>.from(json['customers'] as Map? ?? {}),
      ),
      products: ProductSummaryModel.fromJson(
        Map<String, dynamic>.from(json['products'] as Map? ?? {}),
      ),
      inventory: InventorySummaryModel.fromJson(
        Map<String, dynamic>.from(json['inventory'] as Map? ?? {}),
      ),
      campaigns: CampaignSummaryModel.fromJson(
        Map<String, dynamic>.from(json['campaigns'] as Map? ?? {}),
      ),
      dailySales: ((json['dailySales'] as List?) ?? [])
          .map((e) => DailySalesPointModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date)),
      paymentMethods: ((json['paymentMethods'] as List?) ?? [])
          .map((e) => PaymentMethodSummaryModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      opportunities: ((json['opportunities'] as List?) ?? [])
          .map((e) => OpportunityModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  factory DashboardDataModel.empty() => DashboardDataModel(
        sales: SalesSummaryModel.empty(),
        customers: CustomerSummaryModel.empty(),
        products: ProductSummaryModel.empty(),
        inventory: InventorySummaryModel.empty(),
        campaigns: CampaignSummaryModel.empty(),
        dailySales: const [],
        paymentMethods: const [],
        opportunities: const [],
      );
}
