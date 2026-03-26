import 'package:genoma_app/core/network/dio_client.dart';
import '../models/paciente_model.dart';

abstract class PacientesRemoteDataSource {
  Future<List<PacienteModel>> getAllPacientes();
  Future<PacienteModel> getPacienteById(String id);
  Future<PacienteModel> createPaciente(PacienteModel paciente);
  Future<PacienteModel> updatePaciente(PacienteModel paciente);
  Future<void> deletePaciente(String id);
}

class PacientesRemoteDataSourceImpl implements PacientesRemoteDataSource {
  final DioClient dioClient;

  PacientesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<PacienteModel>> getAllPacientes() async {
    final response = await dioClient.get('/pacientes');
    return (response.data as List).map((p) => PacienteModel.fromJson(p as Map<String, dynamic>)).toList();
  }

  @override
  Future<PacienteModel> getPacienteById(String id) async {
    final response = await dioClient.get('/pacientes/$id');
    return PacienteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PacienteModel> createPaciente(PacienteModel paciente) async {
    final response = await dioClient.post('/pacientes', data: paciente.toJson());
    return PacienteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PacienteModel> updatePaciente(PacienteModel paciente) async {
    final response = await dioClient.put('/pacientes/${paciente.id}', data: paciente.toJson());
    return PacienteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deletePaciente(String id) async {
    await dioClient.delete('/pacientes/$id');
  }
}
