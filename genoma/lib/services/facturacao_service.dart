import 'package:genoma/core/config/dioConfig.dart';

class FacturacaoService {
  FacturacaoService._internal();
  static final FacturacaoService _instance = FacturacaoService._internal();
  factory FacturacaoService() => _instance;

  Future<Map<String, dynamic>?> getByProcessoId(String processoId) async {
    final api = APIService();
    final resp = await api.getRequest('/facturacao/processo/$processoId');
    return resp.data != null ? Map<String, dynamic>.from(resp.data as Map) : null;
  }

  Future<Map<String, dynamic>?> upsertFacturacao(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/facturacao', data: data);
    return resp.data != null ? Map<String, dynamic>.from(resp.data as Map) : null;
  }

  Future<bool> deleteFacturacao(String id) async {
    final api = APIService();
    final resp = await api.deleteRequest('/facturacao/$id');
    return resp.statusCode == 204;
  }
}
