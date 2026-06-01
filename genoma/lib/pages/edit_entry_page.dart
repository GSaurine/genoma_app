import 'package:flutter/material.dart';
import 'package:genoma/core/config/dioConfig.dart';
import 'package:genoma/core/ui/notification_service.dart';

class EditEntryPage extends StatefulWidget {
  final String endpoint;
  final Map<String, dynamic> entry;
  const EditEntryPage({super.key, required this.endpoint, required this.entry});

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  final Map<String, TextEditingController> _controllers = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    widget.entry.forEach((k, v) {
      // Skip nested objects or arrays for simplicity
      if (v is Map || v is List) return;
      // Skip sensitive fields entirely
      if (_isSensitiveKey(k)) return;
      _controllers[k] = TextEditingController(text: v?.toString() ?? '');
    });
  }

  bool _isSensitiveKey(String key) {
    final k = key.toLowerCase();
    return k.contains('hash') || k.contains('password') || k.contains('senha') || k.contains('token') || k.contains('secret') || k.contains('apikey') || k.contains('api_key');
  }

  Future<void> _save() async {
    final id = widget.entry['id'];
    if (id == null) {
      NotificationService().showError('Registro sem id, não pode atualizar');
      return;
    }

    final Map<String, dynamic> data = {};
    _controllers.forEach((k, c) {
      if (k == 'id') return;
      data[k] = c.text.isEmpty ? null : c.text;
    });

    if (widget.endpoint.contains('pacientes') && _passwordController.text.isNotEmpty) {
      data['password'] = _passwordController.text;
    }

    setState(() => _saving = true);
    try {
      await APIService().putRequest('${widget.endpoint}/$id', data: data);
      if (!mounted) return;
      NotificationService().showSuccess('Atualizado com sucesso');
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      NotificationService().showError('Erro ao atualizar: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final id = widget.entry['id'];
    if (id == null) {
      NotificationService().showError('Registro sem id, não pode deletar');
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar deleção'),
        content: const Text('Tem a certeza que deseja apagar este registro? Esta ação é irreversível.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Apagar')),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _saving = true);
    try {
      await APIService().deleteRequest('${widget.endpoint}/$id');
      if (!mounted) return;
      NotificationService().showSuccess('Registro apagado');
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      NotificationService().showError('Erro ao apagar: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = _controllers.keys.toList();
    final isPaciente = widget.endpoint.contains('pacientes');

    return Scaffold(
      appBar: AppBar(title: const Text('Editar registro'), actions: [
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: _saving ? null : _confirmDelete,
          tooltip: 'Apagar registro',
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...keys.map((k) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      controller: _controllers[k],
                      decoration: InputDecoration(labelText: k),
                      enabled: k == 'id' ? false : true,
                    ),
                  )).toList(),
                  if (isPaciente) ...[
                    const Divider(height: 32),
                    const Text('Alterar Senha do Paciente', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Nova Senha (deixe vazio para não alterar)',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
              label: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}
