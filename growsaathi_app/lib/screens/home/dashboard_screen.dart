import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/live_api_status.dart';
import '../../core/utils/formatters.dart';
import '../../models/dashboard/dashboard_data_model.dart';
import '../../providers/app_mode_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/cards/kpi_card.dart';
import '../../widgets/cards/opportunity_card.dart';
import '../../widgets/charts/sales_chart_card.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/common/loading_state.dart';
import '../../widgets/common/section_header.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final merchant = ref.watch(authProvider).merchant;
    final appMode = ref.watch(appModeProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(dashboardProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            children: [
              AppHeader(
                merchant: merchant,
                onNotificationsTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications are coming in a later update.')),
                  );
                },
                onProfileTap: () {},
              ),
              const SizedBox(height: 12),
              _ModeBanner(appMode: appMode),
              const SizedBox(height: 16),
              dashboardAsync.when(
                data: (data) => _DashboardBody(data: data),
                loading: () => const _DashboardSkeleton(),
                error: (error, _) => ErrorState(
                  message: 'Unable to load your insights right now. Please try again.',
                  onRetry: () => ref.invalidate(dashboardProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeBanner extends ConsumerWidget {
  const _ModeBanner({required this.appMode});

  final AppMode appMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDemo = appMode == AppMode.demo;
    final liveStatus = ref.watch(liveApiStatusProvider);
    final isFallback = !isDemo && liveStatus == LiveApiStatus.fallback;

    final Color bg;
    final Color fg;
    final IconData icon;
    final String message;

    if (isFallback) {
      bg = AppColors.actionSurface;
      fg = AppColors.red;
      icon = Icons.cloud_off_outlined;
      message = 'Live API unreachable — showing demo data instead. Tap to switch to Demo Mode.';
    } else if (isDemo) {
      bg = AppColors.actionSurface;
      fg = AppColors.orange;
      icon = Icons.science_outlined;
      message = 'Demo Mode — showing sample data. Tap to switch to Live API.';
    } else {
      bg = AppColors.aiSurface;
      fg = AppColors.purple;
      icon = Icons.cloud_done_outlined;
      message = 'Live API Mode — data reflects all merchants (no per-merchant login yet). Tap to switch to Demo.';
    }

    return GestureDetector(
      onTap: () => ref.read(appModeProvider.notifier).toggle(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: AppTextStyles.caption)),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.data});

  final DashboardDataModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            KpiCard(
              label: 'Total Sales',
              value: Formatters.compactCurrency(data.sales.totalSales),
              icon: Icons.payments_outlined,
              iconColor: AppColors.green,
            ),
            KpiCard(
              label: 'Transactions',
              value: data.sales.totalOrders.toString(),
              icon: Icons.receipt_long_outlined,
              iconColor: AppColors.brightBlue,
            ),
            KpiCard(
              label: 'Customers',
              value: data.customers.totalCustomers.toString(),
              icon: Icons.people_alt_outlined,
              iconColor: AppColors.navy,
            ),
            KpiCard(
              label: 'Items / Products',
              value: data.products.totalProducts.toString(),
              icon: Icons.inventory_2_outlined,
              iconColor: AppColors.orange,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SalesChartCard(points: data.dailySales),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Quick Insights'),
        const SizedBox(height: 12),
        if (data.opportunities.isEmpty)
          const EmptyState(message: 'No insights yet — keep recording sales to unlock them.')
        else
          ...data.opportunities
              .take(2)
              .map<Widget>((o) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OpportunityCard(opportunity: o),
                  ))
              ,
        const SizedBox(height: 8),
        SectionHeader(
          title: 'AI Recommendations',
          actionLabel: 'View All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        if (data.opportunities.isEmpty)
          const EmptyState(message: 'Recommendations will appear as business activity grows.')
        else
          ...data.opportunities
              .skip(2)
              .take(2)
              .map<Widget>((o) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OpportunityCard(opportunity: o),
                  ))
              ,
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text('View All Insights & Recommendations'),
          ),
        ),
      ],
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: const [
            LoadingState(),
            LoadingState(),
            LoadingState(),
            LoadingState(),
          ],
        ),
        const SizedBox(height: 20),
        const LoadingState(height: 220),
        const SizedBox(height: 20),
        const LoadingState(height: 90),
        const SizedBox(height: 12),
        const LoadingState(height: 90),
      ],
    );
  }
}
