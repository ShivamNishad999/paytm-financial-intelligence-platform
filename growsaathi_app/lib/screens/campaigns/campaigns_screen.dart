import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_text_styles.dart';
import '../../models/campaign/campaign_model.dart';
import '../../providers/campaign_provider.dart';
import '../../widgets/cards/campaign_card.dart';
import '../../widgets/campaigns/message_preview.dart';
import '../../widgets/common/empty_state.dart';

/// Campaigns (Module 3) — local-only campaign management. No real API
/// call is made; everything lives in `campaignProvider`'s in-memory
/// state for this offline demo (see `core/repositories/campaign_repository.dart`
/// for the interface a future backend would implement).
class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  static const _tabs = ['Draft', 'Scheduled', 'Sent'];
  static const _statuses = [
    LocalCampaignStatus.draft,
    LocalCampaignStatus.scheduled,
    LocalCampaignStatus.sent,
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = ref.watch(campaignProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns'),
        bottom: TabBar(controller: _tabController, tabs: [for (final t in _tabs) Tab(text: t)]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/home/campaigns/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Campaign'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (final status in _statuses) _CampaignList(status: status, campaigns: campaigns),
        ],
      ),
    );
  }
}

class _CampaignList extends ConsumerWidget {
  const _CampaignList({required this.status, required this.campaigns});

  final LocalCampaignStatus status;
  final List<CampaignModel> campaigns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = campaigns.where((c) => c.status == status).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: EmptyState(message: 'No campaigns here yet.', icon: Icons.campaign_outlined),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => CampaignCard(
        campaign: filtered[index],
        onTap: () => _showDetail(context, ref, filtered[index]),
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref, CampaignModel campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(campaign.name, style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text('Segment: ${campaign.targetSegment} · Offer: ${campaign.offer}', style: AppTextStyles.caption),
              const SizedBox(height: 16),
              MessagePreview(channel: campaign.channel, message: campaign.message),
              const SizedBox(height: 20),
              if (campaign.status == LocalCampaignStatus.draft)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ref.read(campaignProvider.notifier).updateStatus(
                                campaign.id,
                                LocalCampaignStatus.scheduled,
                                scheduledDate: DateTime.now().add(const Duration(days: 1)),
                              );
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Schedule'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(campaignProvider.notifier).updateStatus(campaign.id, LocalCampaignStatus.sent);
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Send Now'),
                      ),
                    ),
                  ],
                )
              else if (campaign.status == LocalCampaignStatus.scheduled)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(campaignProvider.notifier).updateStatus(campaign.id, LocalCampaignStatus.sent);
                      Navigator.of(sheetContext).pop();
                    },
                    child: const Text('Send Now'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
