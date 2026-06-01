import 'package:flutter/material.dart';
import 'package:genoma/core/config/dioConfig.dart';
import 'package:genoma/widgets/state_view.dart';
import 'package:genoma/pages/edit_entry_page.dart';
import 'package:genoma/widgets/create_dialogs.dart';
import 'package:genoma/services/resultados_service.dart';
import 'package:genoma/services/resultados_geneticos_service.dart';
import 'package:genoma/services/processos_service.dart';
import 'package:genoma/services/itens_pesquisa_service.dart';
import 'package:genoma/services/postos_service.dart';
import 'package:genoma/services/empresas_service.dart';
import 'package:genoma/core/ui/notification_service.dart';

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

  // Services for contextual actions
  final _resultadosService = ResultadosService();
  final _resultadosGeneticosService = ResultadosGeneticosService();
  final _processosService = ProcessosService();
  final _itensService = ItensPesquisaService();

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
      debugPrint('TableList load error: ${e.toString()}');
      String msg = 'Erro ao carregar dados.';
      final s = e.toString().toLowerCase();
      if (s.contains('unauthorized') || s.contains('401')) msg = 'Não autorizado.';
      else if (s.contains('forbidden') || s.contains('403')) msg = 'Acesso proibido.';
      setState(() => _error = msg);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showProcessoActions(Map<String, dynamic> processo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Processo: ${processo['numero_processo'] ?? 'S/N'}', 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Editar Detalhes do Processo'),
              onTap: () async {
                Navigator.pop(ctx);
                final result = await Navigator.push<bool?>(
                  context,
                  MaterialPageRoute(builder: (_) => EditEntryPage(endpoint: widget.endpoint, entry: processo)),
                );
                if (result == true) _load();
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined, color: Colors.green),
              title: const Text('Adicionar Resultado Detalhado'),
              onTap: () async {
                Navigator.pop(ctx);
                // Pre-fill the process in the dialog if possible or just open it
                final result = await showCreateResultadoDialog(context, _resultadosService, _processosService, _itensService);
                if (result == true) NotificationService().showSuccess('Resultado adicionado');
              },
            ),
            ListTile(
              leading: const Icon(Icons.science, color: Colors.purple),
              title: const Text('Adicionar Resultado Genético'),
              onTap: () async {
                Navigator.pop(ctx);
                final result = await showCreateResultadoGeneticoDialog(context, _resultadosGeneticosService, _processosService);
                if (result == true) NotificationService().showSuccess('Resultado genético adicionado');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEmpresaActions(Map<String, dynamic> empresa) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Empresa: ${empresa['nome'] ?? 'S/N'}', 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Editar Detalhes da Empresa'),
              onTap: () async {
                Navigator.pop(ctx);
                final result = await Navigator.push<bool?>(
                  context,
                  MaterialPageRoute(builder: (_) => EditEntryPage(endpoint: widget.endpoint, entry: empresa)),
                );
                if (result == true) _load();
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt, color: Colors.green),
              title: const Text('Criar Novo Posto para esta Empresa'),
              onTap: () async {
                Navigator.pop(ctx);
                final postosService = PostosService();
                final empresasService = EmpresasService();
                final result = await showCreatePostoDialog(
                  context, 
                  postosService, 
                  empresasService,
                  initialEmpresaId: empresa['id']?.toString(),
                );
                if (result == true) NotificationService().showSuccess('Posto criado para ${empresa['nome']}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.grey),
              title: const Text('Ver Postos desta Empresa'),
              onTap: () {
                Navigator.pop(ctx);
                // Although backend doesn't filter yet, we open the list
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableListPage(endpoint: '/postos', title: 'Postos')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _titleForItem(Map<String, dynamic> item) {
    final keys = item.keys.where((k) => !_isSensitiveKey(k)).toList();
    if (keys.contains('numero_processo')) return 'Proc: ${item['numero_processo']}';
    if (keys.contains('nome') && (item['nome'] ?? '').toString().isNotEmpty) return item['nome'].toString();
    if (keys.contains('email') && (item['email'] ?? '').toString().isNotEmpty) return item['email'].toString();
    if (keys.contains('descricao') && (item['descricao'] ?? '').toString().isNotEmpty) return item['descricao'].toString();
    if (keys.contains('id')) return item['id'].toString();
    return 'Item';
  }

  @override
  Widget build(BuildContext context) {
    final isProcessos = widget.endpoint.contains('processos');
    final isEmpresas = widget.endpoint.contains('empresas');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: StateView(
        loading: _loading,
        error: _error,
        empty: !_loading && _items.isEmpty && _error == null,
        onRetry: _load,
        child: ListView.separated(
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = _items[index];
            final visible = item.entries
                .where((e) => !_isSensitiveKey(e.key) && e.key != 'id')
                .take(3)
                .map((e) => '${e.key}: ${e.value}')
                .join(' • ');

            return ListTile(
              title: Text(_titleForItem(item)),
              subtitle: Text(visible, style: const TextStyle(fontSize: 12)),
              trailing: (isProcessos || isEmpresas) ? const Icon(Icons.more_vert) : const Icon(Icons.chevron_right),
              onTap: () {
                if (isProcessos) {
                  _showProcessoActions(item);
                } else if (isEmpresas) {
                  _showEmpresaActions(item);
                } else {
                  _defaultOnTap(item);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _defaultOnTap(Map<String, dynamic> item) async {
    final result = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(builder: (_) => EditEntryPage(endpoint: widget.endpoint, entry: item)),
    );
    if (result == true) _load();
  }

  bool _isSensitiveKey(String key) {
    final k = key.toLowerCase();
    return k.contains('hash') || k.contains('password') || k.contains('senha') || k.contains('token') || k.contains('secret');
  }
}
