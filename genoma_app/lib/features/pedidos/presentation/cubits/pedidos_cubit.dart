import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/pedidos_repository.dart';
import 'pedidos_state.dart';

class PedidosCubit extends Cubit<PedidosState> {
  final PedidosRepository repository;

  PedidosCubit({required this.repository}) : super(const PedidosInitial());

  Future<void> getAllPedidos() async {
    emit(const PedidosLoading());
    final result = await repository.getAllPedidos();
    result.fold(
      (failure) => emit(PedidosError(message: failure.message)),
      (pedidos) => emit(PedidosLoaded(pedidos: pedidos)),
    );
  }

  Future<void> getPedidoById(String id) async {
    emit(const PedidosLoading());
    final result = await repository.getPedidoById(id);
    result.fold(
      (failure) => emit(PedidosError(message: failure.message)),
      (pedido) => emit(PedidoLoaded(pedido: pedido)),
    );
  }
}
