import 'package:equatable/equatable.dart';

class Resultado extends Equatable {
  final String id;
  final String pedidoId;
  final String testeId;
  final String valor;
  final String? unidade;
  final String? referencia;
  final bool anormal;
  final DateTime dataResultado;

  const Resultado({
    required this.id,
    required this.pedidoId,
    required this.testeId,
    required this.valor,
    this.unidade,
    this.referencia,
    required this.anormal,
    required this.dataResultado,
  });

  @override
  List<Object?> get props => [id, pedidoId];
}
