enum CampaignChannel { whatsapp, sms }

enum LocalCampaignStatus { draft, scheduled, sent }

/// Local-only campaign model for the offline demo (Module 3). This is
/// distinct from the real backend's `Campaign` entity
/// (`/api/campaigns`, fields: campaignId, merchantId, campaignName,
/// targetSegment, offer, message, startDate, endDate, status) —
/// naming here intentionally mirrors it so a future
/// `LiveCampaignRepository` (see `core/repositories/campaign_repository.dart`)
/// can map one to the other directly.
class CampaignModel {
  final String id;
  final String name;
  final String targetSegment;
  final String offer;
  final String message;
  final CampaignChannel channel;
  final LocalCampaignStatus status;
  final DateTime? scheduledDate;
  final DateTime createdAt;

  const CampaignModel({
    required this.id,
    required this.name,
    required this.targetSegment,
    required this.offer,
    required this.message,
    required this.channel,
    required this.status,
    this.scheduledDate,
    required this.createdAt,
  });

  CampaignModel copyWith({LocalCampaignStatus? status, DateTime? scheduledDate}) {
    return CampaignModel(
      id: id,
      name: name,
      targetSegment: targetSegment,
      offer: offer,
      message: message,
      channel: channel,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      createdAt: createdAt,
    );
  }
}
