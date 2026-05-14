import 'package:flutter/material.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/services/processos_service.dart';
import 'package:intl/intl.dart';

class PacientePortalPage extends StatefulWidget {
  const PacientePortalPage({super.key});

  @override
  State<PacientePortalPage> createState() => _PacientePortalPageState();
}

class _PacientePortalPageState extends State<PacientePortalPage> {
  final _processosService = ProcessosService();
  bool _loading = true;
  Map<String, dynamic>? _pacienteData;
  List<Map<String, dynamic>> _meusProcessos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final user = AuthFacade().currentUser;
      if (user != null) {
        _pacienteData = user;
        // Buscar processos específicos deste paciente
        _meusProcessos = await _processosService.fetchProcessosByPaciente(user['id']);
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados do portal: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_pacienteData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Portal do Paciente')),
        body: const Center(child: Text('Dados do paciente não encontrados.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Painel'),
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
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPatientCard(),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'Meus Exames e Processos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            if (_meusProcessos.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Você ainda não possui processos ou exames registrados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              ..._meusProcessos.map((p) => _buildProcessoCard(p)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard() {
    final nome = _pacienteData?['nome'] ?? 'Paciente';
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white24,
                  child: Text(
                    nome[0].toUpperCase(),
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        _pacienteData?['email'] ?? 'Sem e-mail cadastrado',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _infoRow(Icons.fingerprint, 'NIF: ${_pacienteData?['nif'] ?? 'N/A'}'),
                const SizedBox(height: 12),
                _infoRow(Icons.cake, 'Nascimento: ${_formatDate(_pacienteData?['data_nascimento'])}'),
                const SizedBox(height: 12),
                _infoRow(Icons.phone_iphone, 'Telemóvel: ${_pacienteData?['telemovel'] ?? 'N/A'}'),
                if (_pacienteData?['altura'] != null || _pacienteData?['peso'] != null) ...[
                  const SizedBox(height: 12),
                  _infoRow(Icons.monitor_weight_outlined, 
                    'Altura: ${_pacienteData?['altura'] ?? '--'}m  •  Peso: ${_pacienteData?['peso'] ?? '--'}kg'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessoCard(Map<String, dynamic> p) {
    final status = p['status_id'] ?? 'Pendente';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_getStatusIcon(status), color: _getStatusColor(status)),
        ),
        title: Text(
          'Processo nº ${p['numero_processo']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Status: $status'),
            Text('Data: ${_formatDate(p['data_entrada'])}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Aqui poderia abrir detalhes do exame
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green.shade600),
        const SizedBox(width: 16),
        Text(text, style: const TextStyle(fontSize: 15)),
      ],
    );
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr.toString());
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr.toString();
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'concluído': return Icons.check_circle_outline;
      case 'em processamento': return Icons.sync;
      case 'pendente': return Icons.hourglass_empty;
      default: return Icons.info_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'concluído': return Colors.green;
      case 'em processamento': return Colors.blue;
      case 'pendente': return Colors.orange;
      default: return Colors.grey;
    }
  }
}
