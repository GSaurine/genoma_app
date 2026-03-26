import 'package:dio/dio.dart';

/// Interceptor para adicionar token de autenticação nas requisições
class AuthInterceptor extends Interceptor {
  String? _authToken;

  /// Define o token de autenticação
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Remove o token de autenticação
  void clearAuthToken() {
    _authToken = null;
  }

  /// Obtém o token atual
  String? getAuthToken() {
    return _authToken;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Adiciona o token Bearer se estiver disponível
    if (_authToken != null && _authToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_authToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Trata erros de autenticação (401, 403)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Aqui você pode implementar lógica de refresh token
      // ou redirecionar para login
      _authToken = null;
    }

    handler.next(err);
  }
}
