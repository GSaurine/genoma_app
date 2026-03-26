import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../../domain/entities/empresa.dart';

abstract class EmpresasRepository {
  Future<Either<Failure, List<Empresa>>> getAllEmpresas();
  Future<Either<Failure, Empresa>> getEmpresaById(String id);
  Future<Either<Failure, Empresa>> createEmpresa(Empresa empresa);
  Future<Either<Failure, Empresa>> updateEmpresa(Empresa empresa);
}