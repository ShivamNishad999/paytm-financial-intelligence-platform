/// Environment configuration for the API client.
///
/// The backend has no context path or versioning prefix (confirmed from
/// `application.properties` — `server.port=8080`, no
/// `server.servlet.context-path`), so [baseUrl] is the whole host, and
/// [ApiEndpoints] paths are appended directly to it.
class AppConfig {
  AppConfig._();

  /// Android emulator's alias for the host machine's localhost.
  /// Change to your LAN IP or staging host when testing on a real device.
  static const String baseUrl = 'http://10.0.2.2:8080';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
