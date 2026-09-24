/// App-wide constants that aren't colors/text styles/endpoints.
class AppConstants {
  AppConstants._();

  static const String appName = 'GrowSAATHI';
  static const String appTagline = 'AI-Powered Merchant Growth Partner';

  /// Persisted app-mode flag key (Demo vs Live API).
  static const String prefsKeyAppMode = 'growsaathi_app_mode';

  /// Persisted mock-session flag key (mock login state).
  static const String prefsKeyMockSession = 'growsaathi_mock_session';

  static const Duration splashMinDuration = Duration(milliseconds: 2200);
}

/// Where the app currently gets its data from. Per the brief, DEMO and
/// LIVE must never be silently mixed — every screen that reads data
/// should know unambiguously which mode it's in.
enum AppMode { demo, live }
