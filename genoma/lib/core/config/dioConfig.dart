import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:genoma/core/config/envConfig.dart';
import 'package:genoma/core/config/interceptors.dart';

/// Singleton service que encapsula o Dio configurado com interceptors.
class APIService {
  APIService._internal() {
    _dio = _createDio();
  }

  static final APIService _instance = APIService._internal();
  factory APIService() => _instance;

  late final Dio _dio;
  String _token = '';
  String _apiKey = '';

  Dio get dio => _dio;

  Dio _createDio() {
    final options = BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: EnvConfig.connectTimeout,
      receiveTimeout: EnvConfig.receiveTimeout,
    );

    final d = Dio(options);
    d.interceptors.addAll([
      LoggingInterceptor(),
      TokenInterceptor(() => _token),
      ErrorInterceptor(onUnauthorized: clearKeys),
    ]);

    // Permite aceitar certificados self-signed em desenvolvimento
    // Somente quando explicitamente habilitado via `DEV_ALLOW_INSECURE_HTTPS=true`
    // e apenas para hosts `localhost`/`127.0.0.1` para limitar risco.
    final allowInsecure = dotenv.isInitialized &&
        dotenv.env['DEV_ALLOW_INSECURE_HTTPS']?.toLowerCase() == 'true';
    if (allowInsecure) {
      try {
        final uri = Uri.parse(EnvConfig.apiBaseUrl);
        final host = uri.host;
        // Treat emulator host aliases as localhost in dev for accepting self-signed certs
        if (host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2' || host == '10.0.3.2') {
          (d.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
            client.badCertificateCallback = (X509Certificate cert, String host, int port) {
              return host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2' || host == '10.0.3.2';
            };
            return client;
          };
        }
      } catch (_) {
        // Ignora erros de parsing de URI — fallback sem ajuste
      }
    }

    return d;
  }

  String get token => _token;
  set token(String value) => _token = value;

  String get apiKey => _apiKey;
  set apiKey(String value) => _apiKey = value;

  void clearKeys() {
    _token = '';
    _apiKey = '';
  }

  Future<Response<T>> getRequest<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> postRequest<T>(String path, {dynamic data}) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> putRequest<T>(String path, {dynamic data}) async {
    try {
      return await _dio.put<T>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> deleteRequest<T>(String path, {dynamic data}) async {
    try {
      return await _dio.delete<T>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return ConnectionTimeoutException(e.message);
    if (e.type == DioExceptionType.sendTimeout) return SendTimeoutException(e.message);
    if (e.type == DioExceptionType.receiveTimeout) return ReceiveTimeoutException(e.message);
    if (e.error is SocketException) return NoInternetConnectionException(e.message);

    final status = e.response?.statusCode ?? 0;
    String? serverMsg;
    if (e.response?.data is Map) {
      serverMsg = e.response?.data['error'] ?? e.response?.data['message'];
    }
    final displayMsg = serverMsg ?? e.message;

    switch (status) {
      case 400:
        return BadRequestException(displayMsg);
      case 401:
        return UnauthorizedException(displayMsg);
      case 403:
        return ForbiddenException(displayMsg);
      case 404:
        return NotFoundException(displayMsg);
      case 409:
        return ConflictException(displayMsg);
      case 429:
        return TooManyRequestsException(displayMsg);
      case 500:
        return InternalServerErrorException(displayMsg);
      default:
        return Exception(displayMsg);
    }
  }
}

//---------- Exceções customizadas ---------
class ConnectionTimeoutException implements Exception {
  final String? message;
  ConnectionTimeoutException([this.message]);
  @override
  String toString() => 'ConnectionTimeoutException: $message';
}

class SendTimeoutException implements Exception {
  final String? message;
  SendTimeoutException([this.message]);
  @override
  String toString() => 'SendTimeoutException: $message';
}

class ReceiveTimeoutException implements Exception {
  final String? message;
  ReceiveTimeoutException([this.message]);
  @override
  String toString() => 'ReceiveTimeoutException: $message';
}

class NoInternetConnectionException implements Exception {
  final String? message;
  NoInternetConnectionException([this.message]);
  @override
  String toString() => 'NoInternetConnectionException: $message';
}

class BadRequestException implements Exception {
  final String? message;
  BadRequestException([this.message]);
  @override
  String toString() => 'BadRequestException: $message';
}

class UnauthorizedException implements Exception {
  final String? message;
  UnauthorizedException([this.message]);
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException implements Exception {
  final String? message;
  ForbiddenException([this.message]);
  @override
  String toString() => 'ForbiddenException: $message';
}

class NotFoundException implements Exception {
  final String? message;
  NotFoundException([this.message]);
  @override
  String toString() => 'NotFoundException: $message';
}

class ConflictException implements Exception {
  final String? message;
  ConflictException([this.message]);
  @override
  String toString() => 'ConflictException: $message';
}

class TooManyRequestsException implements Exception {
  final String? message;
  TooManyRequestsException([this.message]);
  @override
  String toString() => 'TooManyRequestsException: $message';
}

class InternalServerErrorException implements Exception {
  final String? message;
  InternalServerErrorException([this.message]);
  @override
  String toString() => 'InternalServerErrorException: $message';
}
