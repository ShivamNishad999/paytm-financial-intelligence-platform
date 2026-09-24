import '../../core/utils/json_parsing.dart';

/// Maps the `campaigns` block inside `GET /api/dashboard`.
class CampaignSummaryModel {
  final int totalCampaigns;
  final int activeCampaigns;
  final double campaignRevenue;

  const CampaignSummaryModel({
    required this.totalCampaigns,
    required this.activeCampaigns,
    required this.campaignRevenue,
  });

  factory CampaignSummaryModel.fromJson(Map<String, dynamic> json) {
    return CampaignSummaryModel(
      totalCampaigns: asInt(json['totalCampaigns']),
      activeCampaigns: asInt(json['activeCampaigns']),
      campaignRevenue: asDouble(json['campaignRevenue']),
    );
  }

  factory CampaignSummaryModel.empty() => const CampaignSummaryModel(
        totalCampaigns: 0,
        activeCampaigns: 0,
        campaignRevenue: 0,
      );
}
