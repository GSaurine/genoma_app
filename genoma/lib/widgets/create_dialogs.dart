import 'package:flutter/material.dart';
import 'package:genoma/services/paciente_service.dart';
import 'package:genoma/services/empresas_service.dart';
import 'package:genoma/services/kits_service.dart';
import 'package:genoma/services/perfis_service.dart';
import 'package:genoma/services/utilizadores_service.dart';
import 'package:genoma/services/processos_service.dart';
import 'package:genoma/services/medicos_service.dart';
import 'package:genoma/services/postos_service.dart';
import 'package:genoma/services/testes_service.dart';
import 'package:genoma/services/itens_pesquisa_service.dart';
import 'package:genoma/services/resultados_service.dart';
import 'package:genoma/services/resultados_geneticos_service.dart';
import 'package:genoma/core/ui/notification_service.dart';
import 'package:genoma/services/auth_service.dart';
import 'package:intl/intl.dart';

Future<bool?> showCreatePacienteDialog(BuildContext context, PacienteService pacienteService) async {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final nifController = TextEditingController();
  final telController = TextEditingController();
  final passwordController = TextEditingController();
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();

  DateTime? selectedDate;
  final isAdmin = AuthService().isAdmin;

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
      title: const Text('Criar Paciente'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nomeController, 
              decoration: const InputDecoration(
                labelText: 'Nome Completo *',
                prefixIcon: Icon(Icons.person_outline),
              )
            ),
            const SizedBox(height: 16),
            const Text('Data de Nascimento *', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Row(
              children: [
                const Icon(Icons.cake_outlined, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate == null 
                      ? 'Não selecionada' 
                      : DateFormat('dd/MM/yyyy').format(selectedDate!),
                    style: TextStyle(
                      color: selectedDate == null ? Colors.red.shade300 : Colors.black87,
                      fontWeight: selectedDate == null ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
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
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('Selecionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: telController, 
              decoration: const InputDecoration(
                labelText: 'Telemóvel',
                prefixIcon: Icon(Icons.phone_android),
              ),
              keyboardType: TextInputType.phone,
            ),
            
            if (isAdmin) ...[
              const SizedBox(height: 16),
              Theme(
                data: Theme.of(ctx2).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Informações Adicionais (Admin)', 
                    style: TextStyle(fontSize: 13, color: Theme.of(ctx2).primaryColor, fontWeight: FontWeight.bold)
                  ),
                  children: [
                    TextField(
                      controller: emailController, 
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))
                    ),
                    TextField(
                      controller: nifController, 
                      decoration: const InputDecoration(labelText: 'NIF', prefixIcon: Icon(Icons.badge_outlined))
                    ),
                    TextField(
                      controller: passwordController, 
                      decoration: const InputDecoration(labelText: 'Senha de Acesso', prefixIcon: Icon(Icons.lock_outline)), 
                      obscureText: true
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: alturaController, 
                            decoration: const InputDecoration(labelText: 'Altura (m)', hintText: '1.75'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: pesoController, 
                            decoration: const InputDecoration(labelText: 'Peso (kg)', hintText: '70.5'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx2).pop(false), child: const Text('Cancelar')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () async {
            if (nomeController.text.trim().isEmpty) {
              NotificationService().showError('Por favor, insira o nome do paciente');
              return;
            }
            if (selectedDate == null) {
              NotificationService().showError('Por favor, selecione a data de nascimento');
              return;
            }

            final data = {
              'nome': nomeController.text.trim(),
              'data_nascimento': selectedDate!.toIso8601String().split('T')[0],
              'email': emailController.text.trim().isEmpty ? null : emailController.text.trim(),
              'nif': nifController.text.trim().isEmpty ? null : nifController.text.trim(),
              'telemovel': telController.text.trim().isEmpty ? null : telController.text.trim(),
              'password': passwordController.text.trim().isEmpty ? null : passwordController.text.trim(),
              'altura': double.tryParse(alturaController.text.replaceAll(',', '.')),
              'peso': double.tryParse(pesoController.text.replaceAll(',', '.')),
            };
            try {
              final created = await pacienteService.createPaciente(data);
              if (created != null) {
                Navigator.of(ctx2).pop(true);
              } else {
                Navigator.of(ctx2).pop(false);
              }
            } catch (e) {
              NotificationService().showError('Erro ao criar paciente: ${e.toString()}');
              Navigator.of(ctx2).pop(false);
            }
          },
          child: const Text('Criar'),
        ),
      ],
    )),
  );

  return result;
}

Future<bool?> showCreateEmpresaDialog(BuildContext context, EmpresasService empresasService) async {
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
            final created = await empresasService.createEmpresa(data);
            Navigator.of(ctx).pop(created != null);
          } catch (e) {
            NotificationService().showError('Erro ao criar empresa: ${e.toString()}');
            Navigator.of(ctx).pop(false);
          }
        }, child: const Text('Criar')),
      ],
    ),
  );

  return result;
}

