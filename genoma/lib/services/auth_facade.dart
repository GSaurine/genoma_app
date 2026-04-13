import 'package:genoma/core/config/envConfig.dart';
import 'package:genoma/services/auth_service.dart';
import 'package:genoma/services/mock_auth_service.dart';

/// AuthFacade escolhe entre `AuthService` (real) e `MockAuthService` baseado
/// na flag `EnvConfig.devAuthBypass`.
class AuthFacade {
  AuthFacade._internal();
  static final AuthFacade _instance = AuthFacade._internal();
  factory AuthFacade() => _instance;

  final AuthService _real = AuthService();
  final MockAuthService _mock = MockAuthService();

  bool get _bypass => EnvConfig.devAuthBypass;

  Future<void> login(String email, String password) => _bypass ? _mock.login(email, password) : _real.login(email, password);
  Future<void> logout() => _bypass ? _mock.logout() : _real.logout();
  Future<String?> getSavedToken() => _bypass ? _mock.getSavedToken() : _real.getSavedToken();
  Future<Map<String, dynamic>?> fetchCurrentUser() => _bypass ? _mock.fetchCurrentUser() : _real.fetchCurrentUser();
  Map<String, dynamic>? get currentUser => _bypass ? _mock.currentUser : _real.currentUser;
  bool get isAdmin => _bypass ? _mock.isAdmin : _real.isAdmin;
}
