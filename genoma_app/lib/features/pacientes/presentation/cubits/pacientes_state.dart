import 'package:equatable/equatable.dart';
import '../../domain/entities/paciente.dart';

abstract class PacientesState extends Equatable {
  const PacientesState();

  @override
  List<Object?> get props => [];
}

class PacientesInitial extends PacientesState {
  const PacientesInitial();
}

class PacientesLoading extends PacientesState {
  const PacientesLoading();
}

class PacientesLoaded extends PacientesState {
  final List<Paciente> pacientes;

  const PacientesLoaded({required this.pacientes});

  @override
  List<Object?> get props => [pacientes];
}

class PacienteLoaded extends PacientesState {
  final Paciente paciente;

  const PacienteLoaded({required this.paciente});

  @override
  List<Object?> get props => [paciente];
}

class PacientesError extends PacientesState {
  final String message;

  const PacientesError({required this.message});

  @override
  List<Object?> get props => [message];
}
