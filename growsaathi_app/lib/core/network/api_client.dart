import 'package:dio/dio.dart';

import '../errors/app_exception.dart';
import 'app_config.dart';

/// Single centralized Dio wrapper. All services call through this —
/// no widget and no service should construct its own Dio/http client
/// (per the brief's "Do NOT put raw HTTP requests directly inside
/// widgets" rule).
class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();

  late final Dio _dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _run(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _run(() => _dio.post(path, data: data, queryParameters: queryParameters));
  }

  Future<dynamic> delete(String path) {
    return _run(() => _dio.delete(path));
  }

  Future<dynamic> _run(Future<Response> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw AppException.unknown(e);
    }
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return AppException.network();
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        if (status == 404) return AppException.notFound();
        // The backend has no @ControllerAdvice yet, so most client
        // errors also arrive as 500s. Treat any bad response the same
        // way until the backend adds structured error codes.
        return AppException.server();
      case DioExceptionType.cancel:
        return AppException.unknown('Request cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return AppException.network();
    }
  }
}
