import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/pacientes_cubit.dart';
import '../cubits/pacientes_state.dart';

class PacientesListPage extends StatefulWidget {
  const PacientesListPage({super.key});

  @override
  State<PacientesListPage> createState() => _PacientesListPageState();
}

class _PacientesListPageState extends State<PacientesListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PacientesCubit>().getAllPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('paciente-criar'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PacientesCubit, PacientesState>(
        builder: (context, state) {
          if (state is PacientesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PacientesLoaded) {
            return ListView.builder(
              itemCount: state.pacientes.length,
              itemBuilder: (context, index) {
                final paciente = state.pacientes[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(paciente.nome),
                  subtitle: Text(paciente.cpf),
                  onTap: () => context.goNamed('paciente-detalhe', pathParameters: {'id': paciente.id}),
                );
              },
            );
          } else if (state is PacientesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}
