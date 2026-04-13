import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configurações de ambiente do aplicativo Flutter.
/// Lê `API_BASE_URL` do arquivo .env (via flutter_dotenv) quando disponível.
class EnvConfig {
  static String? _overrideApiBaseUrl;

  static String? _envValue(String key) {
    if (!dotenv.isInitialized) return null;
    return dotenv.env[key];
  }

	/// Retorna a base URL da API. Prioridade:
	/// 1. Valor definido em tempo de execução via `setApiBaseUrl`
	/// 2. Variável `API_BASE_URL` carregada pelo `flutter_dotenv`
	/// 3. Valor padrão `http://localhost:3000/api`
  static String get apiBaseUrl =>
      _overrideApiBaseUrl ?? _envValue('API_BASE_URL') ?? 'http://localhost:3000/api';

	/// Timeouts padrão usados pelo Dio.
  static Duration connectTimeout = const Duration(seconds: 5);
  static Duration receiveTimeout = const Duration(seconds: 3);

	/// Em desenvolvimento, permite ignorar autenticação real e usar um mock.
  static bool get devAuthBypass => (_envValue('DEV_AUTH_BYPASS')?.toLowerCase() == 'true');

  /// Em builds de release nunca permitir bypass de autenticação.
  /// Isso evita comportamento ambíguo entre mock e auth real no ambiente principal.
  static bool get allowDevAuthBypass {
    if (kReleaseMode) return false;
    return devAuthBypass;
  }

	/// Permite sobrescrever a base URL em tempo de execução (opcional).
  static void setApiBaseUrl(String url) {
    _overrideApiBaseUrl = url;
  }
}
