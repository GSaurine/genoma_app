import 'package:equatable/equatable.dart';
import '../../domain/entities/resultado.dart';

abstract class ResultadosState extends Equatable {
  const ResultadosState();

  @override
  List<Object?> get props => [];
}

class ResultadosInitial extends ResultadosState {
  const ResultadosInitial();
}

class ResultadosLoading extends ResultadosState {
  const ResultadosLoading();
}

class ResultadosLoaded extends ResultadosState {
  final List<Resultado> resultados;

  const ResultadosLoaded({required this.resultados});

  @override
  List<Object?> get props => [resultados];
}

class ResultadoLoaded extends ResultadosState {
  final Resultado resultado;

  const ResultadoLoaded({required this.resultado});

  @override
  List<Object?> get props => [resultado];
}

class ResultadosError extends ResultadosState {
  final String message;

  const ResultadosError({required this.message});

  @override
  List<Object?> get props => [message];
}
