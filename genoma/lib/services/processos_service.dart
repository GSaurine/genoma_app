import 'package:genoma/core/config/dioConfig.dart';

class ProcessosService {
  ProcessosService._internal();
  static final ProcessosService _instance = ProcessosService._internal();
  factory ProcessosService() => _instance;

  Future<List<Map<String, dynamic>>> fetchProcessos() async {
    final api = APIService();
    final resp = await api.getRequest('/processos');
    final body = resp.data;
    if (body == null) return [];
    if (body is Map && body['data'] is List) {
       return List<Map<String, dynamic>>.from(
           (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchProcessosByPaciente(String pacienteId) async {
    final api = APIService();
    final resp = await api.getRequest('/processos/paciente/$pacienteId');
    final body = resp.data;
    if (body == null) return [];
    if (body is Map && body['data'] is List) {
       return List<Map<String, dynamic>>.from(
           (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createProcesso(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/processos', data: data);
    final body = resp.data;
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    return null;
  }
}
