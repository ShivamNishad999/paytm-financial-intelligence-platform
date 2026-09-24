import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/recommendation/opportunity_model.dart';
import '../common/status_badge.dart';

/// Renders one `OpportunityModel` — used for both the Home screen's
/// "Quick insight" cards and the "AI recommendation preview" section,
/// since the backend's single `/api/opportunities` shape already
/// carries a message + suggested action for each.
///
/// Per the AI reality check: no expected-impact number is shown
/// because the backend supplies none — this avoids the brief's
/// explicit warning against inventing one.
class OpportunityCard extends StatelessWidget {
  const OpportunityCard({super.key, required this.opportunity});

  final OpportunityModel opportunity;

  IconData get _icon {
    switch (opportunity.type) {
      case 'CUSTOMER_RETENTION':
        return Icons.people_alt_outlined;
      case 'INVENTORY_ALERT':
        return Icons.inventory_2_outlined;
      case 'PRODUCT_OPPORTUNITY':
        return Icons.trending_up_rounded;
      case 'MARKETING_OPPORTUNITY':
        return Icons.campaign_outlined;
      case 'REVENUE_GROWTH':
        return Icons.payments_outlined;
      default:
        return Icons.lightbulb_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.aiSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon, size: 18, color: AppColors.purple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    opportunity.message,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                StatusBadge(
                  label: opportunity.priority,
                  tone: opportunity.isHighPriority ? BadgeTone.negative : BadgeTone.warning,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.purple),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(opportunity.action, style: AppTextStyles.caption),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
