/// Tracks whether the last Live API Mode call actually reached the
/// backend, so the UI can tell the difference between "Live Mode,
/// working" and "Live Mode, but silently showing demo data because the
/// backend was unreachable" (Module 5).
enum LiveApiStatus {
  /// Not in Live API Mode, or no call has completed yet.
  idle,

  /// Last live call succeeded — data on screen is genuinely live.
  connected,

  /// Live call failed (timeout, offline, or server error) and the app
  /// fell back to demo data automatically, per the brief's Live/Demo
  /// mode rule — the fallback must be visible, not silent.
  fallback,
}
