import 'package:equatable/equatable.dart';

class Medico extends Equatable {
  final String id;
  final String nome;
  final String crm;
  final String especialidade;
  final String? telefone;
  final String? email;
  final String? endereco;
  final bool ativo;
  final DateTime criadoEm;

  const Medico({
    required this.id,
    required this.nome,
    required this.crm,
    required this.especialidade,
    this.telefone,
    this.email,
    this.endereco,
    required this.ativo,
    required this.criadoEm,
  });

  @override
  List<Object?> get props => [id, crm, email];
}
