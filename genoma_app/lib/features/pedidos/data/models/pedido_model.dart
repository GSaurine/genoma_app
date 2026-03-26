import 'package:genoma_app/features/pedidos/domain/entities/pedido.dart';

class PedidoModel extends Pedido {
  const PedidoModel({
    required super.id,
    required super.pacienteId,
    required super.medicoId,
    required super.testeIds,
    required super.status,
    super.observacoes,
    required super.dataPedido,
    super.dataResultado,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      id: json['id'] as String,
      pacienteId: json['pacienteId'] as String,
      medicoId: json['medicoId'] as String,
      testeIds: List<String>.from(json['testeIds'] as List? ?? []),
      status: json['status'] as String,
      observacoes: json['observacoes'] as String?,
      dataPedido: DateTime.tryParse(json['dataPedido'] as String? ?? '') ?? DateTime.now(),
      dataResultado: json['dataResultado'] != null ? DateTime.tryParse(json['dataResultado'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pacienteId': pacienteId,
      'medicoId': medicoId,
      'testeIds': testeIds,
      'status': status,
      'observacoes': observacoes,
      'dataPedido': dataPedido.toIso8601String(),
      'dataResultado': dataResultado?.toIso8601String(),
    };
  }
}
