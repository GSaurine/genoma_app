import 'package:genoma/core/config/dioConfig.dart';

class EmpresasService {
  EmpresasService._internal();
  static final EmpresasService _instance = EmpresasService._internal();
  factory EmpresasService() => _instance;

  Future<List<Map<String, dynamic>>> fetchEmpresas() async {
    final api = APIService();
    final resp = await api.getRequest('/empresas');
    final body = resp.data;
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createEmpresa(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/empresas', data: data);
    final body = resp.data;
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    return null;
  }
}
