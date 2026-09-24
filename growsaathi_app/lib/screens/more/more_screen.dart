import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/live_api_status.dart';
import '../../providers/app_mode_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';

/// Kept minimal for Phase 1 — just enough to see the merchant's mock
/// profile, flip Demo/Live mode, and log out to re-test the login
/// flow. Full Profile/Settings screens are a later phase.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchant = ref.watch(authProvider).merchant;
    final appMode = ref.watch(appModeProvider);
    final liveStatus = ref.watch(liveApiStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.lightBlue,
                    child: Icon(Icons.person, color: AppColors.navy),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(merchant?.merchantName ?? 'Merchant', style: AppTextStyles.sectionTitle),
                        Text(
                          '${merchant?.businessType ?? ''} · ${merchant?.city ?? ''}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              title: const Text('Live API Mode'),
              subtitle: Text(
                appMode == AppMode.live
                    ? (liveStatus == LiveApiStatus.fallback
                        ? 'Backend unreachable — falling back to demo data'
                        : 'Reading from the Spring Boot backend')
                    : 'Showing sample demo data',
                style: AppTextStyles.caption.copyWith(
                  color: liveStatus == LiveApiStatus.fallback ? AppColors.red : AppColors.textSecondary,
                ),
              ),
              value: appMode == AppMode.live,
              onChanged: (_) => ref.read(appModeProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About GrowSAATHI'),
                  subtitle: const Text(AppConstants.appTagline),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: const Text('Help'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
