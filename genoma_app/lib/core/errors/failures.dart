// Padrão Failure para tratamento de erros na camada de domínio
// Seguindo a pattern de Functional Programming

abstract class Failure {
  final String message;
  final String? code;

  Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() => '$runtimeType: $message';
}

/// Falha de conexão
class NetworkFailure extends Failure {
  NetworkFailure({
    super.message = 'Erro de conexão',
    super.code,
  });
}

/// Falha de timeout
class TimeoutFailure extends Failure {
  TimeoutFailure({
    super.message = 'Tempo limite excedido',
    super.code,
  });
}

/// Falha de autenticação
class AuthFailure extends Failure {
  AuthFailure({
    super.message = 'Erro de autenticação',
    super.code,
  });
}

/// Falha de token expirado
class TokenExpiredFailure extends AuthFailure {
  TokenExpiredFailure({
    super.message = 'Token expirado',
    String? code,
  }) : super(code: code ?? '401');
}

/// Falha de não autorizado
class UnauthorizedFailure extends AuthFailure {
  UnauthorizedFailure({
    super.message = 'Não autorizado',
    String? code,
  }) : super(code: code ?? '403');
}

/// Falha de recurso não encontrado
class NotFoundFailure extends Failure {
  NotFoundFailure({
    super.message = 'Recurso não encontrado',
    String? code,
  }) : super(code: code ?? '404');
}

/// Falha do servidor
class ServerFailure extends Failure {
  ServerFailure({
    super.message = 'Erro do servidor',
    String? code,
  }) : super(code: code ?? '500');
}

/// Falha de validação
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  ValidationFailure({
    super.message = 'Erro de validação',
    super.code,
    this.fieldErrors,
  });
}

/// Falha de armazenamento local
class StorageFailure extends Failure {
  StorageFailure({
    super.message = 'Erro de armazenamento',
    super.code,
  });
}

/// Falha de parsing/serialização
class ParsingFailure extends Failure {
  ParsingFailure({
    super.message = 'Erro ao processar dados',
    super.code,
  });
}

/// Falha desconhecida
class UnknownFailure extends Failure {
  UnknownFailure({
    super.message = 'Erro desconhecido',
    super.code,
  });
}

/// Falha sem conexão à internet
class NoInternetFailure extends NetworkFailure {
  NoInternetFailure({
    super.message = 'Sem conexão com a internet',
    super.code,
  });
}

/// Falha de API/chamada HTTP
class ApiFailure extends Failure {
  ApiFailure({
    super.message = 'Erro na chamada da API',
    super.code,
  });
}

/// Falha de cache/armazenamento local
class CacheFailure extends Failure {
  CacheFailure({
    super.message = 'Erro ao acessar cache',
    super.code,
  });
}
