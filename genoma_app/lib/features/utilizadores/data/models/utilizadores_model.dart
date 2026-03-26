import 'package:genoma_app/features/utilizadores/domain/entities/utilizadores.dart';

class UtilizadorModel extends Utilizador {
  const UtilizadorModel({
    required super.id,
    required super.email,
    required super.name,
    super.phone,
    required super.role,
    required super.active,
    required super.createdAt,
  });

  factory UtilizadorModel.fromJson(Map<String, dynamic> json) {
    return UtilizadorModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'user',
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  UtilizadorModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
    bool? active,
    DateTime? createdAt,
  }) {
    return UtilizadorModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}