import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/app_config.dart';

/// Interceptor para logging de requisições e respostas
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.enableDebugLogging) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('REQUEST: ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
      debugPrint('Headers: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
      debugPrint('═══════════════════════════════════════');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.enableDebugLogging) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('RESPONSE: ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.path}');
      debugPrint('Data: ${response.data}');
      debugPrint('═══════════════════════════════════════');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.enableDebugLogging) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('ERROR: ${err.message}');
      debugPrint('Status Code: ${err.response?.statusCode}');
      debugPrint('Response: ${err.response?.data}');
      debugPrint('═══════════════════════════════════════');
    }
    handler.next(err);
  }
}