Future<bool?> showCreateKitDialog(BuildContext context, KitsService kitsService) async {
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
            final created = await kitsService.createKit(data);
            Navigator.of(ctx).pop(created != null);
          } catch (e) {
            NotificationService().showError('Erro ao criar kit: ${e.toString()}');
            Navigator.of(ctx).pop(false);
          }
        }, child: const Text('Criar')),
      ],
    ),
  );

  return result;
}

Future<bool?> showCreateUtilizadorDialog(
  BuildContext context,
  UtilizadoresService utilizadoresService,
  PerfisService perfisService,
  EmpresasService empresasService,
) async {
  final nome = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final telefone = TextEditingController();
  
  // Novos controllers para Médico
  final numOrdem = TextEditingController();
  final especialidade = TextEditingController();

  String? selectedPerfilId;
  String? selectedEmpresaId;
  bool isSaving = false;

  List<Map<String, dynamic>> perfis = [];
  List<Map<String, dynamic>> empresas = [];
  try {
    perfis = await perfisService.fetchPerfis();
    empresas = await empresasService.fetchEmpresas();
  } catch (_) {}

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) {
      // Verifica se o perfil selecionado é "Médico"
      final selectedPerfil = perfis.firstWhere((p) => p['id'] == selectedPerfilId, orElse: () => {});
      final isMedico = selectedPerfil['nome']?.toString().toLowerCase().contains('médico') ?? false;

      return AlertDialog(
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
                value: selectedPerfilId,
                onChanged: (v) => setState(() => selectedPerfilId = v),
              ),
              
              if (isMedico) ...[
                const Divider(height: 32),
                const Text('Dados do Médico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.deepPurple)),
                TextField(controller: numOrdem, decoration: const InputDecoration(labelText: 'Número de Ordem (Cédula)')),
                TextField(controller: especialidade, decoration: const InputDecoration(labelText: 'Especialidade')),
              ],

              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Empresa (opcional)'),
                items: empresas.map((e) => DropdownMenuItem(value: e['id']?.toString(), child: Text(e['nome'] ?? '-'))).toList(),
                value: selectedEmpresaId,
                onChanged: (v) => setState(() => selectedEmpresaId = v),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: isSaving ? null : () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: isSaving ? null : () async {
              if (nome.text.isEmpty || email.text.isEmpty || password.text.isEmpty || selectedPerfilId == null) {
                NotificationService().showError('Preencha os campos obrigatórios');
                return;
              }

              setState(() => isSaving = true);

              try {
                // 1. Criar Utilizador
                final userData = {
                  'nome': nome.text.trim(),
                  'email': email.text.trim(),
                  'password': password.text,
                  'telefone': telefone.text.trim().isEmpty ? null : telefone.text.trim(),
                  'perfil_id': selectedPerfilId,
                  'empresa_id': selectedEmpresaId,
                }..removeWhere((k, v) => v == null);

                final createdUser = await utilizadoresService.createUtilizador(userData);
                
                if (createdUser != null && isMedico) {
                  // 2. Se for médico, criar registro na tabela de médicos
                  final medicoData = {
                    'utilizador_id': createdUser['id'],
                    'num_ordem': numOrdem.text.trim(),
                    'especialidade': especialidade.text.trim(),
                  };
                  
                  final createdMedico = await MedicosService().createMedico(medicoData);
                  if (createdMedico == null) {
                    NotificationService().showError('Utilizador criado, mas erro ao criar perfil médico');
                  }
                }

                if (createdUser != null) {
                  Navigator.of(ctx).pop(true);
                } else {
                  setState(() => isSaving = false);
                }
              } catch (e) {
                setState(() => isSaving = false);
                NotificationService().showError('Erro: ${e.toString()}');
              }
            }, 
            child: isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Criar')
          ),
        ],
      );
    }),
  );

  return result;
}

