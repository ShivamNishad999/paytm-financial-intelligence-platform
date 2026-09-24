import '../../models/actions/action_item_model.dart';

/// Local, in-memory seed data for the Action Center (Module 2).
/// Implements the read half of `RecommendationRepository`'s intent —
/// status updates are handled by `ActionNotifier` directly since
/// there's nowhere real to persist them to yet.
class LocalActionService {
  List<ActionItemModel> seedActions() {
    final now = DateTime.now();
    return [
      ActionItemModel(
        id: 'act-1',
        title: 'Contact inactive customers',
        description: '18 customers haven’t purchased in the last 30 days. Reaching out now could win them back before they churn.',
        priority: ActionPriority.high,
        type: ActionType.customer,
        status: ActionStatus.pending,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      ActionItemModel(
        id: 'act-2',
        title: 'Restock low inventory',
        description: 'Rice and Sugar are close to reorder level. Restocking now avoids a stockout during the coming week.',
        priority: ActionPriority.high,
        type: ActionType.inventory,
        status: ActionStatus.pending,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      ActionItemModel(
        id: 'act-3',
        title: 'Increase fast-selling item stock',
        description: 'Cooking Oil is selling faster than usual this week. Increasing the reorder quantity reduces the risk of running out.',
        priority: ActionPriority.medium,
        type: ActionType.product,
        status: ActionStatus.pending,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      ActionItemModel(
        id: 'act-4',
        title: 'Follow up on pending payments',
        description: '3 transactions are marked pending for more than 2 days. A quick follow-up can recover this revenue.',
        priority: ActionPriority.medium,
        type: ActionType.payment,
        status: ActionStatus.approved,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ActionItemModel(
        id: 'act-5',
        title: 'Promote unsold products',
        description: '7 products have no recorded sales this month. A bundle offer could help them move.',
        priority: ActionPriority.low,
        type: ActionType.product,
        status: ActionStatus.completed,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}
