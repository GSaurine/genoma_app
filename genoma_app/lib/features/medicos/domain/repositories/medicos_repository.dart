import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../entities/medico.dart';

abstract class MedicosRepository {
  Future<Either<Failure, List<Medico>>> getAllMedicos();
  Future<Either<Failure, Medico>> getMedicoById(String id);
  Future<Either<Failure, Medico>> createMedico(Medico medico);
  Future<Either<Failure, Medico>> updateMedico(Medico medico);
  Future<Either<Failure, void>> deleteMedico(String id);
}
