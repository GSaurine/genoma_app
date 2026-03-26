import 'package:equatable/equatable.dart';
import '../../domain/entities/utilizadores.dart';

abstract class UtilizadoresState extends Equatable {
  const UtilizadoresState();

  @override
  List<Object?> get props => [];
}

class UtilizadoresInitial extends UtilizadoresState {
  const UtilizadoresInitial();
}

class UtilizadoresLoading extends UtilizadoresState {
  const UtilizadoresLoading();
}

class UtilizadoresLoaded extends UtilizadoresState {
  final List<Utilizador> utilizadores;

  const UtilizadoresLoaded({required this.utilizadores});

  @override
  List<Object?> get props => [utilizadores];
}

class UtilizadorLoaded extends UtilizadoresState {
  final Utilizador utilizador;

  const UtilizadorLoaded({required this.utilizador});

  @override
  List<Object?> get props => [utilizador];
}

class UtilizadoresError extends UtilizadoresState {
  final String message;

  const UtilizadoresError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UtilizadorError extends UtilizadoresState {
  final String message;

  const UtilizadorError({required this.message});

  @override
  List<Object?> get props => [message];
}