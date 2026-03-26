import 'package:equatable/equatable.dart';

class Teste extends Equatable {
  final String id;
  final String nome;
  final String codigo;
  final String? descricao;
  final String? metodo;
  final String? materiais;
  final bool ativo;
  final DateTime criadoEm;

  const Teste({
    required this.id,
    required this.nome,
    required this.codigo,
    this.descricao,
    this.metodo,
    this.materiais,
    required this.ativo,
    required this.criadoEm,
  });

  @override
  List<Object?> get props => [id, codigo];
}
