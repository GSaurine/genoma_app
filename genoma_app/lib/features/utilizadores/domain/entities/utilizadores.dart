import 'package:equatable/equatable.dart';

class Utilizador extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final bool active;
  final DateTime createdAt;

  const Utilizador({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.active,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name];

  Utilizador copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
    bool? active,
    DateTime? createdAt,
  }) {
    return Utilizador(
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