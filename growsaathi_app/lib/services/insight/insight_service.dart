import 'dart:math';

import '../../models/analytics/daily_sales_point_model.dart';
import '../../models/insight/customer_growth_point_model.dart';
import '../../models/insight/insight_date_range.dart';
import '../../models/insight/insight_model.dart';
import '../../models/insight/inventory_health_item_model.dart';
import '../../models/insight/product_performance_item_model.dart';
import '../../models/insight/top_customer_model.dart';

/// Mock data source for the Insights screen (Module 1). Numbers are
/// generated deterministically (seeded RNG) so the same date range
/// always looks the same across refreshes — this is demo data, not
/// randomness for its own sake. There is no live backend wiring here
/// yet: `CustomerRepository`/`SalesRepository` in `core/repositories/`
/// are the seam a real implementation would plug into later.
class InsightService {
  Future<InsightModel> getInsights(InsightDateRange range) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final days = range.days;
    final random = Random(days); // seeded — stable per range

    final salesTrend = List.generate(days, (i) {
      final date = DateTime.now().subtract(Duration(days: days - 1 - i));
      final sales = 4000 + random.nextInt(6000);
      final orders = 12 + random.nextInt(20);
      return DailySalesPointModel(date: date, sales: sales.toDouble(), orders: orders);
    });

    final customerGrowth = List.generate(min(days, 14), (i) {
      final date = DateTime.now().subtract(Duration(days: min(days, 14) - 1 - i));
      return CustomerGrowthPointModel(
        date: date,
        newCustomers: 1 + random.nextInt(6),
        repeatCustomers: 3 + random.nextInt(10),
      );
    });

    const categories = ['Grocery', 'Beverages', 'Snacks', 'Dairy', 'Personal Care'];
    final productPerformance = List.generate(8, (i) {
      return ProductPerformanceItemModel(
        productId: i + 1,
        productName: 'Product ${i + 1}',
        category: categories[i % categories.length],
        quantitySold: 5 + random.nextInt(80),
        revenue: (500 + random.nextInt(9000)).toDouble(),
      );
    })
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final inventoryHealth = [
      const InventoryHealthItemModel(productId: 1, productName: 'Rice (5kg)', stock: 8, reorderLevel: 15),
      const InventoryHealthItemModel(productId: 2, productName: 'Cooking Oil (1L)', stock: 0, reorderLevel: 10),
      const InventoryHealthItemModel(productId: 3, productName: 'Wheat Flour (5kg)', stock: 42, reorderLevel: 15),
      const InventoryHealthItemModel(productId: 4, productName: 'Sugar (1kg)', stock: 6, reorderLevel: 12),
      const InventoryHealthItemModel(productId: 5, productName: 'Tea Powder (250g)', stock: 55, reorderLevel: 20),
    ];

    const names = [
      'Rajesh Kumar', 'Priya Sharma', 'Amit Singh', 'Sunita Devi', 'Vikram Patel',
    ];
    final topCustomers = List.generate(names.length, (i) {
      return TopCustomerModel(
        customerId: i + 1,
        customerName: names[i],
        customerSegment: i < 2 ? 'LOYAL' : 'REGULAR',
        totalOrders: 20 - i * 3,
        totalSpent: (18000 - i * 2500).toDouble(),
      );
    });

    return InsightModel(
      salesTrend: salesTrend,
      customerGrowth: customerGrowth,
      productPerformance: productPerformance,
      inventoryHealth: inventoryHealth,
      bestSellingProducts: productPerformance.take(5).toList(),
      topCustomers: topCustomers,
    );
  }
}
