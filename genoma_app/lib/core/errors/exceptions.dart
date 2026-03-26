/// Definição de exceções customizadas
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exceção para erros de conexão
class NetworkException extends AppException {
  NetworkException({
    super.message = 'Erro de conexão',
    super.code,
    super.originalException,
  });
}

/// Exceção para erros de timeout
class TimeoutException extends AppException {
  TimeoutException({
    super.message = 'Tempo limite excedido',
    super.code,
    super.originalException,
  });
}

/// Exceção para erros de autenticação
class AuthException extends AppException {
  AuthException({
    super.message = 'Erro de autenticação',
    super.code,
    super.originalException,
  });
}

/// Exceção para token expirado
class TokenExpiredException extends AuthException {
  TokenExpiredException({
    super.message = 'Token expirado',
    String? code,
    super.originalException,
  }) : super(
    code: code ?? '401',
  );
}

/// Exceção para usuário não autorizado
class UnauthorizedException extends AuthException {
  UnauthorizedException({
    super.message = 'Não autorizado',
    String? code,
    super.originalException,
  }) : super(
    code: code ?? '403',
  );
}

/// Exceção para recurso não encontrado
class NotFoundException extends AppException {
  NotFoundException({
    super.message = 'Recurso não encontrado',
    String? code,
    super.originalException,
  }) : super(
    code: code ?? '404',
  );
}

/// Exceção para erro do servidor
class ServerException extends AppException {
  ServerException({
    super.message = 'Erro do servidor',
    String? code,
    super.originalException,
  }) : super(
    code: code ?? '500',
  );
}

/// Exceção para validação
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException({
    super.message = 'Erro de validação',
    super.code,
    this.errors,
    super.originalException,
  });
}

/// Exceção para armazenamento local
class StorageException extends AppException {
  StorageException({
    super.message = 'Erro de armazenamento',
    super.code,
    super.originalException,
  });
}

/// Exceção para erro de parsing/serialização
class ParsingException extends AppException {
  ParsingException({
    super.message = 'Erro ao processar dados',
    super.code,
    super.originalException,
  });
}

/// Exceção genérica para erros não categorizado
class UnknownException extends AppException {
  UnknownException({
    super.message = 'Erro desconhecido',
    super.code,
    super.originalException,
  });
}
