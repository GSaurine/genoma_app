import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genoma_app/features/utilizadores/domain/entities/utilizadores.dart';
import 'package:genoma_app/features/utilizadores/domain/repositories/utilizadores_repository.dart';
import 'utilizadores_state.dart';

class UtilizadoresCubit extends Cubit<UtilizadoresState> {
  final UtilizadoresRepository repository;

  UtilizadoresCubit({required this.repository}) : super(const UtilizadoresInitial());

  Future<void> getAllUtilizadores() async {
    emit(const UtilizadoresLoading());
    final result = await repository.getAllUtilizadores();
    result.fold(
      (failure) => emit(UtilizadoresError(message: failure.message)),
      (utilizadores) => emit(UtilizadoresLoaded(utilizadores: utilizadores)),
    );
  }

  Future<void> getUtilizadorById(String id) async {
    emit(const UtilizadoresLoading());
    final result = await repository.getUtilizadorById(id);
    result.fold(
      (failure) => emit(UtilizadorError(message: failure.message)),
      (utilizador) => emit(UtilizadorLoaded(utilizador: utilizador)),
    );
  }

  Future<void> updateUtilizador(Utilizador utilizador) async {
    emit(const UtilizadoresLoading());
    final result = await repository.updateUtilizador(utilizador);
    result.fold(
      (failure) => emit(UtilizadoresError(message: failure.message)),
      (updatedUtilizador) => getAllUtilizadores(),
    );
  }

  Future<void> deleteUtilizador(String id) async {
    emit(const UtilizadoresLoading());
    final result = await repository.deleteUtilizador(id);
    result.fold(
      (failure) => emit(UtilizadoresError(message: failure.message)),
      (_) => getAllUtilizadores(),
    );
  }
}
