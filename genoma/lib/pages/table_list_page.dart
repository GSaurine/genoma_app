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
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  String _titleForItem(Map<String, dynamic> item) {
    if (item.containsKey('nome') && (item['nome'] ?? '').toString().isNotEmpty) return item['nome'].toString();
    if (item.containsKey('email') && (item['email'] ?? '').toString().isNotEmpty) return item['email'].toString();
    if (item.containsKey('descricao') && (item['descricao'] ?? '').toString().isNotEmpty) return item['descricao'].toString();
    if (item.containsKey('id')) return item['id'].toString();
    // fallback: first string-like value
    for (final v in item.values) {
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
            return ListTile(
              title: Text(_titleForItem(item)),
              subtitle: Text(item.entries.take(3).map((e) => '${e.key}: ${e.value}').join(' • ')),
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
}
