import 'package:genoma_app/features/pacientes/domain/entities/paciente.dart';

class PacienteModel extends Paciente {
  const PacienteModel({
    required super.id,
    required super.nome,
    required super.cpf,
    super.dataNascimento,
    super.telefone,
    super.email,
    super.endereco,
    required super.ativo,
    required super.criadoEm,
  });

  factory PacienteModel.fromJson(Map<String, dynamic> json) {
    return PacienteModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cpf: json['cpf'] as String,
      dataNascimento: json['dataNascimento'] as String?,
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
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
      'ativo': ativo,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }
}