Future<bool?> showCreateProcessoDialog(
  BuildContext context,
  ProcessosService processosService,
  PacienteService pacienteService,
  MedicosService medicosService,
  KitsService kitsService,
  PostosService postosService,
) async {
  final numeroProcesso = TextEditingController();
  final semanasController = TextEditingController();
  final diasController = TextEditingController();
  final motivoController = TextEditingController();
  final notasController = TextEditingController();
  
  // Facturação
  final precoController = TextEditingController();
  final faturaController = TextEditingController();
  final entidadeMBController = TextEditingController();
  final referenciaMBController = TextEditingController();
  DateTime? dataFatura;
  bool comissao = false;
  
  String? selectedPacienteId;
  String? selectedMedicoId;
  String? selectedKitId;
  String? selectedPostoId;
  String tipoGravidez = 'singular';
  bool querSaberSexo = false;
  
  DateTime? dataPrevista;
  String periodo = 'Manhã';

  List<Map<String, dynamic>> pacientes = [];
  List<Map<String, dynamic>> medicos = [];
  List<Map<String, dynamic>> kits = [];
  List<Map<String, dynamic>> postos = [];
  bool isLoadingKits = false;
  
  try {
    pacientes = await pacienteService.fetchPacientes();
    medicos = await medicosService.fetchMedicos();
    // Não carregamos kits inicialmente, pois dependem do posto
    // kits = await kitsService.fetchKits(); 
    postos = await postosService.fetchPostos();
  } catch (_) {}

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
      title: const Text('Novo Processo / Exame'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: numeroProcesso, decoration: const InputDecoration(labelText: 'Número do Processo')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Paciente'),
              items: pacientes.map((p) => DropdownMenuItem(value: p['id']?.toString(), child: Text(p['nome'] ?? '-'))).toList(),
              value: selectedPacienteId,
              onChanged: (v) => setState(() => selectedPacienteId = v),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Médico'),
              items: medicos.map((m) => DropdownMenuItem(value: m['utilizador_id']?.toString(), child: Text(m['nome'] ?? '-'))).toList(),
              value: selectedMedicoId,
              onChanged: (v) => setState(() => selectedMedicoId = v),
            ),
            
            const Divider(height: 32),
            const Text('Local e Data de Colheita', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Posto de Colheita'),
              items: postos.map((p) => DropdownMenuItem(value: p['id']?.toString(), child: Text(p['nome'] ?? '-'))).toList(),
              value: selectedPostoId,
              onChanged: (v) async {
                setState(() {
                  selectedPostoId = v;
                  selectedKitId = null;
                  kits = [];
                  isLoadingKits = true;
                });
                if (v != null) {
                  try {
                    final filteredKits = await kitsService.fetchKits(postoId: v, status: 'No Posto');
                    setState(() {
                      kits = filteredKits;
                      isLoadingKits = false;
                    });
                  } catch (e) {
                    setState(() => isLoadingKits = false);
                    NotificationService().showError('Erro ao carregar kits do posto');
                  }
                } else {
                  setState(() => isLoadingKits = false);
                }
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: isLoadingKits ? 'A carregar kits...' : 'Kit (Código de Barras)',
                hintText: selectedPostoId == null ? 'Selecione primeiro um posto' : 'Selecione um kit',
              ),
              items: kits.map((k) => DropdownMenuItem(
                value: k['id']?.toString(), 
                child: Text('${k['codigo_barras']} (${k['numero_kit'] ?? 'S/N'})')
              )).toList(),
              value: selectedKitId,
              onChanged: selectedPostoId == null || isLoadingKits ? null : (v) => setState(() => selectedKitId = v),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(dataPrevista == null ? 'Data não selecionada' : dataPrevista!.toIso8601String().split('T')[0]),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: ctx2,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => dataPrevista = picked);
                  },
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: periodo,
              decoration: const InputDecoration(labelText: 'Período'),
              items: const [
                DropdownMenuItem(value: 'Manhã', child: Text('Manhã')),
                DropdownMenuItem(value: 'Tarde', child: Text('Tarde')),
                DropdownMenuItem(value: 'Noite', child: Text('Noite')),
              ],
              onChanged: (v) => setState(() => periodo = v!),
            ),

            const Divider(height: 32),
            const Text('Informação Clínica (Gravidez)', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(child: TextField(controller: semanasController, decoration: const InputDecoration(labelText: 'Semanas'), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: diasController, decoration: const InputDecoration(labelText: 'Dias'), keyboardType: TextInputType.number)),
              ],
            ),
            DropdownButtonFormField<String>(
              value: tipoGravidez,
              decoration: const InputDecoration(labelText: 'Tipo de Gravidez'),
              items: const [
                DropdownMenuItem(value: 'singular', child: Text('Singular')),
                DropdownMenuItem(value: 'gemelar', child: Text('Gemelar')),
              ],
              onChanged: (v) => setState(() => tipoGravidez = v!),
            ),
            SwitchListTile(
              title: const Text('Saber sexo do bebé?'),
              value: querSaberSexo,
              onChanged: (v) => setState(() => querSaberSexo = v),
            ),
            TextField(controller: motivoController, decoration: const InputDecoration(labelText: 'Motivo da Prescrição'), maxLines: 2),
            const SizedBox(height: 8),
            TextField(controller: notasController, decoration: const InputDecoration(labelText: 'Notas do Processo'), maxLines: 3),

            const Divider(height: 32),
            const Text('Facturação', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: precoController, 
              decoration: const InputDecoration(labelText: 'Preço do Teste'), 
              keyboardType: const TextInputType.numberWithOptions(decimal: true)
            ),
            TextField(controller: faturaController, decoration: const InputDecoration(labelText: 'Número da Fatura')),
            Row(
              children: [
                Expanded(
                  child: Text(dataFatura == null ? 'Data Fatura não selecionada' : dataFatura!.toIso8601String().split('T')[0]),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: ctx2,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => dataFatura = picked);
                  },
                  child: const Text('Data Fatura'),
                ),
              ],
            ),
            TextField(controller: entidadeMBController, decoration: const InputDecoration(labelText: 'Entidade Multibanco')),
            TextField(controller: referenciaMBController, decoration: const InputDecoration(labelText: 'Referência Multibanco')),
            SwitchListTile(
              title: const Text('Comissão?'),
              value: comissao,
              onChanged: (v) => setState(() => comissao = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (numeroProcesso.text.isEmpty || selectedPacienteId == null || selectedMedicoId == null || selectedKitId == null || selectedPostoId == null) {
            NotificationService().showError('Preencha os campos obrigatórios');
            return;
          }

          final data = {
            'numero_processo': numeroProcesso.text.trim(),
            'paciente_id': selectedPacienteId,
            'medico_id': selectedMedicoId,
            'kit_id': selectedKitId,
            'posto_id': selectedPostoId,
            'status_id': 'Em Processamento',
            'notas': notasController.text.trim().isEmpty ? null : notasController.text.trim(),
            'informacao_clinica': {
              'semanas_gravidez': int.tryParse(semanasController.text),
              'dias_gravidez': int.tryParse(diasController.text),
              'tipo_gravidez': tipoGravidez,
              'quer_saber_sexo': querSaberSexo,
              'motivo_prescricao': motivoController.text.trim(),
            },
            'colheita': {
              'posto_id': selectedPostoId,
              'data_prevista': dataPrevista?.toIso8601String().split('T')[0],
              'periodo': periodo,
            },
            'facturacao': {
              'preco_teste': double.tryParse(precoController.text.replaceAll(',', '.')),
              'numero_fatura': faturaController.text.trim().isEmpty ? null : faturaController.text.trim(),
              'data_fatura': dataFatura?.toIso8601String().split('T')[0],
              'entidade_multibanco': entidadeMBController.text.trim().isEmpty ? null : entidadeMBController.text.trim(),
              'referencia_multibanco': referenciaMBController.text.trim().isEmpty ? null : referenciaMBController.text.trim(),
              'comissao': comissao,
            }
          };
          
          try {
            final created = await processosService.createProcesso(data);
            Navigator.of(ctx).pop(created != null);
          } catch (e) {
            NotificationService().showError('Erro ao criar processo: ${e.toString()}');
            Navigator.of(ctx).pop(false);
          }
        }, child: const Text('Criar')),
      ],
    )),
  );

  return result;
}

