import '../../models/dashboard/sales_summary_model.dart';
import '../../models/analytics/daily_sales_point_model.dart';

/// Backend-ready contract for sales data. Today this is implemented
/// only by mock/local sources (see `services/insight/insight_service.dart`
/// and `services/dashboard/dashboard_service.dart`); a future backend
/// (Spring Boot today, or any replacement API) plugs in by adding a
/// `LiveSalesRepository implements SalesRepository` and swapping the
/// provider — no screen changes required.
abstract class SalesRepository {
  Future<SalesSummaryModel> getSalesSummary();
  Future<List<DailySalesPointModel>> getSalesTrend({DateTime? from, DateTime? to});
}
