import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final bool active;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.active,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, phone, role, active, createdAt];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
    bool? active,
    DateTime? createdAt,
  }) {
    return User(
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
