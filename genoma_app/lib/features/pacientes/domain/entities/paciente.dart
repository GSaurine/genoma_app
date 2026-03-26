import 'package:equatable/equatable.dart';

class Paciente extends Equatable {
  final String id;
  final String nome;
  final String cpf;
  final String? dataNascimento;
  final String? telefone;
  final String? email;
  final String? endereco;
  final bool ativo;
  final DateTime criadoEm;

  const Paciente({
    required this.id,
    required this.nome,
    required this.cpf,
    this.dataNascimento,
    this.telefone,
    this.email,
    this.endereco,
    required this.ativo,
    required this.criadoEm,
  });

  @override
  List<Object?> get props => [id, nome, cpf, email];
}