Future<bool?> showCreatePerfilDialog(BuildContext context, PerfisService perfisService) async {
  final nome = TextEditingController();
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Criar Perfil'),
      content: TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome do Perfil')),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (nome.text.isEmpty) return;
          final created = await perfisService.createPerfil({'nome': nome.text.trim()});
          Navigator.of(ctx).pop(created != null);
        }, child: const Text('Criar')),
      ],
    ),
  );
}

Future<bool?> showCreateMedicoDialog(BuildContext context, MedicosService medicosService, UtilizadoresService utilizadoresService) async {
  final numOrdem = TextEditingController();
  final especialidade = TextEditingController();
  String? selectedUtilizadorId;
  List<Map<String, dynamic>> utilizadores = [];
  try { utilizadores = await utilizadoresService.fetchUtilizadores(); } catch (_) {}

  return showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
      title: const Text('Criar Médico'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Utilizador'),
            items: utilizadores.map((u) => DropdownMenuItem(value: u['id']?.toString(), child: Text(u['nome'] ?? '-'))).toList(),
            value: selectedUtilizadorId,
            onChanged: (v) => setState(() => selectedUtilizadorId = v),
          ),
          TextField(controller: numOrdem, decoration: const InputDecoration(labelText: 'Número de Ordem')),
          TextField(controller: especialidade, decoration: const InputDecoration(labelText: 'Especialidade')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (selectedUtilizadorId == null || numOrdem.text.isEmpty) return;
          final created = await medicosService.createMedico({
            'utilizador_id': selectedUtilizadorId,
            'num_ordem': numOrdem.text.trim(),
            'especialidade': especialidade.text.trim(),
          });
          Navigator.of(ctx).pop(created != null);
        }, child: const Text('Criar')),
      ],
    )),
  );
}

