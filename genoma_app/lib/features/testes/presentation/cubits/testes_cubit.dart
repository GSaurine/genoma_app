import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/testes_repository.dart';
import 'testes_state.dart';

class TestesCubit extends Cubit<TestesState> {
  final TestesRepository repository;

  TestesCubit({required this.repository}) : super(const TestesInitial());

  Future<void> getAllTestes() async {
    emit(const TestesLoading());
    final result = await repository.getAllTestes();
    result.fold(
      (failure) => emit(TestesError(message: failure.message)),
      (testes) => emit(TestesLoaded(testes: testes)),
    );
  }

  Future<void> getTesteById(String id) async {
    emit(const TestesLoading());
    final result = await repository.getTesteById(id);
    result.fold(
      (failure) => emit(TestesError(message: failure.message)),
      (teste) => emit(TesteLoaded(teste: teste)),
    );
  }
}
