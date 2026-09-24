import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/analytics/daily_sales_point_model.dart';
import '../common/empty_state.dart';
import '../common/section_header.dart';

/// Line chart over `dailySales[]` from `GET /api/dashboard`. The
/// backend has no "peak sales hour" or day-of-week breakdown yet
/// (see API mapping, Section 5), so only what's actually returned —
/// a daily sales total — is charted here.
class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key, required this.points, this.title = 'Sales — Last 7 Days'});

  final List<DailySalesPointModel> points;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: title),
            const SizedBox(height: 16),
            if (points.isEmpty)
              const EmptyState(message: 'No sales recorded yet.', icon: Icons.show_chart)
            else
              SizedBox(height: 180, child: _Chart(points: points)),
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.points});

  final List<DailySalesPointModel> points;

  @override
  Widget build(BuildContext context) {
    final maxY = points.map((p) => p.sales).fold<double>(0, (a, b) => a > b ? a : b);
    final safeMaxY = maxY <= 0 ? 100.0 : maxY * 1.2;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: safeMaxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: safeMaxY / 4,
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
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((spot) {
              final point = points[spot.x.toInt()];
              return LineTooltipItem(
                Formatters.compactCurrency(point.sales),
                AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: AppColors.brightBlue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: AppColors.lightBlue),
            spots: [
              for (int i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].sales),
            ],
          ),
        ],
      ),
    );
  }
}