Future<bool?> showCreateTesteDialog(
  BuildContext context, 
  TestesService testesService,
  ItensPesquisaService itensService,
) async {
  final nome = TextEditingController();
  final preco = TextEditingController();
  final descricao = TextEditingController();
  
  List<Map<String, dynamic>> allItens = [];
  List<String> selectedItensIds = [];
  bool isLoading = true;

  try {
    allItens = await itensService.fetchItens();
    isLoading = false;
  } catch (_) {
    isLoading = false;
  }

  return showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx2, setState) => AlertDialog(
        title: const Text('Configurar Novo Teste'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome do Teste *')),
              TextField(
                controller: preco, 
                decoration: const InputDecoration(labelText: 'Preço Base (€)'), 
                keyboardType: const TextInputType.numberWithOptions(decimal: true)
              ),
              TextField(controller: descricao, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 2),
              
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Composição do Teste', style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.orange, size: 20),
                    onPressed: () async {
                      final result = await showCreateItemDialog(context, itensService);
                      if (result == true) {
                        setState(() => isLoading = true);
                        final updatedItens = await itensService.fetchItens();
                        setState(() {
                          allItens = updatedItens;
                          isLoading = false;
                        });
                      }
                    },
                    tooltip: 'Novo Item de Pesquisa',
                  ),
                ],
              ),
              
              if (isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()))
              else if (allItens.isEmpty)
                const Text('Nenhum item cadastrado', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView(
                    shrinkWrap: true,
                    children: allItens.map((item) {
                      final id = item['id'].toString();
                      final isSelected = selectedItensIds.contains(id);
                      return CheckboxListTile(
                        title: Text(item['descricao'] ?? 'Sem descrição'),
                        subtitle: Text('Código: ${item['codigo'] ?? '-'}', style: const TextStyle(fontSize: 10)),
                        value: isSelected,
                        dense: true,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedItensIds.add(id);
                            } else {
                              selectedItensIds.remove(id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nome.text.isEmpty) {
                NotificationService().showError('O nome do teste é obrigatório');
                return;
              }

              try {
                // 1. Criar o Teste
                final createdTeste = await testesService.createTeste({
                  'nome': nome.text.trim(),
                  'preco': double.tryParse(preco.text.replaceAll(',', '.')),
                  'descricao': descricao.text.trim(),
                });

                if (createdTeste != null) {
                  final testeId = createdTeste['id'].toString();
                  // 2. Adicionar cada item selecionado
                  for (final itemId in selectedItensIds) {
                    await testesService.addItemToTeste(testeId, itemId);
                  }
                  Navigator.of(ctx).pop(true);
                } else {
                  NotificationService().showError('Erro ao criar o teste');
                }
              } catch (e) {
                NotificationService().showError('Erro: ${e.toString()}');
              }
            }, 
            child: const Text('Salvar Catálogo')
          ),
        ],
      ),
    ),
  );
}

