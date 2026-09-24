import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../models/campaign/campaign_model.dart';
import '../../../providers/campaign_provider.dart';
import '../../../widgets/campaigns/message_preview.dart';
import '../../../widgets/common/primary_button.dart';

const _segments = ['AT_RISK', 'LOYAL', 'INACTIVE', 'HIGH_VALUE', 'CAMPAIGN_TARGETS'];

class CreateCampaignScreen extends ConsumerStatefulWidget {
  const CreateCampaignScreen({super.key});

  @override
  ConsumerState<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends ConsumerState<CreateCampaignScreen> {
  final _nameController = TextEditingController();
  final _offerController = TextEditingController();
  final _messageController = TextEditingController();
  String _segment = _segments.first;
  CampaignChannel _channel = CampaignChannel.whatsapp;

  @override
  void dispose() {
    _nameController.dispose();
    _offerController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  bool get _canSaveDraft => _nameController.text.trim().isNotEmpty;

  void _saveDraft() {
    final notifier = ref.read(campaignProvider.notifier);
    final campaign = CampaignModel(
      id: notifier.nextId(),
      name: _nameController.text.trim(),
      targetSegment: _segment,
      offer: _offerController.text.trim().isEmpty ? 'Special offer' : _offerController.text.trim(),
      message: _messageController.text.trim().isEmpty
          ? 'Hi! We have something special for you this week.'
          : _messageController.text.trim(),
      channel: _channel,
      status: LocalCampaignStatus.draft,
      createdAt: DateTime.now(),
    );
    notifier.addCampaign(campaign);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Campaign')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text('Campaign name', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'e.g. Weekend Special'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 18),
            Text('Customer segment', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _segment,
              decoration: const InputDecoration(),
              items: [for (final s in _segments) DropdownMenuItem(value: s, child: Text(s))],
              onChanged: (value) => setState(() => _segment = value ?? _segment),
            ),
            const SizedBox(height: 18),
            Text('Offer', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _offerController,
              decoration: const InputDecoration(hintText: 'e.g. 10% off, Buy 1 Get 1'),
            ),
            const SizedBox(height: 18),
            Text('Channel', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            SegmentedButton<CampaignChannel>(
              segments: const [
                ButtonSegment(value: CampaignChannel.whatsapp, label: Text('WhatsApp'), icon: Icon(Icons.chat_bubble_outline)),
                ButtonSegment(value: CampaignChannel.sms, label: Text('SMS'), icon: Icon(Icons.sms_outlined)),
              ],
              selected: {_channel},
              onSelectionChanged: (selection) => setState(() => _channel = selection.first),
            ),
            const SizedBox(height: 18),
            Text('Message', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Write the message customers will receive'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            MessagePreview(channel: _channel, message: _messageController.text.trim()),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save as Draft',
              onPressed: _canSaveDraft ? _saveDraft : null,
            ),
          ],
        ),
      ),
    );
  }
}
