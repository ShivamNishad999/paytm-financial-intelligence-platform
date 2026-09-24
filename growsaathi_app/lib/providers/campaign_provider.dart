import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/campaign/campaign_model.dart';
import '../services/campaign/local_campaign_service.dart';

final localCampaignServiceProvider = Provider<LocalCampaignService>((ref) => LocalCampaignService());

class CampaignNotifier extends StateNotifier<List<CampaignModel>> {
  CampaignNotifier(this._service) : super(_service.seedCampaigns());

  final LocalCampaignService _service;
  int _counter = 0;

  void addCampaign(CampaignModel campaign) {
    state = [campaign, ...state];
  }

  void updateStatus(String id, LocalCampaignStatus status, {DateTime? scheduledDate}) {
    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(status: status, scheduledDate: scheduledDate) else c,
    ];
  }

  String nextId() {
    _counter += 1;
    return 'camp-local-${DateTime.now().millisecondsSinceEpoch}-$_counter';
  }

  // Kept for parity with LocalActionService's pattern even though this
  // notifier doesn't call it directly beyond the initial seed.
  // ignore: unused_element
  LocalCampaignService get service => _service;
}

final campaignProvider = StateNotifierProvider<CampaignNotifier, List<CampaignModel>>((ref) {
  return CampaignNotifier(ref.watch(localCampaignServiceProvider));
});
