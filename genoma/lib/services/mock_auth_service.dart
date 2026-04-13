import 'package:shared_preferences/shared_preferences.dart';
import 'package:genoma/core/config/dioConfig.dart';

/// MockAuthService usado apenas em desenvolvimento quando `DEV_AUTH_BYPASS=true`.
class MockAuthService {
  MockAuthService._internal();
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;

  String _token = '';
  Map<String, dynamic>? _currentUser;

  Future<void> login(String email, String password) async {
    // Simula autenticação simples localmente
    _token = 'mock-token-${email.hashCode}';
    APIService().token = _token;

    final role = email.toLowerCase().contains('admin') ? 'Admin' : 'User';
    _currentUser = {'email': email, 'perfil_nome': role};

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token);
  }

  Future<void> logout() async {
    _token = '';
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    APIService().clearKeys();
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    return _currentUser;
  }

  Map<String, dynamic>? get currentUser => _currentUser;

  bool get isAdmin {
    final perfil = _currentUser?['perfil_nome']?.toString();
    if (perfil == null) return false;
    return perfil.toLowerCase().contains('admin');
  }
}
