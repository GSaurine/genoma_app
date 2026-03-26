import 'package:equatable/equatable.dart';
import '../../domain/entities/pedido.dart';

abstract class PedidosState extends Equatable {
  const PedidosState();

  @override
  List<Object?> get props => [];
}

class PedidosInitial extends PedidosState {
  const PedidosInitial();
}

class PedidosLoading extends PedidosState {
  const PedidosLoading();
}

class PedidosLoaded extends PedidosState {
  final List<Pedido> pedidos;

  const PedidosLoaded({required this.pedidos});

  @override
  List<Object?> get props => [pedidos];
}

class PedidoLoaded extends PedidosState {
  final Pedido pedido;

  const PedidoLoaded({required this.pedido});

  @override
  List<Object?> get props => [pedido];
}

class PedidosError extends PedidosState {
  final String message;

  const PedidosError({required this.message});

  @override
  List<Object?> get props => [message];
}
