import 'package:genoma_app/features/empresas/domain/entities/empresa.dart';

class EmpresaModel extends Empresa {
  const EmpresaModel({
    required super.id,
    required super.nome,
    required super.cnpj,
    super.endereco,
    super.telefone,
    super.email,
    required super.ativo,
    required super.criadoEm,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cnpj: json['cnpj'] as String,
      endereco: json['endereco'] as String?,
      telefone: json['telefone'] as String?,
      email: json['email'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      criadoEm: DateTime.tryParse(json['criadoEm'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'ativo': ativo,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }

  @override
  EmpresaModel copyWith({
    String? id,
    String? nome,
    String? cnpj,
    String? endereco,
    String? telefone,
    String? email,
    bool? ativo,
    DateTime? criadoEm,
  }) {
    return EmpresaModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      endereco: endereco ?? this.endereco,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
