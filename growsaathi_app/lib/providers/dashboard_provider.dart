import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/live_api_status.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../models/dashboard/dashboard_data_model.dart';
import '../services/dashboard/dashboard_service.dart';
import 'app_mode_provider.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService(ApiClient.instance);
});

/// Whether the last Live API Mode call actually succeeded (Module 5).
/// The Dashboard/More screens read this to show an honest "showing
/// demo data" banner instead of pretending Live Mode is working.
final liveApiStatusProvider = StateProvider<LiveApiStatus>((ref) => LiveApiStatus.idle);

/// Loads dashboard data from whichever source [appModeProvider] points
/// to. In Live API Mode, a failed call (timeout, offline, or server
/// error — see `ApiClient`'s error mapping) falls back to demo data
/// automatically rather than showing a dead screen, and records that
/// fallback in [liveApiStatusProvider] so it's visible, not silent —
/// per the brief's rule that Demo and Live data must never be mixed
/// without the merchant knowing which one they're looking at.
final dashboardProvider = FutureProvider.autoDispose<DashboardDataModel>((ref) async {
  final mode = ref.watch(appModeProvider);
  final service = ref.watch(dashboardServiceProvider);

  if (mode == AppMode.demo) {
    ref.read(liveApiStatusProvider.notifier).state = LiveApiStatus.idle;
    return service.getDemoDashboardData();
  }

  try {
    final data = await service.getDashboardData();
    ref.read(liveApiStatusProvider.notifier).state = LiveApiStatus.connected;
    return data;
  } on AppException {
    ref.read(liveApiStatusProvider.notifier).state = LiveApiStatus.fallback;
    return service.getDemoDashboardData();
  } catch (_) {
    ref.read(liveApiStatusProvider.notifier).state = LiveApiStatus.fallback;
    return service.getDemoDashboardData();
  }
});
