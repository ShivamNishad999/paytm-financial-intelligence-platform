import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Small up/down arrow + percentage used on KPI cards.
/// NOTE: the backend does not currently return a period-over-period
/// delta anywhere (Section 4 of the API mapping) — pass `null` for
/// [percentChange] until a comparison endpoint exists; this widget
/// then renders nothing rather than a fabricated number.
class TrendIndicator extends StatelessWidget {
  const TrendIndicator({super.key, this.percentChange, this.label});

  final double? percentChange;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (percentChange == null) return const SizedBox.shrink();

    final isPositive = percentChange! >= 0;
    final color = isPositive ? AppColors.positive : AppColors.negative;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          '${percentChange!.abs().toStringAsFixed(0)}%${label != null ? ' $label' : ''}',
          style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
