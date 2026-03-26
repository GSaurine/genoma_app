import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/utilizadores_cubit.dart';
import '../cubits/utilizadores_state.dart';

class UtilizadoresListPage extends StatefulWidget {
  const UtilizadoresListPage({super.key});

  @override
  State<UtilizadoresListPage> createState() => _UtilizadoresListPageState();
}

class _UtilizadoresListPageState extends State<UtilizadoresListPage> {
  @override
  void initState() {
    super.initState();
    context.read<UtilizadoresCubit>().getAllUtilizadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Utilizadores')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('utilizador-criar'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<UtilizadoresCubit, UtilizadoresState>(
        builder: (context, state) {
          if (state is UtilizadoresLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UtilizadoresLoaded) {
            return ListView.builder(
              itemCount: state.utilizadores.length,
              itemBuilder: (context, index) {
                final utilizador = state.utilizadores[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(utilizador.name),
                  subtitle: Text(utilizador.email),
                  onTap: () => context.goNamed('utilizador-detalhe', pathParameters: {'id': utilizador.id}),
                );
              },
            );
          } else if (state is UtilizadoresError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}