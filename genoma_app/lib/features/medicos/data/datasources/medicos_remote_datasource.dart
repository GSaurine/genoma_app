import 'package:genoma_app/core/network/dio_client.dart';
import '../models/medico_model.dart';

abstract class MedicosRemoteDataSource {
  Future<List<MedicoModel>> getAllMedicos();
  Future<MedicoModel> getMedicoById(String id);
  Future<MedicoModel> createMedico(MedicoModel medico);
  Future<MedicoModel> updateMedico(MedicoModel medico);
  Future<void> deleteMedico(String id);
}

class MedicosRemoteDataSourceImpl implements MedicosRemoteDataSource {
  final DioClient dioClient;

  MedicosRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MedicoModel>> getAllMedicos() async {
    final response = await dioClient.get('/medicos');
    return (response.data as List).map((m) => MedicoModel.fromJson(m as Map<String, dynamic>)).toList();
  }

  @override
  Future<MedicoModel> getMedicoById(String id) async {
    final response = await dioClient.get('/medicos/$id');
    return MedicoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MedicoModel> createMedico(MedicoModel medico) async {
    final response = await dioClient.post('/medicos', data: medico.toJson());
    return MedicoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MedicoModel> updateMedico(MedicoModel medico) async {
    final response = await dioClient.put('/medicos/${medico.id}', data: medico.toJson());
    return MedicoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteMedico(String id) async {
    await dioClient.delete('/medicos/$id');
  }
}
