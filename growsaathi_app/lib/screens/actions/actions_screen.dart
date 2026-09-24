import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/actions/action_item_model.dart';
import '../../providers/action_provider.dart';
import '../../widgets/cards/action_card.dart';
import '../../widgets/common/empty_state.dart';

/// Action Center (Module 2). Statuses are tracked locally — the real
/// backend has no Action entity yet (see the backend API mapping,
/// Section 7 #5), so "Approve"/"Mark as Done"/"Dismiss" only change
/// local state for this offline demo.
class ActionsScreen extends ConsumerStatefulWidget {
  const ActionsScreen({super.key});

  @override
  ConsumerState<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends ConsumerState<ActionsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 4, vsync: this);

  static const _tabs = ['Pending', 'Approved', 'Completed', 'Dismissed'];
  static const _statuses = [
    ActionStatus.pending,
    ActionStatus.approved,
    ActionStatus.completed,
    ActionStatus.dismissed,
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(actionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Center'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [for (final t in _tabs) Tab(text: t)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (final status in _statuses) _ActionList(status: status, actions: actions),
        ],
      ),
    );
  }
}

class _ActionList extends ConsumerWidget {
  const _ActionList({required this.status, required this.actions});

  final ActionStatus status;
  final List<ActionItemModel> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = actions.where((a) => a.status == status).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: EmptyState(message: 'Nothing here yet.', icon: Icons.task_alt_rounded),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final action = filtered[index];
        return ActionCard(
          action: action,
          onApprove: () => ref.read(actionProvider.notifier).approve(action.id),
          onComplete: () => ref.read(actionProvider.notifier).complete(action.id),
          onDismiss: () => ref.read(actionProvider.notifier).dismiss(action.id),
        );
      },
    );
  }
}
