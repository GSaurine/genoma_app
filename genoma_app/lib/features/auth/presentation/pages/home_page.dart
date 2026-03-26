import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_MenuItemData> _menuItems = [
    _MenuItemData(
      icon: Icons.people_outlined,
      title: 'Pacientes',
      route: 'pacientes',
      description: 'Gerenciar pacientes',
    ),
    _MenuItemData(
      icon: Icons.medical_services_outlined,
      title: 'Médicos',
      route: 'medicos',
      description: 'Gerenciar médicos',
    ),
    _MenuItemData(
      icon: Icons.assignment_outlined,
      title: 'Testes',
      route: 'testes',
      description: 'Tipos de testes',
    ),
    _MenuItemData(
      icon: Icons.receipt_long_outlined,
      title: 'Pedidos',
      route: 'pedidos',
      description: 'Pedidos de exames',
    ),
    _MenuItemData(
      icon: Icons.description_outlined,
      title: 'Resultados',
      route: 'resultados',
      description: 'Resultados de exames',
    ),
  ];

  List<_MenuItemData> get _filteredMenuItems {
    final state = context.read<AuthCubit>().state;
    final items = List<_MenuItemData>.from(_menuItems);
    
    if (state is AuthSuccess && state.user.role == 'admin') {
      items.add(_MenuItemData(
        icon: Icons.admin_panel_settings_outlined,
        title: 'Administração',
        route: 'admin-dashboard',
        description: 'Painel administrativo',
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.goNamed('login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout realizado com sucesso')),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Genoma App'),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthSuccess) {
                      return Text(
                        'Olá, ${state.user.name}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header do drawer
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.top + 16,
              horizontal: 16,
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white24,
                        child: Text(
                          state.user.name.isNotEmpty
                              ? state.user.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 16),

          // Menu items
          ..._filteredMenuItems.map((item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            subtitle: Text(item.description),
            onTap: () {
              Navigator.pop(context);
              context.goNamed(item.route);
            },
          )),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            subtitle: const Text('Sair da aplicação'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bem-vindo
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo de volta!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'O que deseja fazer hoje?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Grid de opções principais
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: _filteredMenuItems.length,
            itemBuilder: (context, index) {
              final item = _filteredMenuItems[index];
              return _buildMenuCard(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, _MenuItemData item) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.goNamed(item.route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair da aplicação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String route;
  final String description;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.route,
    required this.description,
  });
}
