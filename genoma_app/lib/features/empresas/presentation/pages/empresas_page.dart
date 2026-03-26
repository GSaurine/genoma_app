import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/empresas_cubit.dart';
import '../cubits/empresas_state.dart';

class EmpresasPage extends StatefulWidget {
  const EmpresasPage({super.key});

  @override
  State<EmpresasPage> createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  @override
  void initState() {
    super.initState();
    context.read<EmpresasCubit>().getAllEmpresas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empresas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('empresa-criar'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EmpresasCubit, EmpresasState>(
        builder: (context, state) {
          if (state is EmpresasLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmpresasLoaded) {
            return ListView.builder(
              itemCount: state.empresas.length,
              itemBuilder: (context, index) {
                final empresa = state.empresas[index];
                return ListTile(
                  leading: const Icon(Icons.business),
                  title: Text(empresa.nome),
                  subtitle: Text(empresa.cnpj),
                  onTap: () => context.goNamed('empresa-detalhe', pathParameters: {'id': empresa.id}),
                );
              },
            );
          } else if (state is EmpresasError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}