import '../../models/campaign/campaign_model.dart';

/// Backend-ready contract for campaigns. Today `LocalCampaignService`
/// is the only implementation (in-memory / local, no real API — see
/// Module 3). A future backend swap adds a `LiveCampaignRepository`
/// here without touching the Campaigns screen or provider shape.
abstract class CampaignRepository {
  Future<List<CampaignModel>> getCampaigns();
  Future<CampaignModel> createCampaign(CampaignModel campaign);
  Future<CampaignModel> updateCampaign(CampaignModel campaign);
  Future<void> deleteCampaign(String id);
}
