import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/medicos_cubit.dart';
import '../cubits/medicos_state.dart';

class MedicosListPage extends StatefulWidget {
  const MedicosListPage({super.key});

  @override
  State<MedicosListPage> createState() => _MedicosListPageState();
}

class _MedicosListPageState extends State<MedicosListPage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicosCubit>().getAllMedicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Médicos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('medico-criar'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<MedicosCubit, MedicosState>(
        builder: (context, state) {
          if (state is MedicosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MedicosLoaded) {
            return ListView.builder(
              itemCount: state.medicos.length,
              itemBuilder: (context, index) {
                final medico = state.medicos[index];
                return ListTile(
                  leading: const Icon(Icons.medical_services),
                  title: Text(medico.nome),
                  subtitle: Text(medico.especialidade),
                  onTap: () => context.goNamed('medico-detalhe', pathParameters: {'id': medico.id}),
                );
              },
            );
          } else if (state is MedicosError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}
