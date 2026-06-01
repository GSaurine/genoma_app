import 'package:flutter/material.dart';

class AdminCards extends StatelessWidget {
  final VoidCallback onOperationsTap;
  final VoidCallback onStaffTap;
  final VoidCallback onPartnersTap;
  final VoidCallback onCatalogTap;

  const AdminCards({
    Key? key,
    required this.onOperationsTap,
    required this.onStaffTap,
    required this.onPartnersTap,
    required this.onCatalogTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildPillarCard(
          context,
          'Hub de Operações',
          'Gestão de Exames e Processos',
          Icons.biotech,
          Colors.green,
          onOperationsTap,
        ),
        _buildPillarCard(
          context,
          'Gestão de Staff',
          'Utilizadores e Médicos',
          Icons.people_alt,
          Colors.deepPurple,
          onStaffTap,
        ),
        _buildPillarCard(
          context,
          'Rede de Parceiros',
          'Empresas e Postos',
          Icons.business,
          Colors.blue,
          onPartnersTap,
        ),
        _buildPillarCard(
          context,
          'Catálogo',
          'Configuração de Testes',
          Icons.inventory_2,
          Colors.orange,
          onCatalogTap,
        ),
      ],
    );
  }

  Widget _buildPillarCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
