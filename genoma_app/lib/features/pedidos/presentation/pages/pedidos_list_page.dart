import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/pedidos_cubit.dart';
import '../cubits/pedidos_state.dart';

class PedidosListPage extends StatefulWidget {
  const PedidosListPage({super.key});

  @override
  State<PedidosListPage> createState() => _PedidosListPageState();
}

class _PedidosListPageState extends State<PedidosListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PedidosCubit>().getAllPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos de Exames')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('pedido-criar'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PedidosCubit, PedidosState>(
        builder: (context, state) {
          if (state is PedidosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PedidosLoaded) {
            return ListView.builder(
              itemCount: state.pedidos.length,
              itemBuilder: (context, index) {
                final pedido = state.pedidos[index];
                return ListTile(
                  leading: const Icon(Icons.assignment),
                  title: Text('Pedido #${pedido.id}'),
                  subtitle: Text(pedido.status),
                  onTap: () => context.goNamed('pedido-detalhe', pathParameters: {'id': pedido.id}),
                );
              },
            );
          } else if (state is PedidosError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}
