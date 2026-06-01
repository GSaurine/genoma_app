import 'package:genoma/core/config/dioConfig.dart';

class MedicosService {
  MedicosService._internal();
  static final MedicosService _instance = MedicosService._internal();
  factory MedicosService() => _instance;

  Future<List<Map<String, dynamic>>> fetchMedicos() async {
    final api = APIService();
    final resp = await api.getRequest('/medicos');
    final body = resp.data;
    if (body == null) return [];
    if (body is Map && body['data'] is List) {
       return List<Map<String, dynamic>>.from(
           (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createMedico(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/medicos', data: data);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final responseData = resp.data;
      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData['data'] ?? responseData);
      }
    }
    return null;
  }
}
