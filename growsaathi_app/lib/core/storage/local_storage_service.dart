import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Thin wrapper over shared_preferences. Holds the two flags Phase 1
/// needs: which [AppMode] the app is in, and whether a mock login
/// session is active. Nothing else (no tokens — there's no real auth
/// backend yet).
class LocalStorageService {
  LocalStorageService._internal();
  static final LocalStorageService instance = LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  AppMode getAppMode() {
    final value = _prefs?.getString(AppConstants.prefsKeyAppMode);
    return value == AppMode.live.name ? AppMode.live : AppMode.demo;
  }

  Future<void> setAppMode(AppMode mode) async {
    await _prefs?.setString(AppConstants.prefsKeyAppMode, mode.name);
  }

  bool hasMockSession() {
    return _prefs?.getBool(AppConstants.prefsKeyMockSession) ?? false;
  }

  Future<void> setMockSession(bool active) async {
    await _prefs?.setBool(AppConstants.prefsKeyMockSession, active);
  }
}
