import 'package:flutter/material.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/services/paciente_service.dart';
import 'package:genoma/widgets/create_dialogs.dart';
import 'package:genoma/core/ui/notification_service.dart';

class MedicoHome extends StatefulWidget {
  const MedicoHome({super.key});

  @override
  State<MedicoHome> createState() => _MedicoHomeState();
}

class _MedicoHomeState extends State<MedicoHome> {
  final _pacienteService = PacienteService();

  bool _loading = true;
  List<Map<String, dynamic>> _pacientes = [];
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _loading = true);
    try {
      _userData = AuthFacade().currentUser;
      _pacientes = await _pacienteService.fetchPacientes();
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleCreatePaciente() async {
    final result = await showCreatePacienteDialog(context, _pacienteService);
    if (result == true) {
      NotificationService().showSuccess('Paciente criado com sucesso');
      _loadInitialData();
    }
  }

  void _showAccountMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final user = _userData ?? {};
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Minha Conta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Nome'),
                subtitle: Text(user['nome'] ?? 'N/A'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(user['email'] ?? 'N/A'),
              ),
              ListTile(
                leading: const Icon(Icons.badge),
                title: const Text('Perfil'),
                subtitle: Text(user['perfil_nome'] ?? 'Médico'),
              ),
              if (user['num_ordem'] != null)
                ListTile(
                  leading: const Icon(Icons.assignment_ind),
                  title: const Text('Nº de Ordem'),
                  subtitle: Text(user['num_ordem'].toString()),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50, 
                    foregroundColor: Colors.red,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await AuthFacade().logout();
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Sair da Conta'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Criar Novo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.person_add, color: Theme.of(context).primaryColor),
                title: const Text('Novo Paciente'),
                onTap: () {
                  Navigator.pop(context);
                  _handleCreatePaciente();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal do Médico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _showAccountMenu,
            tooltip: 'Minha Conta',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInitialData,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: theme.colorScheme.primaryContainer,
                                child: Icon(Icons.person, size: 40, color: theme.colorScheme.primary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _userData?['nome'] ?? 'Dr(a). Médico',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _userData?['email'] ?? 'N/A',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          if (_userData?['num_ordem'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.assignment_ind, size: 18, color: theme.primaryColor),
                                  const SizedBox(width: 8),
                                  Text('Nº Ordem: ${_userData?['num_ordem']}'),
                                ],
                              ),
                            ),
                          Row(
                            children: [
                              Icon(Icons.badge, size: 18, color: theme.primaryColor),
                              const SizedBox(width: 8),
                              Text('Perfil: ${_userData?['perfil_nome'] ?? 'Médico'}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/pacientes'),
                      icon: const Icon(Icons.people, size: 28),
                      label: const Text(
                        'VER LISTA DE PACIENTES',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton.icon(
                      onPressed: _handleCreatePaciente,
                      icon: const Icon(Icons.person_add, size: 28),
                      label: const Text(
                        'CRIAR NOVO PACIENTE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateMenu,
        tooltip: 'Adicionar',
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
