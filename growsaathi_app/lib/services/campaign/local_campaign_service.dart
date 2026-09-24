import '../../models/campaign/campaign_model.dart';

/// Local, in-memory campaign store for the offline demo (Module 3).
/// No real API call is made — implements the shape of
/// `CampaignRepository` (`core/repositories/campaign_repository.dart`)
/// so a real backend-backed implementation can replace it later
/// without changing the Campaigns screen or provider.
class LocalCampaignService {
  List<CampaignModel> seedCampaigns() {
    final now = DateTime.now();
    return [
      CampaignModel(
        id: 'camp-1',
        name: 'Win-Back Offer',
        targetSegment: 'AT_RISK',
        offer: '15% off next purchase',
        message: 'We miss you! Come back and enjoy 15% off your next purchase this week.',
        channel: CampaignChannel.whatsapp,
        status: LocalCampaignStatus.sent,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      CampaignModel(
        id: 'camp-2',
        name: 'Festive Bundle Promo',
        targetSegment: 'LOYAL',
        offer: 'Buy 2 Get 1 Free',
        message: 'Celebrate the season with our Buy 2 Get 1 Free bundle — today only!',
        channel: CampaignChannel.sms,
        status: LocalCampaignStatus.scheduled,
        scheduledDate: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      CampaignModel(
        id: 'camp-3',
        name: 'New Product Launch',
        targetSegment: 'CAMPAIGN_TARGETS',
        offer: 'Early access discount',
        message: 'Be the first to try our new arrivals with an exclusive early-access discount.',
        channel: CampaignChannel.whatsapp,
        status: LocalCampaignStatus.draft,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }
}
