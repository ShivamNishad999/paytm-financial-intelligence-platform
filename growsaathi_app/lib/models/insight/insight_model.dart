import '../analytics/daily_sales_point_model.dart';
import 'customer_growth_point_model.dart';
import 'inventory_health_item_model.dart';
import 'product_performance_item_model.dart';
import 'top_customer_model.dart';

/// Everything the Insights screen renders, for one date range.
/// Aggregates the sub-models rather than one flat map, so each section
/// (Sales, Customers, Products, Inventory) can be swapped for a real
/// endpoint independently later (see the repository interfaces in
/// `core/repositories/`).
class InsightModel {
  final List<DailySalesPointModel> salesTrend;
  final List<CustomerGrowthPointModel> customerGrowth;
  final List<ProductPerformanceItemModel> productPerformance;
  final List<InventoryHealthItemModel> inventoryHealth;
  final List<ProductPerformanceItemModel> bestSellingProducts;
  final List<TopCustomerModel> topCustomers;

  const InsightModel({
    required this.salesTrend,
    required this.customerGrowth,
    required this.productPerformance,
    required this.inventoryHealth,
    required this.bestSellingProducts,
    required this.topCustomers,
  });

  double get totalSales => salesTrend.fold(0.0, (sum, p) => sum + p.sales);
  int get totalOrders => salesTrend.fold(0, (sum, p) => sum + p.orders);
  int get lowStockCount =>
      inventoryHealth.where((i) => i.status == InventoryHealthStatus.low).length;
  int get outOfStockCount =>
      inventoryHealth.where((i) => i.status == InventoryHealthStatus.outOfStock).length;

  bool get isEmpty =>
      salesTrend.isEmpty &&
      customerGrowth.isEmpty &&
      productPerformance.isEmpty &&
      inventoryHealth.isEmpty;

  factory InsightModel.empty() => const InsightModel(
        salesTrend: [],
        customerGrowth: [],
        productPerformance: [],
        inventoryHealth: [],
        bestSellingProducts: [],
        topCustomers: [],
      );
}
