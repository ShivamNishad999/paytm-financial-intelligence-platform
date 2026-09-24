import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../models/dashboard/dashboard_data_model.dart';

/// Wraps `GET /api/dashboard`. This is the only network call the Home
/// screen needs — the endpoint already aggregates sales, customers,
/// products, inventory, campaigns, daily sales and opportunities in
/// one response (see backend API mapping, Section 4).
///
/// In demo mode, [getDashboardData] reads the bundled mock JSON instead
/// of calling Dio — the two paths are kept structurally identical
/// (same fromJson) so switching modes never changes what the UI does
/// with the data, only where it came from.
class DashboardService {
  DashboardService(this._apiClient);

  final ApiClient _apiClient;

  Future<DashboardDataModel> getDashboardData() async {
    final raw = await _apiClient.get(ApiEndpoints.dashboard);
    return DashboardDataModel.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  Future<DashboardDataModel> getDemoDashboardData() async {
    final jsonString = await rootBundle.loadString('assets/mock/dashboard_mock.json');
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    return DashboardDataModel.fromJson(decoded);
  }
}
