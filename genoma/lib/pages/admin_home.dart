import 'package:flutter/material.dart';
import 'package:genoma/services/paciente_service.dart';
import 'package:genoma/services/empresas_service.dart';
import 'package:genoma/services/kits_service.dart';
import 'package:genoma/services/perfis_service.dart';
import 'package:genoma/services/utilizadores_service.dart';
import 'package:genoma/services/processos_service.dart';
import 'package:genoma/services/medicos_service.dart';
import 'package:genoma/services/postos_service.dart';
import 'package:genoma/services/testes_service.dart';
import 'package:genoma/services/itens_pesquisa_service.dart';
import 'package:genoma/services/resultados_service.dart';
import 'package:genoma/services/resultados_geneticos_service.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/core/config/dioConfig.dart';
import 'package:genoma/core/ui/notification_service.dart';
import 'package:genoma/widgets/admin_cards.dart';
import 'package:genoma/widgets/create_dialogs.dart';
import 'package:genoma/widgets/table_chip.dart';
import 'package:genoma/pages/table_list_page.dart';

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
  final _processosService = ProcessosService();
  final _medicosService = MedicosService();
  final _postosService = PostosService();
  final _testesService = TestesService();
  final _itensService = ItensPesquisaService();
  final _resultadosService = ResultadosService();
  final _resultadosGeneticosService = ResultadosGeneticosService();

  @override
  void initState() {
    super.initState();
    _ensureAdmin();
    try {
      // ignore: avoid_print
      print('AdminHome.initState currentUser=${AuthFacade().currentUser}');
    } catch (e) {
      // ignore: avoid_print
      print('AdminHome.initState error: $e');
    }
  }

  Future<void> _ensureAdmin() async {
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

  Future<void> _showCreateProcessoDialog() async {
    final result = await showCreateProcessoDialog(context, _processosService, _pacienteService, _medicosService, _kitsService, _postosService);
    if (result == true) {
      NotificationService().showSuccess('Processo criado com sucesso');
    }
  }

  Future<void> _showCreatePerfilDialog() async {
    final result = await showCreatePerfilDialog(context, _perfisService);
    if (result == true) NotificationService().showSuccess('Perfil criado com sucesso');
  }

  Future<void> _showCreateMedicoDialog() async {
    final result = await showCreateMedicoDialog(context, _medicosService, _utilizadoresService);
    if (result == true) NotificationService().showSuccess('Médico criado com sucesso');
  }

  Future<void> _showCreateTesteDialog() async {
    final result = await showCreateTesteDialog(context, _testesService, _itensService);
    if (result == true) NotificationService().showSuccess('Teste criado com sucesso');
  }

  Future<void> _showCreateItemDialog() async {
    final result = await showCreateItemDialog(context, _itensService);
    if (result == true) NotificationService().showSuccess('Item de pesquisa criado com sucesso');
  }

  Future<void> _showCreatePostoDialog() async {
    final result = await showCreatePostoDialog(context, _postosService, _empresasService);
    if (result == true) NotificationService().showSuccess('Posto criado com sucesso');
  }

  Future<void> _showCreateResultadoDialog() async {
    final result = await showCreateResultadoDialog(context, _resultadosService, _processosService, _itensService);
    if (result == true) NotificationService().showSuccess('Resultado criado com sucesso');
  }

  Future<void> _showCreateResultadoGeneticoDialog() async {
    final result = await showCreateResultadoGeneticoDialog(context, _resultadosGeneticosService, _processosService);
    if (result == true) NotificationService().showSuccess('Resultado genético criado com sucesso');
  }

  void _onOperationsTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Hub de Operações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.add_chart, color: Colors.green),
              title: const Text('Novo Processo de Exame'),
              onTap: () {
                Navigator.pop(ctx);
                _showCreateProcessoDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.blue),
              title: const Text('Gerir Processos Ativos'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage(endpoint: '/processos', title: 'Processos')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.orange),
              title: const Text('Faturação'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage(endpoint: '/facturacao', title: 'Faturação')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onStaffTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Gestão de Staff', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.deepPurple),
              title: const Text('Criar Utilizador / Médico'),
              onTap: () {
                Navigator.pop(ctx);
                _showCreateUtilizadorDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_ind, color: Colors.blue),
              title: const Text('Listar Utilizadores'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage(endpoint: '/utilizadores', title: 'Utilizadores')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onPartnersTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Rede de Parceiros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.business_center, color: Colors.blue),
              title: const Text('Criar Nova Empresa'),
              onTap: () {
                Navigator.pop(ctx);
                _showCreateEmpresaDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: const Text('Criar Novo Posto'),
              onTap: () {
                Navigator.pop(ctx);
                _showCreatePostoDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.apartment, color: Colors.grey),
              title: const Text('Gerir Empresas'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage(endpoint: '/empresas', title: 'Empresas')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onCatalogTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Catálogo & Configuração', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.add_task, color: Colors.orange),
              title: const Text('Configurar Novo Teste (Catálogo)'),
              onTap: () {
                Navigator.pop(ctx);
                _showCreateTesteDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.science, color: Colors.orange),
              title: const Text('Gerir Testes Existentes'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage(endpoint: '/testes', title: 'Testes')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.grey),
              title: const Text('Itens de Pesquisa'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage(endpoint: '/itens', title: 'Itens de Pesquisa')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
            onOperationsTap: _onOperationsTap,
            onStaffTap: _onStaffTap,
            onPartnersTap: _onPartnersTap,
            onCatalogTap: _onCatalogTap,
          ),
          const SizedBox(height: 12),
          Card(
            child: ExpansionTile(
              title: const Text('Atalhos de Dados (Pacientes & Kits)'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TableChip(label: 'Pacientes', endpoint: '/pacientes'),
                      TableChip(label: 'Kits', endpoint: '/kits'),
                      TextButton.icon(
                        onPressed: _showCreatePacienteDialog, 
                        icon: const Icon(Icons.add, size: 16), 
                        label: const Text('Novo Paciente')
                      ),
                      TextButton.icon(
                        onPressed: _showCreateKitDialog, 
                        icon: const Icon(Icons.add, size: 16), 
                        label: const Text('Novo Kit')
                      ),
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
