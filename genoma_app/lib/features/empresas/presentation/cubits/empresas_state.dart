import 'package:equatable/equatable.dart';
import '../../domain/entities/empresa.dart';

abstract class EmpresasState extends Equatable {
  const EmpresasState();

  @override
  List<Object?> get props => [];
}

class EmpresasInitial extends EmpresasState {
  const EmpresasInitial();
}

class EmpresasLoading extends EmpresasState {
  const EmpresasLoading();
}

class EmpresasLoaded extends EmpresasState {
  final List<Empresa> empresas;

  const EmpresasLoaded({required this.empresas});

  @override
  List<Object?> get props => [empresas];
}

class EmpresaLoaded extends EmpresasState {
  final Empresa empresa;

  const EmpresaLoaded({required this.empresa});

  @override
  List<Object?> get props => [empresa];
}

class EmpresasError extends EmpresasState {
  final String message;

  const EmpresasError({required this.message});

  @override
  List<Object?> get props => [message];
}