import 'package:genoma/core/config/envConfig.dart';
import 'package:genoma/core/config/dioConfig.dart';
import 'package:genoma/services/auth_service.dart';
import 'package:genoma/services/mock_auth_service.dart';

/// AuthFacade escolhe entre `AuthService` (real) e `MockAuthService` baseado
/// na flag `EnvConfig.allowDevAuthBypass` (somente em builds não-release).
class AuthFacade {
  AuthFacade._internal();
  static final AuthFacade _instance = AuthFacade._internal();
  factory AuthFacade() => _instance;

  final AuthService _real = AuthService();
  final MockAuthService _mock = MockAuthService();

  bool get _bypass => EnvConfig.allowDevAuthBypass;

  /// Inicializa o estado de autenticação a partir do token salvo.
  /// Retorna `true` se o utilizador atual foi carregado com sucesso.
  Future<bool> initializeFromSavedToken() async {
    try {
      final token = await getSavedToken();
      if (token != null && token.isNotEmpty) {
        APIService().token = token;
        final user = await fetchCurrentUser();
        return user != null;
      }
    } catch (_) {}
    return false;
  }

  Future<void> login(String email, String password) => _bypass ? _mock.login(email, password) : _real.login(email, password);
  Future<void> logout() => _bypass ? _mock.logout() : _real.logout();
  Future<String?> getSavedToken() => _bypass ? _mock.getSavedToken() : _real.getSavedToken();
  Future<Map<String, dynamic>?> fetchCurrentUser() => _bypass ? _mock.fetchCurrentUser() : _real.fetchCurrentUser();
  Map<String, dynamic>? get currentUser => _bypass ? _mock.currentUser : _real.currentUser;
  bool get isAdmin => _bypass ? _mock.isAdmin : _real.isAdmin;
  bool get isMedico {
    final perfil = currentUser?['perfil_nome']?.toString().toLowerCase();
    return perfil != null && perfil.contains('medico');
  }
}
