import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/resultados_repository.dart';
import 'resultados_state.dart';

class ResultadosCubit extends Cubit<ResultadosState> {
  final ResultadosRepository repository;

  ResultadosCubit({required this.repository}) : super(const ResultadosInitial());

  Future<void> getAllResultados() async {
    emit(const ResultadosLoading());
    final result = await repository.getAllResultados();
    result.fold(
      (failure) => emit(ResultadosError(message: failure.message)),
      (resultados) => emit(ResultadosLoaded(resultados: resultados)),
    );
  }

  Future<void> getResultadoById(String id) async {
    emit(const ResultadosLoading());
    final result = await repository.getResultadoById(id);
    result.fold(
      (failure) => emit(ResultadosError(message: failure.message)),
      (resultado) => emit(ResultadoLoaded(resultado: resultado)),
    );
  }
}
