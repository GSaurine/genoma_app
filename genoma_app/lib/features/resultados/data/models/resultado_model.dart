import 'package:genoma_app/features/resultados/domain/entities/resultado.dart';

class ResultadoModel extends Resultado {
  const ResultadoModel({
    required super.id,
    required super.pedidoId,
    required super.testeId,
    required super.valor,
    super.unidade,
    super.referencia,
    required super.anormal,
    required super.dataResultado,
  });

  factory ResultadoModel.fromJson(Map<String, dynamic> json) {
    return ResultadoModel(
      id: json['id'] as String,
      pedidoId: json['pedidoId'] as String,
      testeId: json['testeId'] as String,
      valor: json['valor'] as String,
      unidade: json['unidade'] as String?,
      referencia: json['referencia'] as String?,
      anormal: json['anormal'] as bool? ?? false,
      dataResultado: DateTime.tryParse(json['dataResultado'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'testeId': testeId,
      'valor': valor,
      'unidade': unidade,
      'referencia': referencia,
      'anormal': anormal,
      'dataResultado': dataResultado.toIso8601String(),
    };
  }
}
