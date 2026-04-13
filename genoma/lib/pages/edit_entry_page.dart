import 'package:flutter/material.dart';
import 'package:genoma/core/config/dioConfig.dart';

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

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  bool _isSensitiveKey(String key) {
    final k = key.toLowerCase();
    return k.contains('hash') || k.contains('password') || k.contains('senha') || k.contains('token') || k.contains('secret') || k.contains('apikey') || k.contains('api_key');
  }

  Future<void> _save() async {
    final id = widget.entry['id'];
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro sem id, não pode atualizar')));
      return;
    }

    final Map<String, dynamic> data = {};
    _controllers.forEach((k, c) {
      if (k == 'id') return;
      data[k] = c.text.isEmpty ? null : c.text;
    });

    setState(() => _saving = true);
    try {
      await APIService().putRequest('${widget.endpoint}/$id', data: data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Atualizado com sucesso')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final id = widget.entry['id'];
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro sem id, não pode deletar')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro apagado')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao apagar: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = _controllers.keys.toList();
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
              child: ListView.separated(
                itemCount: keys.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final k = keys[index];
                  return TextField(
                    controller: _controllers[k],
                    decoration: InputDecoration(labelText: k),
                    enabled: k == 'id' ? false : true,
                  );
                },
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
}
