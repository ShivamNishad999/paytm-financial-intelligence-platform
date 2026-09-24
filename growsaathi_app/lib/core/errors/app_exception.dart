/// User-facing error types. Kept deliberately generic because the
/// backend has no global exception handler yet — most failures surface
/// as Spring Boot's default error JSON with a 500 status even for what
/// should be 400/404s (see backend API mapping, Section 7 #4). Until
/// that's fixed server-side, granular status-code branching in the app
/// would be guessing, not handling.
enum AppErrorType {
  network,
  server,
  notFound,
  aiUnavailable,
  unknown,
}

class AppException implements Exception {
  final AppErrorType type;
  final String message;
  final Object? cause;

  const AppException(this.type, this.message, {this.cause});

  /// Copy the brief's exact user-facing language wherever possible.
  factory AppException.network() => const AppException(
        AppErrorType.network,
        'No internet connection. Please check your network and try again.',
      );

  factory AppException.server() => const AppException(
        AppErrorType.server,
        'Unable to load your data right now. Please try again.',
      );

  factory AppException.notFound() => const AppException(
        AppErrorType.notFound,
        'We couldn\'t find what you were looking for.',
      );

  factory AppException.aiUnavailable() => const AppException(
        AppErrorType.aiUnavailable,
        'AI insights are temporarily unavailable. Showing the latest data instead.',
      );

  factory AppException.unknown([Object? cause]) => AppException(
        AppErrorType.unknown,
        'Something went wrong. Please try again.',
        cause: cause,
      );

  @override
  String toString() => message;
}
