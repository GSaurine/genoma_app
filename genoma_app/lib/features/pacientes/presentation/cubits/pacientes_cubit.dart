import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/pacientes_repository.dart';
import 'pacientes_state.dart';

class PacientesCubit extends Cubit<PacientesState> {
  final PacientesRepository repository;

  PacientesCubit({required this.repository}) : super(const PacientesInitial());

  Future<void> getAllPacientes() async {
    emit(const PacientesLoading());
    final result = await repository.getAllPacientes();
    result.fold(
      (failure) => emit(PacientesError(message: failure.message)),
      (pacientes) => emit(PacientesLoaded(pacientes: pacientes)),
    );
  }

  Future<void> getPacienteById(String id) async {
    emit(const PacientesLoading());
    final result = await repository.getPacienteById(id);
    result.fold(
      (failure) => emit(PacientesError(message: failure.message)),
      (paciente) => emit(PacienteLoaded(paciente: paciente)),
    );
  }
}
