import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/empresas_repository.dart';
import 'empresas_state.dart';

class EmpresasCubit extends Cubit<EmpresasState> {
  final EmpresasRepository repository;

  EmpresasCubit({required this.repository}) : super(const EmpresasInitial());

  Future<void> getAllEmpresas() async {
    emit(const EmpresasLoading());
    final result = await repository.getAllEmpresas();
    result.fold(
      (failure) => emit(EmpresasError(message: failure.message)),
      (empresas) => emit(EmpresasLoaded(empresas: empresas)),
    );
  }

  Future<void> getEmpresaById(String id) async {
    emit(const EmpresasLoading());
    final result = await repository.getEmpresaById(id);
    result.fold(
      (failure) => emit(EmpresasError(message: failure.message)),
      (empresa) => emit(EmpresaLoaded(empresa: empresa)),
    );
  }
}