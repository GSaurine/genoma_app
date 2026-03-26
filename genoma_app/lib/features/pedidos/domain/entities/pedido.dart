import 'package:equatable/equatable.dart';

class Pedido extends Equatable {
  final String id;
  final String pacienteId;
  final String medicoId;
  final List<String> testeIds;
  final String status;
  final String? observacoes;
  final DateTime dataPedido;
  final DateTime? dataResultado;

  const Pedido({
    required this.id,
    required this.pacienteId,
    required this.medicoId,
    required this.testeIds,
    required this.status,
    this.observacoes,
    required this.dataPedido,
    this.dataResultado,
  });

  @override
  List<Object?> get props => [id, pacienteId];
}
