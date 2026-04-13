import 'package:flutter/material.dart';
import 'package:genoma/core/config/dioConfig.dart';
import 'package:genoma/pages/edit_entry_page.dart';

class TableListPage extends StatefulWidget {
  final String endpoint;
  final String title;
  const TableListPage({super.key, required this.endpoint, required this.title});

  @override
  State<TableListPage> createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await APIService().getRequest(widget.endpoint);
      final body = resp.data;
      List<Map<String, dynamic>> items = [];
      if (body == null) items = [];
      else if (body is Map && body['data'] is List) {
        items = List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
      } else if (body is List) {
        items = List<Map<String, dynamic>>.from((body as List).map((e) => Map<String, dynamic>.from(e as Map)));
      }
      setState(() => _items = items);
    } catch (e) {
      // Map exception to a friendly message for admins
      debugPrint('TableList load error: ${e.toString()}');
      String msg = 'Erro ao carregar dados.';
      final s = e.toString().toLowerCase();
      if (s.contains('unauthorized') || s.contains('401')) msg = 'Não autorizado. Faça login novamente.';
      else if (s.contains('forbidden') || s.contains('403')) msg = 'Acesso proibido.';
      else if (s.contains('notfound') || s.contains('404')) msg = 'Nenhum registro encontrado.';
      else if (s.contains('internalservererror') || s.contains('500')) msg = 'Erro interno no servidor. Verifique os logs.';
      setState(() => _error = msg);
    } finally {
      setState(() => _loading = false);
    }
  }

  String _titleForItem(Map<String, dynamic> item) {
    final keys = item.keys.where((k) => !_isSensitiveKey(k)).toList();
    if (keys.contains('nome') && (item['nome'] ?? '').toString().isNotEmpty) return item['nome'].toString();
    if (keys.contains('email') && (item['email'] ?? '').toString().isNotEmpty) return item['email'].toString();
    if (keys.contains('descricao') && (item['descricao'] ?? '').toString().isNotEmpty) return item['descricao'].toString();
    if (keys.contains('id')) return item['id'].toString();
    for (final k in keys) {
      final v = item[k];
      if (v is String && v.isNotEmpty) return v;
    }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Builder(builder: (context) {
        if (_loading) return const Center(child: CircularProgressIndicator());
        if (_error != null) return Center(child: Text('Erro: $_error'));
        if (_items.isEmpty) return const Center(child: Text('Nenhum registro encontrado'));

        return ListView.separated(
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = _items[index];
            final visible = item.entries.where((e) => !_isSensitiveKey(e.key)).take(3).map((e) => '${e.key}: ${e.value}').join(' • ');
            return ListTile(
              title: Text(_titleForItem(item)),
              subtitle: Text(visible),
              onTap: () async {
                final result = await Navigator.push<bool?>(
                  context,
                  MaterialPageRoute(builder: (_) => EditEntryPage(endpoint: widget.endpoint, entry: item)),
                );
                if (result == true) await _load();
              },
            );
          },
        );
      }),
    );
  }

  bool _isSensitiveKey(String key) {
    final k = key.toLowerCase();
    return k.contains('hash') || k.contains('password') || k.contains('senha') || k.contains('token') || k.contains('secret') || k.contains('apikey') || k.contains('api_key');
  }
}