Future<bool?> showCreateItemDialog(BuildContext context, ItensPesquisaService itensService) async {
  final codigo = TextEditingController();
  final descricao = TextEditingController();

  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Criar Item de Pesquisa'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: codigo, decoration: const InputDecoration(labelText: 'Código')),
          TextField(controller: descricao, decoration: const InputDecoration(labelText: 'Descrição')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (codigo.text.isEmpty || descricao.text.isEmpty) return;
          final created = await itensService.createItem({
            'codigo': codigo.text.trim(),
            'descricao': descricao.text.trim(),
          });
          Navigator.of(ctx).pop(created != null);
        }, child: const Text('Criar')),
      ],
    ),
  );
}

Future<bool?> showCreatePostoDialog(
  BuildContext context, 
  PostosService postosService, 
  EmpresasService empresasService, {
  String? initialEmpresaId,
}) async {
  final nome = TextEditingController();
  final codigoPosto = TextEditingController();
  final localizacao = TextEditingController();
  String? selectedEmpresaId = initialEmpresaId;
  List<Map<String, dynamic>> empresas = [];
  try { 
    empresas = await empresasService.fetchEmpresas(); 
  } catch (_) {}

  return showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
      title: const Text('Criar Posto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Empresa'),
            items: empresas.map((e) => DropdownMenuItem(value: e['id']?.toString(), child: Text(e['nome'] ?? '-'))).toList(),
            value: selectedEmpresaId,
            onChanged: (v) => setState(() => selectedEmpresaId = v),
          ),
          TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome do Posto')),
          TextField(controller: codigoPosto, decoration: const InputDecoration(labelText: 'Código do Posto')),
          TextField(controller: localizacao, decoration: const InputDecoration(labelText: 'Localização')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (nome.text.isEmpty || selectedEmpresaId == null) {
            NotificationService().showError('Preencha o nome e selecione uma empresa');
            return;
          }
          final created = await postosService.createPosto({
            'entidade_id': selectedEmpresaId,
            'nome': nome.text.trim(),
            'codigo_posto': codigoPosto.text.trim(),
            'localizacao': localizacao.text.trim(),
          });
          Navigator.of(ctx).pop(created != null);
        }, child: const Text('Criar')),
      ],
    )),
  );
}

