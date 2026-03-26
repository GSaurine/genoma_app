import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/exceptions.dart';

/// Abstract class para armazenamento seguro
abstract class SecureStorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> removeAuthToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> removeRefreshToken();
}

/// Implementação de SecureStorageService usando FlutterSecureStorage
class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageServiceImpl({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> saveString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao salvar no armazenamento seguro: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao obter do armazenamento seguro: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao remover do armazenamento seguro: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw StorageException(
        message: 'Erro ao limpar armazenamento seguro',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      throw StorageException(
        message: 'Erro ao verificar key no armazenamento seguro: $key',
        originalException: e,
      );
    }
  }

  /// Salva token de autenticação
  @override
  Future<void> saveAuthToken(String token) async {
    await saveString('auth_token', token);
  }

  /// Obtém token de autenticação
  @override
  Future<String?> getAuthToken() async {
    return await getString('auth_token');
  }

  /// Remove token de autenticação
  @override
  Future<void> removeAuthToken() async {
    await remove('auth_token');
  }

  /// Salva refresh token
  @override
  Future<void> saveRefreshToken(String token) async {
    await saveString('refresh_token', token);
  }

  /// Obtém refresh token
  @override
  Future<String?> getRefreshToken() async {
    return await getString('refresh_token');
  }

  /// Remove refresh token
  @override
  Future<void> removeRefreshToken() async {
    await remove('refresh_token');
  }
}
