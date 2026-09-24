/// Every path here is copied verbatim from the backend API mapping
/// (Spring Boot `growsaathi` project). Do not invent new paths —
/// add a new constant only once it has been confirmed against the
/// backend source or with the backend owner.
///
/// Base URL is configured separately in [AppConfig] since it changes
/// per environment (emulator localhost, staging, prod); paths here
/// are always relative to it.
class ApiEndpoints {
  ApiEndpoints._();

  // ---------------------------------------------------------------
  // Dashboard (Phase 1)
  // ---------------------------------------------------------------

  /// GET — single call covering KPIs, daily/monthly sales, payment
  /// methods and opportunities. Primary source for the Home screen.
  static const String dashboard = '/api/dashboard';

  /// GET — smaller summary DTO (totalSales, totalOrders, totalCustomers,
  /// totalProducts, lowStockProducts, totalCampaigns, campaignRevenue).
  /// Kept as a documented fallback / lighter-weight alternative.
  static const String dashboardSummary = '/api/dashboard/summary';

  static const String businessInsights = '/api/business-insights';

  // ---------------------------------------------------------------
  // Sales
  // ---------------------------------------------------------------

  static const String salesInsights = '/api/sales-insights';
  static const String salesTrend = '/api/sales/trend';
  static const String salesDaily = '/api/sales/daily';
  static const String salesMonthly = '/api/sales/monthly';
  static const String paymentMethods = '/api/payment-methods';

  // ---------------------------------------------------------------
  // Recommendations / Insights / Opportunities (rule-based, not LLM —
  // see the backend AI reality check)
  // ---------------------------------------------------------------

  static const String aiInsights = '/api/ai-insights';

  /// Canonical recommendations source for MVP, per product decision —
  /// `/api/recommendations` overlaps with this one and is not used.
  static const String aiRecommendations = '/api/ai-recommendations';
  static const String opportunities = '/api/opportunities';

  // ---------------------------------------------------------------
  // Merchant (used later for Profile; kept here for completeness)
  // ---------------------------------------------------------------

  static const String merchants = '/api/merchants';
}
