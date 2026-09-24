import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/insight/insight_date_range.dart';
import '../models/insight/insight_model.dart';
import '../services/insight/insight_service.dart';

final insightServiceProvider = Provider<InsightService>((ref) => InsightService());

final insightDateRangeProvider = StateProvider<InsightDateRange>((ref) => InsightDateRange.last7Days);

/// Re-fetches whenever the date range changes, since it `watch`es
/// [insightDateRangeProvider] rather than `read`s it.
final insightProvider = FutureProvider.autoDispose<InsightModel>((ref) async {
  final range = ref.watch(insightDateRangeProvider);
  final service = ref.watch(insightServiceProvider);
  return service.getInsights(range);
});
