import 'package:flutter/material.dart';

class GenericAdminTablePage extends StatelessWidget {
  final String title;

  const GenericAdminTablePage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de $title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Página de $title em desenvolvimento',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Esta funcionalidade de CRUD será implementada em breve.'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Criação de $title em breve!')),
                );
              },
              icon: const Icon(Icons.add),
              label: Text('Adicionar Novo(a) $title'),
            ),
          ],
        ),
      ),
    );
  }
}
