import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../entities/paciente.dart';

abstract class PacientesRepository {
  Future<Either<Failure, List<Paciente>>> getAllPacientes();
  Future<Either<Failure, Paciente>> getPacienteById(String id);
  Future<Either<Failure, Paciente>> createPaciente(Paciente paciente);
  Future<Either<Failure, Paciente>> updatePaciente(Paciente paciente);
  Future<Either<Failure, void>> deletePaciente(String id);
}
