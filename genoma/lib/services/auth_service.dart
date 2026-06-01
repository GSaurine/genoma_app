import 'package:shared_preferences/shared_preferences.dart';
import 'package:genoma/core/config/dioConfig.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  static const _tokenKey = 'auth_token';
  Map<String, dynamic>? _currentUser;

  /// Faz login na API e persiste o token.
  Future<void> login(String email, String password) async {
    final api = APIService();
    final resp = await api.postRequest('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final token = resp.data is Map ? resp.data['token'] : resp.data;
    if (token == null || token is! String || token.isEmpty) {
      throw Exception('Token inválido retornado pela API');
    }

    // Persistir token localmente e aplicar no client
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    api.token = token;
    // Tenta buscar o perfil do utilizador imediatamente
    try {
      await fetchCurrentUser();
    } catch (_) {
      // não falha o login se o perfil não puder ser carregado
    }
  }

  /// Faz login como paciente e persiste o token.
  Future<void> loginPaciente(String email, String password) async {
    final api = APIService();
    final resp = await api.postRequest('/auth/login-paciente', data: {
      'email': email,
      'password': password,
    });

    final token = resp.data is Map ? resp.data['token'] : resp.data;
    if (token == null || token is! String || token.isEmpty) {
      throw Exception('Token inválido retornado pela API');
    }

    // Persistir token localmente e aplicar no client
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    api.token = token;
    
    // Tenta buscar o perfil do utilizador imediatamente
    try {
      await fetchCurrentUser();
    } catch (_) {
      // não falha o login se o perfil não puder ser carregado
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    APIService().clearKeys();
    _currentUser = null;
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Busca o perfil atual via `/auth/me` e armazena em memória.
  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    try {
      final api = APIService();
      final resp = await api.getRequest('/auth/me');
      if (resp.data is Map) {
        final userData = Map<String, dynamic>.from(resp.data as Map);
        
        // Se não for admin, tenta ver se existe na tabela de médicos
        final perfil = userData['perfil_nome']?.toString().toLowerCase() ?? '';
        if (!perfil.contains('admin')) {
          try {
            final medResp = await api.getRequest('/medicos/${userData['id']}');
            if (medResp.data != null && medResp.data is Map) {
              userData.addAll(Map<String, dynamic>.from(medResp.data as Map));
            }
          } catch (_) {
            // Se falhar, talvez não seja médico ou endpoint não exista
          }
        }

        _currentUser = userData;
        return _currentUser;
      }
    } catch (_) {
      // Ignora erros — chamador deve tratar
    }
    return null;
  }

  Map<String, dynamic>? get currentUser => _currentUser;

  bool get isAdmin {
    final perfil = _currentUser?['perfil_nome']?.toString();
    if (perfil == null) return false;
    return perfil.toLowerCase().contains('admin');
  }
}
