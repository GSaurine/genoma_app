import 'dart:convert';
import 'package:genoma_app/core/storage/local_storage_service.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(TokenModel token);
  Future<TokenModel?> getToken();
  Future<void> saveCurrentUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  final LocalStorageService localStorageService;

  AuthLocalDataSourceImpl({required this.localStorageService});

  @override
  Future<void> saveToken(TokenModel token) async {
    try {
      final tokenJson = token.toJson();
      await localStorageService.saveString(
        _tokenKey,
        json.encode(tokenJson),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TokenModel?> getToken() async {
    try {
      final tokenStr = await localStorageService.getString(_tokenKey);
      if (tokenStr == null) return null;
      final decodedJson = json.decode(tokenStr) as Map<String, dynamic>;
      return TokenModel.fromJson(decodedJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveCurrentUser(UserModel user) async {
    try {
      final userJson = user.toJson();
      await localStorageService.saveString(
        _userKey,
        json.encode(userJson),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userStr = await localStorageService.getString(_userKey);
      if (userStr == null) return null;
      final decodedJson = json.decode(userStr) as Map<String, dynamic>;
      return UserModel.fromJson(decodedJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await localStorageService.remove(_tokenKey);
      await localStorageService.remove(_userKey);
    } catch (e) {
      rethrow;
    }
  }
}
