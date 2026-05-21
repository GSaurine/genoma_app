import 'package:flutter/material.dart';

class AdminCards extends StatelessWidget {
  final VoidCallback onCreatePaciente;
  final VoidCallback onCreateEmpresa;
  final VoidCallback onCreateKit;
  final VoidCallback onCreateUtilizador;
  final VoidCallback onCreateProcesso;
  final VoidCallback onCreatePerfil;
  final VoidCallback onCreateMedico;
  final VoidCallback onCreateTeste;
  final VoidCallback onCreateItem;
  final VoidCallback onCreatePosto;
  final VoidCallback onCreateResultado;
  final VoidCallback onCreateResultadoGenetico;

  const AdminCards({
    Key? key,
    required this.onCreatePaciente,
    required this.onCreateEmpresa,
    required this.onCreateKit,
    required this.onCreateUtilizador,
    required this.onCreateProcesso,
    required this.onCreatePerfil,
    required this.onCreateMedico,
    required this.onCreateTeste,
    required this.onCreateItem,
    required this.onCreatePosto,
    required this.onCreateResultado,
    required this.onCreateResultadoGenetico,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard('Processos (Exames)', 'Criar novo processo de exame', onCreateProcesso, color: Colors.green.withOpacity(0.05)),
        const SizedBox(height: 12),
        _buildCard('Pacientes', 'Criar / gerenciar pacientes', onCreatePaciente),
        const SizedBox(height: 12),
        _buildCard('Empresas', 'Criar / gerenciar empresas', onCreateEmpresa),
        const SizedBox(height: 12),
        _buildCard('Utilizadores', 'Criar / gerenciar utilizadores', onCreateUtilizador),
        const SizedBox(height: 12),
        _buildCard('Kits', 'Criar / gerenciar kits', onCreateKit),
        const SizedBox(height: 12),
        _buildCard('Perfis', 'Criar perfis de acesso', onCreatePerfil),
        const SizedBox(height: 12),
        _buildCard('Médicos', 'Criar registo de médico', onCreateMedico),
        const SizedBox(height: 12),
        _buildCard('Postos', 'Criar postos de colheita', onCreatePosto),
        const SizedBox(height: 12),
        _buildCard('Testes', 'Criar tipos de testes', onCreateTeste),
        const SizedBox(height: 12),
        _buildCard('Itens de Pesquisa', 'Criar itens para resultados', onCreateItem),
        const SizedBox(height: 12),
        _buildCard('Resultados Detalhados', 'Criar resultados para exames', onCreateResultado),
        const SizedBox(height: 12),
        _buildCard('Resultados Genéticos', 'Criar dados genéticos', onCreateResultadoGenetico),
      ],
    );
  }

  Widget _buildCard(String title, String subtitle, VoidCallback onPressed, {Color? color}) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(onPressed: onPressed, child: const Text('Criar')),
      ),
    );
  }
}
