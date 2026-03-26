import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/resultados_cubit.dart';
import '../cubits/resultados_state.dart';

class ResultadosListPage extends StatefulWidget {
  const ResultadosListPage({super.key});

  @override
  State<ResultadosListPage> createState() => _ResultadosListPageState();
}

class _ResultadosListPageState extends State<ResultadosListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ResultadosCubit>().getAllResultados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: BlocBuilder<ResultadosCubit, ResultadosState>(
        builder: (context, state) {
          if (state is ResultadosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResultadosLoaded) {
            return ListView.builder(
              itemCount: state.resultados.length,
              itemBuilder: (context, index) {
                final resultado = state.resultados[index];
                return ListTile(
                  leading: Icon(
                    resultado.anormal ? Icons.warning : Icons.check_circle,
                    color: resultado.anormal ? Colors.red : Colors.green,
                  ),
                  title: Text('Resultado #${resultado.id}'),
                  subtitle: Text(resultado.valor),
                );
              },
            );
          } else if (state is ResultadosError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}
