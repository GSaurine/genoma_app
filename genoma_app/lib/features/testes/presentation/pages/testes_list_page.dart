import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/testes_cubit.dart';
import '../cubits/testes_state.dart';

class TestesListPage extends StatefulWidget {
  const TestesListPage({super.key});

  @override
  State<TestesListPage> createState() => _TestesListPageState();
}

class _TestesListPageState extends State<TestesListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TestesCubit>().getAllTestes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('teste-criar'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TestesCubit, TestesState>(
        builder: (context, state) {
          if (state is TestesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TestesLoaded) {
            return ListView.builder(
              itemCount: state.testes.length,
              itemBuilder: (context, index) {
                final teste = state.testes[index];
                return ListTile(
                  leading: const Icon(Icons.assessment),
                  title: Text(teste.nome),
                  subtitle: Text(teste.codigo),
                  onTap: () => context.goNamed('teste-detalhe', pathParameters: {'id': teste.id}),
                );
              },
            );
          } else if (state is TestesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}
