import 'package:genoma_app/core/network/dio_client.dart';
import '../models/empresa_model.dart';

abstract class EmpresasRemoteDataSource {
  Future<List<EmpresaModel>> getAllEmpresas();
  Future<EmpresaModel> getEmpresaById(String id);
  Future<EmpresaModel> createEmpresa(EmpresaModel empresa);
  Future<EmpresaModel> updateEmpresa(EmpresaModel empresa);
  Future<void> deleteEmpresa(String id);
}

class EmpresasRemoteDataSourceImpl implements EmpresasRemoteDataSource {
  final DioClient dioClient;

  EmpresasRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<EmpresaModel>> getAllEmpresas() async {
    final response = await dioClient.get('/empresas');
    return (response.data as List).map((e) => EmpresaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<EmpresaModel> getEmpresaById(String id) async {
    final response = await dioClient.get('/empresas/$id');
    return EmpresaModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<EmpresaModel> createEmpresa(EmpresaModel empresa) async {
    final response = await dioClient.post('/empresas', data: empresa.toJson());
    return EmpresaModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<EmpresaModel> updateEmpresa(EmpresaModel empresa) async {
    final response = await dioClient.put('/empresas/${empresa.id}', data: empresa.toJson());
    return EmpresaModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteEmpresa(String id) async {
    await dioClient.delete('/empresas/$id');
  }
}