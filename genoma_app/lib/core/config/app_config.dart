import 'package:flutter/foundation.dart';

/// Configurações gerais da aplicação
class AppConfig {
  static const String appName = 'Genoma App';
  static const String appVersion = '1.0.0';
  
  // Ambientes
  static const String devEnvironment = 'dev';
  static const String prodEnvironment = 'prod';
  static const String testEnvironment = 'test';

  // URLs da API conforme o ambiente
  static const String devBaseUrl = 'http://localhost:3000/api';
  static const String prodBaseUrl = 'https://api.genoma.com/api';
  static const String testBaseUrl = 'http://localhost:3000/api';

  // altere para que seja true apenas em modo de desenvolvimento
  static bool get isDebugMode => kDebugMode;

  // Variáveis de ambiente (podem ser alteradas no build)
  static String get apiBaseUrl {
    // Aqui você pode adicionar lógica dinâmica se necessário
    return _currentEnvironment == prodEnvironment ? prodBaseUrl : devBaseUrl;
  }

  static String get environment => _currentEnvironment;
  
  // Isso pode ser definido durante a inicialização da app
  static String _currentEnvironment = devEnvironment;

  /// Configura o ambiente da aplicação
  static void setEnvironment(String env) {
    _currentEnvironment = env;
  }

  // Timeouts
  static const Duration apiTimeoutDuration = Duration(seconds: 30);
  static const Duration connectTimeoutDuration = Duration(seconds: 10);

  // Outros
  static const bool enableDebugLogging = true;
  static const int maxRetries = 3;
}