Future<bool?> showCreateResultadoDialog(
  BuildContext context, 
  ResultadosService resultadosService, 
  ProcessosService processosService, 
  ItensPesquisaService itensService
) async {
  final resultado = TextEditingController();
  final observacoes = TextEditingController();
  String? selectedProcessoId;
  String? selectedItemId;
  List<Map<String, dynamic>> processos = [];
  List<Map<String, dynamic>> itens = [];
  try { 
    processos = await processosService.fetchProcessos(); 
    itens = await itensService.fetchItens();
  } catch (_) {}

  return showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
      title: const Text('Criar Resultado Detalhado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Processo'),
            items: processos.map((p) => DropdownMenuItem(value: p['id']?.toString(), child: Text(p['numero_processo'] ?? '-'))).toList(),
            value: selectedProcessoId,
            onChanged: (v) => setState(() => selectedProcessoId = v),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Item de Pesquisa'),
            items: itens.map((i) => DropdownMenuItem(value: i['id']?.toString(), child: Text(i['descricao'] ?? '-'))).toList(),
            value: selectedItemId,
            onChanged: (v) => setState(() => selectedItemId = v),
          ),
          TextField(controller: resultado, decoration: const InputDecoration(labelText: 'Resultado')),
          TextField(controller: observacoes, decoration: const InputDecoration(labelText: 'Observações')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (selectedProcessoId == null || selectedItemId == null) return;
          final created = await resultadosService.createResultado({
            'pedido_id': selectedProcessoId, // No backend maps to pedido_id usually
            'item_id': selectedItemId,
            'resultado': resultado.text.trim(),
            'observacoes': observacoes.text.trim(),
          });
          Navigator.of(ctx).pop(created != null);
        }, child: const Text('Criar')),
      ],
    )),
  );
}

Future<bool?> showCreateResultadoGeneticoDialog(
  BuildContext context, 
  ResultadosGeneticosService service, 
  ProcessosService processosService
) async {
  final cromossoma = TextEditingController();
  final valor = TextEditingController();
  final probabilidade = TextEditingController();
  final tipo = TextEditingController();
  String? selectedProcessoId;
  List<Map<String, dynamic>> processos = [];
  try { processos = await processosService.fetchProcessos(); } catch (_) {}

  return showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx2, setState) => AlertDialog(
      title: const Text('Criar Resultado Genético'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Processo'),
            items: processos.map((p) => DropdownMenuItem(value: p['id']?.toString(), child: Text(p['numero_processo'] ?? '-'))).toList(),
            value: selectedProcessoId,
            onChanged: (v) => setState(() => selectedProcessoId = v),
          ),
          TextField(controller: cromossoma, decoration: const InputDecoration(labelText: 'Cromossoma')),
          TextField(controller: valor, decoration: const InputDecoration(labelText: 'Valor')),
          TextField(controller: probabilidade, decoration: const InputDecoration(labelText: 'Probabilidade')),
          TextField(controller: tipo, decoration: const InputDecoration(labelText: 'Tipo de Resultado')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (selectedProcessoId == null) return;
          final created = await service.createResultadoGenetico({
            'processo_id': selectedProcessoId,
            'cromossoma': cromossoma.text.trim(),
            'resultado_valor': valor.text.trim(),
            'probabilidade': probabilidade.text.trim(),
            'tipo_resultado': tipo.text.trim(),
          });
          Navigator.of(ctx).pop(created != null);
        }, child: const Text('Criar')),
      ],
    )),
  );
}
