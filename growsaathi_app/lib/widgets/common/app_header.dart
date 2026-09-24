import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/merchant/merchant_model.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.merchant,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  final MerchantModel? merchant;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final name = merchant?.merchantName.split(' ').first ?? 'there';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_greeting()}, $name', style: AppTextStyles.h2),
              const SizedBox(height: 2),
              Text(
                "Here's what's happening with your business today.",
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotificationsTap,
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.lightBlue,
            child: Icon(Icons.person, color: AppColors.navy),
          ),
        ),
      ],
    );
  }
}
