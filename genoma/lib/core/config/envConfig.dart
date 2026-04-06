import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configurações de ambiente do aplicativo Flutter.
/// Lê `API_BASE_URL` do arquivo .env (via flutter_dotenv) quando disponível.
class EnvConfig {
	static String? _overrideApiBaseUrl;

	/// Retorna a base URL da API. Prioridade:
	/// 1. Valor definido em tempo de execução via `setApiBaseUrl`
	/// 2. Variável `API_BASE_URL` carregada pelo `flutter_dotenv`
	/// 3. Valor padrão `http://localhost:3000/api`
	static String get apiBaseUrl =>
		_overrideApiBaseUrl ?? dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';

	/// Timeouts padrão usados pelo Dio.
	static Duration connectTimeout = const Duration(seconds: 5);
	static Duration receiveTimeout = const Duration(seconds: 3);

	/// Permite sobrescrever a base URL em tempo de execução (opcional).
	static void setApiBaseUrl(String url) {
		_overrideApiBaseUrl = url;
	}
}
