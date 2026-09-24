import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/formatters.dart';
import '../../models/insight/insight_date_range.dart';
import '../../providers/insight_provider.dart';
import '../../widgets/cards/inventory_health_card.dart';
import '../../widgets/cards/kpi_card.dart';
import '../../widgets/cards/ranked_list_card.dart';
import '../../widgets/charts/customer_growth_chart_card.dart';
import '../../widgets/charts/sales_chart_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/common/loading_state.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightAsync = ref.watch(insightProvider);
    final selectedRange = ref.watch(insightDateRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(insightProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(insightProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: InsightDateRange.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final range = InsightDateRange.values[index];
                    final selected = range == selectedRange;
                    return ChoiceChip(
                      label: Text(range.label),
                      selected: selected,
                      onSelected: (_) => ref.read(insightDateRangeProvider.notifier).state = range,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              insightAsync.when(
                data: (insight) {
                  if (insight.isEmpty) {
                    return const EmptyState(
                      message: 'No business activity recorded for this period yet.',
                      icon: Icons.insights_outlined,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: KpiCard(
                              label: 'Total Sales',
                              value: Formatters.compactCurrency(insight.totalSales),
                              icon: Icons.payments_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: KpiCard(
                              label: 'Total Orders',
                              value: insight.totalOrders.toString(),
                              icon: Icons.receipt_long_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SalesChartCard(points: insight.salesTrend, title: 'Sales — ${selectedRange.label}'),
                      const SizedBox(height: 16),
                      CustomerGrowthChartCard(points: insight.customerGrowth),
                      const SizedBox(height: 16),
                      InventoryHealthCard(items: insight.inventoryHealth),
                      const SizedBox(height: 16),
                      RankedListCard(
                        title: 'Best-Selling Products',
                        icon: Icons.trending_up_rounded,
                        emptyMessage: 'No product sales recorded yet.',
                        items: insight.bestSellingProducts
                            .map((p) => RankedListItem(
                                  title: p.productName,
                                  subtitle: p.category,
                                  trailingValue: Formatters.compactCurrency(p.revenue),
                                  trailingSubValue: '${p.quantitySold} sold',
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      RankedListCard(
                        title: 'Top Customers',
                        icon: Icons.people_alt_outlined,
                        emptyMessage: 'No customer purchases recorded yet.',
                        items: insight.topCustomers
                            .map((c) => RankedListItem(
                                  title: c.customerName,
                                  subtitle: c.customerSegment,
                                  trailingValue: Formatters.compactCurrency(c.totalSpent),
                                  trailingSubValue: '${c.totalOrders} orders',
                                ))
                            .toList(),
                      ),
                    ],
                  );
                },
                loading: () => const Column(
                  children: [
                    LoadingState(height: 200),
                    SizedBox(height: 16),
                    LoadingState(height: 200),
                    SizedBox(height: 16),
                    LoadingState(height: 160),
                  ],
                ),
                error: (error, _) => ErrorState(
                  message: 'Unable to load your insights right now. Please try again.',
                  onRetry: () => ref.invalidate(insightProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
