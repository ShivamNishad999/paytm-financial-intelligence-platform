import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/insight/customer_growth_point_model.dart';
import '../common/empty_state.dart';
import '../common/section_header.dart';

/// Stacked bar chart: new vs. repeat customers per day.
/// Mock data only (Module 1) — see `InsightService`.
class CustomerGrowthChartCard extends StatelessWidget {
  const CustomerGrowthChartCard({super.key, required this.points});

  final List<CustomerGrowthPointModel> points;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Customer Growth'),
            const SizedBox(height: 4),
            Row(
              children: const [
                _LegendDot(color: AppColors.brightBlue, label: 'New'),
                SizedBox(width: 16),
                _LegendDot(color: AppColors.navy, label: 'Repeat'),
              ],
            ),
            const SizedBox(height: 12),
            if (points.isEmpty)
              const EmptyState(message: 'No customer activity yet.', icon: Icons.groups_outlined)
            else
              SizedBox(height: 180, child: _Chart(points: points)),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.points});

  final List<CustomerGrowthPointModel> points;

  @override
  Widget build(BuildContext context) {
    final maxY = points.map((p) => p.total).fold<int>(0, (a, b) => a > b ? a : b);
    final safeMaxY = (maxY <= 0 ? 10 : (maxY * 1.3).ceil()).toDouble();

    return BarChart(
      BarChartData(
        maxY: safeMaxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.divider, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(Formatters.weekday(points[index].date), style: AppTextStyles.caption),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (int i = 0; i < points.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: points[i].total.toDouble(),
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
                  rodStackItems: [
                    BarChartRodStackItem(0, points[i].newCustomers.toDouble(), AppColors.brightBlue),
                    BarChartRodStackItem(
                      points[i].newCustomers.toDouble(),
                      points[i].total.toDouble(),
                      AppColors.navy,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
