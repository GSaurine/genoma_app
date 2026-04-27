import 'package:flutter/material.dart';
import 'package:genoma/services/paciente_service.dart';
import 'package:genoma/services/auth_facade.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _service = PacienteService();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _pacientes = [];

  @override
  void initState() {
    super.initState();
    _ensureAuthenticatedThenLoad();
  }

  Future<void> _ensureAuthenticatedThenLoad() async {
    try {
      final ok = await AuthFacade().initializeFromSavedToken();
      if (!ok) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    await _loadPacientes();
  }

  Future<void> _loadPacientes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _service.fetchPacientes();
      if (!mounted) return;
      setState(() {
        _pacientes = items;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPacientes),
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
      body: Builder(builder: (context) {
        if (_loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Erro: $_error'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _loadPacientes, child: const Text('Tentar novamente')),
              ],
            ),
          );
        }
        if (_pacientes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nenhum paciente encontrado.'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _loadPacientes, child: const Text('Atualizar')),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: _pacientes.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final p = _pacientes[index];
            final name = (p['nome'] ?? '') as String;
            String subtitle = (p['email'] ?? p['telemovel'] ?? '') as String;
            
            final List<String> details = [];
            if (p['altura'] != null) details.add('${p['altura']}m');
            if (p['peso'] != null) details.add('${p['peso']}kg');
            
            if (details.isNotEmpty) {
              if (subtitle.isNotEmpty) subtitle += ' • ';
              subtitle += details.join(' • ');
            }

            return ListTile(
              leading: CircleAvatar(child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?')),
              title: Text(name.isNotEmpty ? name : '—'),
              subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
            );
          },
        );
      }),
    );
  }
}