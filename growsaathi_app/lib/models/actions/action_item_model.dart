enum ActionPriority { high, medium, low }

enum ActionStatus { pending, approved, completed, dismissed }

enum ActionType { customer, inventory, product, payment }

/// A trackable recommendation — the piece the real backend is missing
/// (see the backend API mapping, Section 7 #5/#6: `/api/ai-recommendations`
/// only returns plain strings with no id or status). This model and
/// `LocalActionService` fill that gap locally until a backend `Action`
/// entity exists; `RecommendationRepository` in `core/repositories/` is
/// the seam a real implementation would plug into.
class ActionItemModel {
  final String id;
  final String title;
  final String description;
  final ActionPriority priority;
  final ActionType type;
  final ActionStatus status;
  final DateTime createdAt;

  const ActionItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  ActionItemModel copyWith({ActionStatus? status}) {
    return ActionItemModel(
      id: id,
      title: title,
      description: description,
      priority: priority,
      type: type,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
