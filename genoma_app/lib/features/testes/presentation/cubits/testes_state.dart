import 'package:equatable/equatable.dart';
import '../../domain/entities/teste.dart';

abstract class TestesState extends Equatable {
  const TestesState();

  @override
  List<Object?> get props => [];
}

class TestesInitial extends TestesState {
  const TestesInitial();
}

class TestesLoading extends TestesState {
  const TestesLoading();
}

class TestesLoaded extends TestesState {
  final List<Teste> testes;

  const TestesLoaded({required this.testes});

  @override
  List<Object?> get props => [testes];
}

class TesteLoaded extends TestesState {
  final Teste teste;

  const TesteLoaded({required this.teste});

  @override
  List<Object?> get props => [teste];
}

class TestesError extends TestesState {
  final String message;

  const TestesError({required this.message});

  @override
  List<Object?> get props => [message];
}
