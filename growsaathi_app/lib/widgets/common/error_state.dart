import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'primary_button.dart';

/// Friendly, non-technical error surface. Never show raw exceptions or
/// stack traces to the merchant — the message here should already be
/// one of the AppException factory messages.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.message = 'Unable to load your data right now.',
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: AppTextStyles.body),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              child: PrimaryButton(label: 'Try Again', onPressed: onRetry),
            ),
          ],
        ],
      ),
    );
  }
}
