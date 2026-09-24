import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/storage/local_storage_service.dart';

/// Demo vs Live switch. Per the brief, the two must never be mixed
/// silently — every data-fetching provider reads this before deciding
/// which service method to call.
class AppModeNotifier extends StateNotifier<AppMode> {
  AppModeNotifier() : super(LocalStorageService.instance.getAppMode());

  Future<void> setMode(AppMode mode) async {
    state = mode;
    await LocalStorageService.instance.setAppMode(mode);
  }

  Future<void> toggle() => setMode(state == AppMode.demo ? AppMode.live : AppMode.demo);
}

final appModeProvider = StateNotifierProvider<AppModeNotifier, AppMode>((ref) {
  return AppModeNotifier();
});
