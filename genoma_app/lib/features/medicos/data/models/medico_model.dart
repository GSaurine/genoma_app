import 'package:genoma_app/features/medicos/domain/entities/medico.dart';

class MedicoModel extends Medico {
  const MedicoModel({
    required super.id,
    required super.nome,
    required super.crm,
    required super.especialidade,
    super.telefone,
    super.email,
    super.endereco,
    required super.ativo,
    required super.criadoEm,
  });

  factory MedicoModel.fromJson(Map<String, dynamic> json) {
    return MedicoModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      crm: json['crm'] as String,
      especialidade: json['especialidade'] as String,
      telefone: json['telefone'] as String?,
      email: json['email'] as String?,
      endereco: json['endereco'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      criadoEm: DateTime.tryParse(json['criadoEm'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'crm': crm,
      'especialidade': especialidade,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
      'ativo': ativo,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }
}
