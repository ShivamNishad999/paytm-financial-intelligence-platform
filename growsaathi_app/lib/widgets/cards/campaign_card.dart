import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/campaign/campaign_model.dart';
import '../common/status_badge.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({super.key, required this.campaign, this.onTap});

  final CampaignModel campaign;
  final VoidCallback? onTap;

  (String, BadgeTone) get _statusMeta {
    switch (campaign.status) {
      case LocalCampaignStatus.draft:
        return ('Draft', BadgeTone.neutral);
      case LocalCampaignStatus.scheduled:
        return ('Scheduled', BadgeTone.warning);
      case LocalCampaignStatus.sent:
        return ('Sent', BadgeTone.positive);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusTone) = _statusMeta;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    campaign.channel == CampaignChannel.whatsapp ? Icons.chat_bubble_outline : Icons.sms_outlined,
                    size: 18,
                    color: AppColors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(campaign.name, style: AppTextStyles.bodyMedium)),
                  StatusBadge(label: statusLabel, tone: statusTone),
                ],
              ),
              const SizedBox(height: 8),
              Text('Segment: ${campaign.targetSegment} · Offer: ${campaign.offer}', style: AppTextStyles.caption),
              if (campaign.scheduledDate != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Scheduled for ${Formatters.fullDate(campaign.scheduledDate!)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.orange),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
