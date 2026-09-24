import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Shared placeholder for bottom-nav tabs not yet built in this phase
/// (Insights, Actions, Campaigns, More). Keeps the navigation shell
/// complete per the brief's spec while making it obvious to reviewers
/// that these are intentionally out of scope for Phase 1, not bugs.
class UnderConstructionScreen extends StatelessWidget {
  const UnderConstructionScreen({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_outlined, size: 40, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(
                'Coming in a later phase',
                style: AppTextStyles.sectionTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(description, style: AppTextStyles.caption, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
