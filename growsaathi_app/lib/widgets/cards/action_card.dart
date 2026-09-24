import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/actions/action_item_model.dart';
import '../common/status_badge.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.action,
    this.onApprove,
    this.onComplete,
    this.onDismiss,
  });

  final ActionItemModel action;
  final VoidCallback? onApprove;
  final VoidCallback? onComplete;
  final VoidCallback? onDismiss;

  (String, BadgeTone) get _priorityMeta {
    switch (action.priority) {
      case ActionPriority.high:
        return ('HIGH', BadgeTone.negative);
      case ActionPriority.medium:
        return ('MEDIUM', BadgeTone.warning);
      case ActionPriority.low:
        return ('LOW', BadgeTone.neutral);
    }
  }

  IconData get _typeIcon {
    switch (action.type) {
      case ActionType.customer:
        return Icons.people_alt_outlined;
      case ActionType.inventory:
        return Icons.inventory_2_outlined;
      case ActionType.product:
        return Icons.trending_up_rounded;
      case ActionType.payment:
        return Icons.payments_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (priorityLabel, priorityTone) = _priorityMeta;

    return Card(
      color: AppColors.actionSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_typeIcon, size: 18, color: AppColors.orange),
                const SizedBox(width: 8),
                Expanded(child: Text(action.title, style: AppTextStyles.bodyMedium)),
                StatusBadge(label: priorityLabel, tone: priorityTone),
              ],
            ),
            const SizedBox(height: 8),
            Text(action.description, style: AppTextStyles.caption),
            const SizedBox(height: 12),
            _ActionRow(status: action.status, onApprove: onApprove, onComplete: onComplete, onDismiss: onDismiss),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.status, this.onApprove, this.onComplete, this.onDismiss});

  final ActionStatus status;
  final VoidCallback? onApprove;
  final VoidCallback? onComplete;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ActionStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: onDismiss, child: const Text('Dismiss')),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(onPressed: onApprove, child: const Text('Approve')),
            ),
          ],
        );
      case ActionStatus.approved:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: onComplete, child: const Text('Mark as Done')),
        );
      case ActionStatus.completed:
        return const StatusBadge(label: 'Completed', tone: BadgeTone.positive);
      case ActionStatus.dismissed:
        return const StatusBadge(label: 'Dismissed', tone: BadgeTone.neutral);
    }
  }
}
