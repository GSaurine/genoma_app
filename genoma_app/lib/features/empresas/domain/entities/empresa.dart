import 'package:equatable/equatable.dart';

class Empresa extends Equatable {
  final String id;
  final String nome;
  final String cnpj;
  final String? telefone;
  final String? email;
  final String? endereco;
  final bool ativo;
  final DateTime criadoEm;

  const Empresa({
    required this.id,
    required this.nome,
    required this.cnpj,
    this.telefone,
    this.email,
    this.endereco,
    required this.ativo,
    required this.criadoEm,
  });

  @override
  List<Object?> get props => [id, cnpj, email];

  Empresa copyWith({
    String? id,
    String? nome,
    String? cnpj,
    String? telefone,
    String? email,
    String? endereco,
    bool? ativo,
    DateTime? criadoEm,
  }) {
    return Empresa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      endereco: endereco ?? this.endereco,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}