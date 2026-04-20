import 'package:flutter/material.dart';

class AdminCards extends StatelessWidget {
  final VoidCallback onCreatePaciente;
  final VoidCallback onCreateEmpresa;
  final VoidCallback onCreateKit;
  final VoidCallback onCreateUtilizador;

  const AdminCards({
    Key? key,
    required this.onCreatePaciente,
    required this.onCreateEmpresa,
    required this.onCreateKit,
    required this.onCreateUtilizador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: const Text('Pacientes'),
            subtitle: const Text('Criar / gerenciar pacientes'),
            trailing: ElevatedButton(onPressed: onCreatePaciente, child: const Text('Criar')),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('Empresas'),
            subtitle: const Text('Criar / gerenciar empresas'),
            trailing: ElevatedButton(onPressed: onCreateEmpresa, child: const Text('Criar')),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('Kits'),
            subtitle: const Text('Criar / gerenciar kits'),
            trailing: ElevatedButton(onPressed: onCreateKit, child: const Text('Criar')),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('Utilizadores'),
            subtitle: const Text('Criar / gerenciar utilizadores'),
            trailing: ElevatedButton(onPressed: onCreateUtilizador, child: const Text('Criar')),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('Outros Recursos'),
            subtitle: const Text('Adicionar seeds ou dados de teste para outras tabelas'),
            trailing: const Icon(Icons.more_horiz),
          ),
        ),
      ],
    );
  }
}
