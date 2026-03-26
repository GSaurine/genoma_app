import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/medicos_repository.dart';
import 'medicos_state.dart';

class MedicosCubit extends Cubit<MedicosState> {
  final MedicosRepository repository;

  MedicosCubit({required this.repository}) : super(const MedicosInitial());

  Future<void> getAllMedicos() async {
    emit(const MedicosLoading());
    final result = await repository.getAllMedicos();
    result.fold(
      (failure) => emit(MedicosError(message: failure.message)),
      (medicos) => emit(MedicosLoaded(medicos: medicos)),
    );
  }

  Future<void> getMedicoById(String id) async {
    emit(const MedicosLoading());
    final result = await repository.getMedicoById(id);
    result.fold(
      (failure) => emit(MedicosError(message: failure.message)),
      (medico) => emit(MedicoLoaded(medico: medico)),
    );
  }
}
