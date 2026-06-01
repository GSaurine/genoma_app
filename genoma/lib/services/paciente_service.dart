import 'package:genoma/core/config/dioConfig.dart';

class PacienteService {
  PacienteService._internal();
  static final PacienteService _instance = PacienteService._internal();
  factory PacienteService() => _instance;

  Future<List<Map<String, dynamic>>> fetchPacientes() async {
    final api = APIService();
    final resp = await api.getRequest('/pacientes');
    final body = resp.data;
    if (body == null) return [];
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from(
          (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    if (body is List) {
      return List<Map<String, dynamic>>.from(
          (body).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createPaciente(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/pacientes', data: data);
    final body = resp.data;
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    return null;
  }
}
