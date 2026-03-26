import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestão de Sistema',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildAdminCard(
                  context,
                  title: 'Utilizadores',
                  icon: Icons.people_outline,
                  onTap: () => context.goNamed('admin-users'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Perfis',
                  icon: Icons.admin_panel_settings_outlined,
                  onTap: () => context.goNamed('perfis-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Empresas',
                  icon: Icons.business_outlined,
                  onTap: () => context.goNamed('empresas-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Postos',
                  icon: Icons.location_on_outlined,
                  onTap: () => context.goNamed('postos-list'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Configurações de Exames',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildAdminCard(
                  context,
                  title: 'Testes',
                  icon: Icons.biotech_outlined,
                  onTap: () => context.goNamed('testes-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Itens Pesquisa',
                  icon: Icons.list_alt_outlined,
                  onTap: () => context.goNamed('itens-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Kits',
                  icon: Icons.inventory_2_outlined,
                  onTap: () => context.goNamed('kits-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Processos',
                  icon: Icons.account_tree_outlined,
                  onTap: () => context.goNamed('processos-list'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Gestão de Saúde',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildAdminCard(
                  context,
                  title: 'Médicos',
                  icon: Icons.medical_services_outlined,
                  onTap: () => context.goNamed('medicos-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Pacientes',
                  icon: Icons.person_search_outlined,
                  onTap: () => context.goNamed('pacientes-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Pedidos',
                  icon: Icons.assignment_outlined,
                  onTap: () => context.goNamed('pedidos-list'),
                ),
                _buildAdminCard(
                  context,
                  title: 'Resultados',
                  icon: Icons.description_outlined,
                  onTap: () => context.goNamed('resultados-list'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
