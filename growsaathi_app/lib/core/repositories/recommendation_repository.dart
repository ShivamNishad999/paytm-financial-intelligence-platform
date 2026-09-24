import '../../models/actions/action_item_model.dart';

/// Backend-ready contract for recommendations / actions.
/// The real Spring Boot backend today only exposes read-only
/// recommendation strings (`/api/ai-recommendations`) with no id or
/// status — see the backend API mapping. `LocalActionService`
/// (Module 2) fills that gap with a locally-tracked status until a
/// backend `Action` entity exists; this interface is what a future
/// `LiveRecommendationRepository` would implement once it does.
abstract class RecommendationRepository {
  Future<List<ActionItemModel>> getActions();
  Future<ActionItemModel> updateActionStatus(String id, ActionStatus status);
}
