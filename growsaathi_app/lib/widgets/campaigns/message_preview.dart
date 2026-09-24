import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/campaign/campaign_model.dart';

/// Renders a chat-bubble-style preview of the campaign message —
/// green WhatsApp-style bubble or a plain SMS bubble. Preview only;
/// no message is actually sent (per the brief: "Do not actually send
/// SMS/WhatsApp/email unless a real integration exists").
class MessagePreview extends StatelessWidget {
  const MessagePreview({super.key, required this.channel, required this.message});

  final CampaignChannel channel;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isWhatsapp = channel == CampaignChannel.whatsapp;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isWhatsapp ? const Color(0xFFE7F9EF) : AppColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isWhatsapp ? Icons.chat_bubble_outline : Icons.sms_outlined,
                size: 16,
                color: isWhatsapp ? AppColors.green : AppColors.brightBlue,
              ),
              const SizedBox(width: 6),
              Text(
                isWhatsapp ? 'WhatsApp Preview' : 'SMS Preview',
                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.isEmpty ? 'Your message will appear here.' : message,
                style: AppTextStyles.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
