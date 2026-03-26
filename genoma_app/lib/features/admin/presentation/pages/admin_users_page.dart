import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genoma_app/features/utilizadores/domain/entities/utilizadores.dart';
import 'package:genoma_app/features/utilizadores/presentation/cubits/utilizadores_cubit.dart';
import 'package:genoma_app/features/utilizadores/presentation/cubits/utilizadores_state.dart';
import '../../../../shared/widgets/custom_card.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  @override
  void initState() {
    super.initState();
    context.read<UtilizadoresCubit>().getAllUtilizadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Utilizadores'),
      ),
      body: BlocBuilder<UtilizadoresCubit, UtilizadoresState>(
        builder: (context, state) {
          if (state is UtilizadoresLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UtilizadoresLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.utilizadores.length,
              itemBuilder: (context, index) {
                final utilizador = state.utilizadores[index];
                return _buildUserCard(context, utilizador);
              },
            );
          } else if (state is UtilizadoresError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Nenhum utilizador encontrado.'));
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Utilizador utilizador) {
    return CustomCard(
      padding: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, color: Theme.of(context).primaryColor),
        ),
        title: Text(utilizador.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(utilizador.email),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getRoleColor(utilizador.role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                utilizador.role.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: _getRoleColor(utilizador.role),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (newRole) {
            _showUpdateRoleDialog(context, utilizador, newRole);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'admin', child: Text('Mudar para Admin')),
            const PopupMenuItem(value: 'user', child: Text('Mudar para User')),
            const PopupMenuItem(value: 'medico', child: Text('Mudar para Médico')),
            const PopupMenuItem(value: 'tecnico', child: Text('Mudar para Técnico')),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'medico':
        return Colors.blue;
      case 'tecnico':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _showUpdateRoleDialog(BuildContext context, Utilizador utilizador, String newRole) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Perfil'),
        content: Text('Deseja mudar o perfil de ${utilizador.name} para $newRole?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedUtilizador = utilizador.copyWith(role: newRole);
              this.context.read<UtilizadoresCubit>().updateUtilizador(updatedUtilizador);
              Navigator.pop(context);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
