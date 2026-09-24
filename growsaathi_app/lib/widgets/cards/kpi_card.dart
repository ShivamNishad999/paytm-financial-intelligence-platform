import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../common/trend_indicator.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.percentChange,
    this.trendLabel,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final double? percentChange;
  final String? trendLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.brightBlue).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 16, color: iconColor ?? AppColors.brightBlue),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(value, style: AppTextStyles.kpiValue, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (percentChange != null) ...[
              const SizedBox(height: 6),
              TrendIndicator(percentChange: percentChange, label: trendLabel),
            ],
          ],
        ),
      ),
    );
  }
}
