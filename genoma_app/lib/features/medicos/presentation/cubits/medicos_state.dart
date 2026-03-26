import 'package:equatable/equatable.dart';
import '../../domain/entities/medico.dart';

abstract class MedicosState extends Equatable {
  const MedicosState();

  @override
  List<Object?> get props => [];
}

class MedicosInitial extends MedicosState {
  const MedicosInitial();
}

class MedicosLoading extends MedicosState {
  const MedicosLoading();
}

class MedicosLoaded extends MedicosState {
  final List<Medico> medicos;

  const MedicosLoaded({required this.medicos});

  @override
  List<Object?> get props => [medicos];
}

class MedicoLoaded extends MedicosState {
  final Medico medico;

  const MedicoLoaded({required this.medico});

  @override
  List<Object?> get props => [medico];
}

class MedicosError extends MedicosState {
  final String message;

  const MedicosError({required this.message});

  @override
  List<Object?> get props => [message];
}
