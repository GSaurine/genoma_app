import 'package:flutter/material.dart';
import 'package:genoma/services/paciente_service.dart';
import 'package:genoma/services/processos_service.dart';
import 'package:intl/intl.dart';

class PacientesPage extends StatefulWidget {
  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  final _pacienteService = PacienteService();
  final _processosService = ProcessosService();
  bool _loading = true;
  List<Map<String, dynamic>> _pacientes = [];
  Map<String, List<Map<String, dynamic>>> _processosPorPaciente = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final pacientes = await _pacienteService.fetchPacientes();
      final processos = await _processosService.fetchProcessos();
      
      final Map<String, List<Map<String, dynamic>>> map = {};
      for (var p in processos) {
        final pacienteId = p['paciente_id'];
        if (pacienteId != null) {
          if (!map.containsKey(pacienteId)) map[pacienteId] = [];
          map[pacienteId]!.add(p);
        }
      }

      if (mounted) {
        setState(() {
          _pacientes = pacientes;
          _processosPorPaciente = map;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar pacientes: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Pacientes'),
        elevation: 2,
      ),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: _pacientes.isEmpty
              ? const Center(child: Text('Nenhum paciente encontrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pacientes.length,
                  itemBuilder: (context, index) {
                    final paciente = _pacientes[index];
                    final processos = _processosPorPaciente[paciente['id']] ?? [];
                    return _PatientCard(paciente: paciente, processos: processos);
                  },
                ),
          ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final Map<String, dynamic> paciente;
  final List<Map<String, dynamic>> processos;

  const _PatientCard({required this.paciente, required this.processos});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade800, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Text(
                    paciente['nome']?[0]?.toUpperCase() ?? '?',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paciente['nome'] ?? 'Sem nome',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIF: ${paciente['nif'] ?? 'N/A'}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.email_outlined, paciente['email'] ?? 'N/A'),
                const SizedBox(height: 8),
                _infoRow(Icons.phone_android_outlined, paciente['telemovel'] ?? 'N/A'),
                const SizedBox(height: 8),
                _infoRow(Icons.cake_outlined, 'Nascimento: ${_formatDate(paciente['data_nascimento'])}'),
                if (paciente['genero'] != null) ...[
                  const SizedBox(height: 8),
                  _infoRow(Icons.person_outline, 'Gênero: ${paciente['genero']}'),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          if (processos.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  Icon(Icons.assignment_outlined, size: 18, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  const Text(
                    'PROCESSOS / EXAMES ATIVOS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${processos.length}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: processos.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, idx) {
                final p = processos[idx];
                final status = p['status_id'] ?? 'Pendente';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(status), 
                      color: _getStatusColor(status),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'Nº ${p['numero_processo']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Entrada: ${_formatDate(p['data_entrada'])} • $status',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    // Navegar para detalhes do processo se necessário
                  },
                );
              },
            ),
          ] else 
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Nenhum processo aberto para este paciente.',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
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

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'concluído': return Icons.check_circle;
      case 'cancelado': return Icons.cancel;
      case 'pendente': return Icons.access_time;
      case 'em processamento': return Icons.sync;
      default: return Icons.info_outline;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'concluído': return Colors.green.shade600;
      case 'cancelado': return Colors.red.shade600;
      case 'pendente': return Colors.orange.shade700;
      case 'em processamento': return Colors.blue.shade600;
      default: return Colors.blueGrey;
    }
  }
}
