import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/actions/action_item_model.dart';
import '../services/actions/local_action_service.dart';

final localActionServiceProvider = Provider<LocalActionService>((ref) => LocalActionService());

class ActionNotifier extends StateNotifier<List<ActionItemModel>> {
  ActionNotifier(this._service) : super(_service.seedActions());

  // ignore: unused_field
  final LocalActionService _service;

  void updateStatus(String id, ActionStatus status) {
    state = [
      for (final action in state)
        if (action.id == id) action.copyWith(status: status) else action,
    ];
  }

  void approve(String id) => updateStatus(id, ActionStatus.approved);
  void complete(String id) => updateStatus(id, ActionStatus.completed);
  void dismiss(String id) => updateStatus(id, ActionStatus.dismissed);
}

final actionProvider = StateNotifierProvider<ActionNotifier, List<ActionItemModel>>((ref) {
  return ActionNotifier(ref.watch(localActionServiceProvider));
});
