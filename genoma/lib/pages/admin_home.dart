import 'package:flutter/material.dart';
import 'package:genoma/services/paciente_service.dart';
import 'package:genoma/services/empresas_service.dart';
import 'package:genoma/services/kits_service.dart';
import 'package:genoma/services/perfis_service.dart';
import 'package:genoma/services/utilizadores_service.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/core/config/dioConfig.dart';

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
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final nifController = TextEditingController();
    final telController = TextEditingController();

    DateTime? selectedDate;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
        title: const Text('Criar Paciente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(selectedDate == null ? 'Data de nascimento não selecionada' : selectedDate.toIso8601String().split('T')[0]),
                  ),
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: ctx2,
                        initialDate: DateTime(now.year - 30, now.month, now.day),
                        firstDate: DateTime(1900),
                        lastDate: now,
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: nifController, decoration: const InputDecoration(labelText: 'NIF')),
              TextField(controller: telController, decoration: const InputDecoration(labelText: 'Telemóvel')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx2).pop(false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              // Validações mínimas antes de enviar
              if (nomeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, insira o nome do paciente')));
                return;
              }
              if (selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, selecione a data de nascimento')));
                return;
              }

              final data = {
                'nome': nomeController.text.trim(),
                'data_nascimento': selectedDate!.toIso8601String().split('T')[0],
                'email': emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                'nif': nifController.text.trim().isEmpty ? null : nifController.text.trim(),
                'telemovel': telController.text.trim().isEmpty ? null : telController.text.trim(),
              };
              try {
                final created = await _pacienteService.createPaciente(data);
                if (created != null) {
                  Navigator.of(ctx2).pop(true);
                } else {
                  Navigator.of(ctx2).pop(false);
                }
              } catch (e) {
                // Mostrar erro para ajudar debug
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao criar paciente: ${e.toString()}')));
                Navigator.of(ctx2).pop(false);
              }
            },
            child: const Text('Criar')),
        ],
      )),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paciente criado com sucesso')));
    } else if (result == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Operação cancelada ou falhou')));
    }
  }

  Future<void> _showCreateEmpresaDialog() async {
    final nome = TextEditingController();
    final morada = TextEditingController();
    final codigo = TextEditingController();
    final telefone = TextEditingController();
    final email = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Criar Empresa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: morada, decoration: const InputDecoration(labelText: 'Morada')),
              TextField(controller: codigo, decoration: const InputDecoration(labelText: 'Código Postal')),
              TextField(controller: telefone, decoration: const InputDecoration(labelText: 'Telefone')),
              TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () async {
            final data = {
              'nome': nome.text.trim(),
              'morada': morada.text.trim().isEmpty ? null : morada.text.trim(),
              'codigo_postal': codigo.text.trim().isEmpty ? null : codigo.text.trim(),
              'telefone': telefone.text.trim().isEmpty ? null : telefone.text.trim(),
              'email': email.text.trim().isEmpty ? null : email.text.trim(),
            };
            try {
              final created = await _empresasService.createEmpresa(data);
              Navigator.of(ctx).pop(created != null);
            } catch (e) {
              Navigator.of(ctx).pop(false);
            }
          }, child: const Text('Criar')),
        ],
      ),
    );

    if (result == true) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Empresa criada com sucesso')));
  }

  Future<void> _showCreateKitDialog() async {
    final codigo = TextEditingController();
    final descricao = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Criar Kit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codigo, decoration: const InputDecoration(labelText: 'Código de Barras')),
              TextField(controller: descricao, decoration: const InputDecoration(labelText: 'Descrição')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () async {
            final data = {
              'codigo_barras': codigo.text.trim(),
              'descricao': descricao.text.trim().isEmpty ? null : descricao.text.trim(),
            };
            try {
              final created = await _kitsService.createKit(data);
              Navigator.of(ctx).pop(created != null);
            } catch (e) {
              Navigator.of(ctx).pop(false);
            }
          }, child: const Text('Criar')),
        ],
      ),
    );

    if (result == true) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kit criado com sucesso')));
  }

  Future<void> _showCreateUtilizadorDialog() async {
    final nome = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    final telefone = TextEditingController();
    String? selectedPerfilId;
    String? selectedEmpresaId;

    // Carregar perfis e empresas para dropdowns
    List<Map<String, dynamic>> perfis = [];
    List<Map<String, dynamic>> empresas = [];
    try {
      perfis = await _perfisService.fetchPerfis();
      empresas = await _empresasService.fetchEmpresas();
    } catch (_) {}

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
        title: const Text('Criar Utilizador'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: password, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
              TextField(controller: telefone, decoration: const InputDecoration(labelText: 'Telefone')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Perfil'),
                items: perfis.map((p) => DropdownMenuItem(value: p['id']?.toString(), child: Text(p['nome'] ?? '-'))).toList(),
                initialValue: selectedPerfilId,
                onChanged: (v) => setState(() => selectedPerfilId = v),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Empresa (opcional)'),
                items: empresas.map((e) => DropdownMenuItem(value: e['id']?.toString(), child: Text(e['nome'] ?? '-'))).toList(),
                initialValue: selectedEmpresaId,
                onChanged: (v) => setState(() => selectedEmpresaId = v),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () async {
            final data = {
              'nome': nome.text.trim(),
              'email': email.text.trim(),
              'password': password.text,
              'telefone': telefone.text.trim().isEmpty ? null : telefone.text.trim(),
              'perfil_id': selectedPerfilId,
              'empresa_id': selectedEmpresaId,
            }..removeWhere((k, v) => v == null);
            try {
              final created = await _utilizadoresService.createUtilizador(data);
              Navigator.of(ctx).pop(created != null);
            } catch (e) {
              Navigator.of(ctx).pop(false);
            }
          }, child: const Text('Criar')),
        ],
      )),
    );

    if (result == true) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Utilizador criado com sucesso')));
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
          Card(
            child: ListTile(
              title: const Text('Pacientes'),
              subtitle: const Text('Criar / gerenciar pacientes'),
              trailing: ElevatedButton(onPressed: _showCreatePacienteDialog, child: const Text('Criar')),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Empresas'),
              subtitle: const Text('Criar / gerenciar empresas'),
              trailing: ElevatedButton(onPressed: _showCreateEmpresaDialog, child: const Text('Criar')),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Kits'),
              subtitle: const Text('Criar / gerenciar kits'),
              trailing: ElevatedButton(onPressed: _showCreateKitDialog, child: const Text('Criar')),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Utilizadores'),
              subtitle: const Text('Criar / gerenciar utilizadores'),
              trailing: ElevatedButton(onPressed: _showCreateUtilizadorDialog, child: const Text('Criar')),
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
      ),
    );
  }
}
