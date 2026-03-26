import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';

/// Abstract class para armazenamento local
abstract class LocalStorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> saveDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> saveList(String key, List<String> value);
  Future<List<String>?> getList(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

/// Implementação de LocalStorageService usando SharedPreferences
class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences _sharedPreferences;

  LocalStorageServiceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveString(String key, String value) async {
    try {
      await _sharedPreferences.setString(key, value);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao salvar string: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _sharedPreferences.getString(key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao obter string: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> saveInt(String key, int value) async {
    try {
      await _sharedPreferences.setInt(key, value);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao salvar inteiro: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      return _sharedPreferences.getInt(key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao obter inteiro: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    try {
      await _sharedPreferences.setBool(key, value);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao salvar booleano: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      return _sharedPreferences.getBool(key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao obter booleano: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    try {
      await _sharedPreferences.setDouble(key, value);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao salvar double: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    try {
      return _sharedPreferences.getDouble(key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao obter double: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> saveList(String key, List<String> value) async {
    try {
      await _sharedPreferences.setStringList(key, value);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao salvar lista: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<List<String>?> getList(String key) async {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao obter lista: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao remover: $key',
        originalException: e,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _sharedPreferences.clear();
    } catch (e) {
      throw StorageException(
        message: 'Erro ao limpar armazenamento',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      return _sharedPreferences.containsKey(key);
    } catch (e) {
      throw StorageException(
        message: 'Erro ao verificar key: $key',
        originalException: e,
      );
    }
  }
}
