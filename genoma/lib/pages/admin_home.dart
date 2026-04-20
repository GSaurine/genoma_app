import 'package:flutter/material.dart';
import 'package:genoma/pages/table_list_page.dart';
import 'package:genoma/services/paciente_service.dart';
import 'package:genoma/services/empresas_service.dart';
import 'package:genoma/services/kits_service.dart';
import 'package:genoma/services/perfis_service.dart';
import 'package:genoma/services/utilizadores_service.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/core/config/dioConfig.dart';
import 'package:genoma/core/ui/notification_service.dart';
import 'package:genoma/widgets/admin_cards.dart';
import 'package:genoma/widgets/create_dialogs.dart';
import 'package:genoma/widgets/table_chip.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _pacienteService = PacienteService();
  final _empresasService = EmpresasService();
  final _kitsService = KitsService();
  final _perfisService = PerfisService();
  final _utilizadoresService = UtilizadoresService();

  @override
  void initState() {
    super.initState();
    _ensureAdmin();
    // Debug log to help identify runtime errors that cause black screen
    try {
      // ignore: avoid_print
      print('AdminHome.initState currentUser=${AuthFacade().currentUser}');
    } catch (e) {
      // ignore: avoid_print
      print('AdminHome.initState error: $e');
    }
  }

  Future<void> _ensureAdmin() async {
    // Garante que o perfil do utilizador esteja carregado e verifica permissões
    try {
      final token = await AuthFacade().getSavedToken();
      if (token != null && token.isNotEmpty) APIService().token = token;

      if (AuthFacade().currentUser == null) {
        await AuthFacade().fetchCurrentUser();
      }
    } catch (_) {}

    if (!AuthFacade().isAdmin) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _showCreatePacienteDialog() async {
    final result = await showCreatePacienteDialog(context, _pacienteService);
    if (result == true) {
      NotificationService().showSuccess('Paciente criado com sucesso');
    } else if (result == false) {
      NotificationService().showError('Operação cancelada ou falhou');
    }
  }

  Future<void> _showCreateEmpresaDialog() async {
    final result = await showCreateEmpresaDialog(context, _empresasService);
    if (result == true) NotificationService().showSuccess('Empresa criada com sucesso');
  }

  Future<void> _showCreateKitDialog() async {
    final result = await showCreateKitDialog(context, _kitsService);
    if (result == true) NotificationService().showSuccess('Kit criado com sucesso');
  }

  Future<void> _showCreateUtilizadorDialog() async {
    final result = await showCreateUtilizadorDialog(context, _utilizadoresService, _perfisService, _empresasService);
    if (result == true) NotificationService().showSuccess('Utilizador criado com sucesso');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await AuthFacade().logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AdminCards(
            onCreatePaciente: _showCreatePacienteDialog,
            onCreateEmpresa: _showCreateEmpresaDialog,
            onCreateKit: _showCreateKitDialog,
            onCreateUtilizador: _showCreateUtilizadorDialog,
          ),
          const SizedBox(height: 12),
          Card(
            child: ExpansionTile(
              title: const Text('Tabelas (Visualizar / Editar)'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      TableChip(label: 'Pacientes', endpoint: '/pacientes'),
                      TableChip(label: 'Utilizadores', endpoint: '/utilizadores'),
                      TableChip(label: 'Empresas', endpoint: '/empresas'),
                      TableChip(label: 'Perfis', endpoint: '/perfis'),
                      TableChip(label: 'Kits', endpoint: '/kits'),
                      TableChip(label: 'Pedidos', endpoint: '/pedidos'),
                      TableChip(label: 'Testes', endpoint: '/testes'),
                      TableChip(label: 'Itens', endpoint: '/itens'),
                      TableChip(label: 'Medicos', endpoint: '/medicos'),
                      TableChip(label: 'Resultados', endpoint: '/resultados'),
                      TableChip(label: 'Resultados Genéticos', endpoint: '/resultados-geneticos'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
