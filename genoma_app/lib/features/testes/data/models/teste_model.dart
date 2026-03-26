import 'package:genoma_app/features/testes/domain/entities/teste.dart';

class TesteModel extends Teste {
  const TesteModel({
    required super.id,
    required super.nome,
    required super.codigo,
    super.descricao,
    super.metodo,
    super.materiais,
    required super.ativo,
    required super.criadoEm,
  });

  factory TesteModel.fromJson(Map<String, dynamic> json) {
    return TesteModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      codigo: json['codigo'] as String,
      descricao: json['descricao'] as String?,
      metodo: json['metodo'] as String?,
      materiais: json['materiais'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      criadoEm: DateTime.tryParse(json['criadoEm'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'codigo': codigo,
      'descricao': descricao,
      'metodo': metodo,
      'materiais': materiais,
      'ativo': ativo,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }
}
