import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

enum BadgeTone { neutral, positive, negative, warning, info }

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.tone = BadgeTone.neutral});

  final String label;
  final BadgeTone tone;

  Color get _bg {
    switch (tone) {
      case BadgeTone.positive:
        return AppColors.green.withOpacity(0.12);
      case BadgeTone.negative:
        return AppColors.red.withOpacity(0.12);
      case BadgeTone.warning:
        return AppColors.orange.withOpacity(0.14);
      case BadgeTone.info:
        return AppColors.purple.withOpacity(0.12);
      case BadgeTone.neutral:
        return AppColors.lightBlue;
    }
  }

  Color get _fg {
    switch (tone) {
      case BadgeTone.positive:
        return AppColors.green;
      case BadgeTone.negative:
        return AppColors.red;
      case BadgeTone.warning:
        return AppColors.orange;
      case BadgeTone.info:
        return AppColors.purple;
      case BadgeTone.neutral:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: _fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
