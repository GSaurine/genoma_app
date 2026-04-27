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

Future<bool?> showCreatePacienteDialog(BuildContext context, PacienteService pacienteService) async {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final nifController = TextEditingController();
  final telController = TextEditingController();
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();

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
                  child: Text(selectedDate == null ? 'Data de nascimento não selecionada' : selectedDate!.toIso8601String().split('T')[0]),
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
            TextField(
              controller: alturaController, 
              decoration: const InputDecoration(labelText: 'Altura (m)', hintText: 'Ex: 1.75'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: pesoController, 
              decoration: const InputDecoration(labelText: 'Peso (kg)', hintText: 'Ex: 70.5'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx2).pop(false), child: const Text('Cancelar')),
        ElevatedButton(
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
  String? selectedPerfilId;
  String? selectedEmpresaId;

  List<Map<String, dynamic>> perfis = [];
  List<Map<String, dynamic>> empresas = [];
  try {
    perfis = await perfisService.fetchPerfis();
    empresas = await empresasService.fetchEmpresas();
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
              value: selectedPerfilId,
              onChanged: (v) => setState(() => selectedPerfilId = v),
            ),
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
            final created = await utilizadoresService.createUtilizador(data);
            Navigator.of(ctx).pop(created != null);
          } catch (e) {
            NotificationService().showError('Erro ao criar utilizador: ${e.toString()}');
            Navigator.of(ctx).pop(false);
          }
        }, child: const Text('Criar')),
      ],
    )),
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
  
  try {
    pacientes = await pacienteService.fetchPacientes();
    medicos = await medicosService.fetchMedicos();
    kits = await kitsService.fetchKits();
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
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Kit (Tipo de Teste)'),
              items: kits.map((k) => DropdownMenuItem(value: k['id']?.toString(), child: Text(k['codigo_barras'] ?? '-'))).toList(),
              value: selectedKitId,
              onChanged: (v) => setState(() => selectedKitId = v),
            ),
            
            const Divider(height: 32),
            const Text('Local e Data de Colheita', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Posto de Colheita'),
              items: postos.map((p) => DropdownMenuItem(value: p['id']?.toString(), child: Text(p['nome'] ?? '-'))).toList(),
              value: selectedPostoId,
              onChanged: (v) => setState(() => selectedPostoId = v),
            ),
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

Future<bool?> showCreateTesteDialog(BuildContext context, TestesService testesService) async {
  final nome = TextEditingController();
  final preco = TextEditingController();
  final descricao = TextEditingController();

  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Criar Teste'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome')),
          TextField(controller: preco, decoration: const InputDecoration(labelText: 'Preço'), keyboardType: TextInputType.number),
          TextField(controller: descricao, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 2),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          if (nome.text.isEmpty) return;
          final created = await testesService.createTeste({
            'nome': nome.text.trim(),
            'preco': double.tryParse(preco.text.replaceAll(',', '.')),
            'descricao': descricao.text.trim(),
          });
          Navigator.of(ctx).pop(created != null);
        }, child: const Text('Criar')),
      ],
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

Future<bool?> showCreatePostoDialog(BuildContext context, PostosService postosService, EmpresasService empresasService) async {
  final nome = TextEditingController();
  final codigoPosto = TextEditingController();
  final localizacao = TextEditingController();
  String? selectedEmpresaId;
  List<Map<String, dynamic>> empresas = [];
  try { empresas = await empresasService.fetchEmpresas(); } catch (_) {}

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
          if (nome.text.isEmpty || selectedEmpresaId == null) return;
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
