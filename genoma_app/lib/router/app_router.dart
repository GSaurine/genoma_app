// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Auth Feature
import 'package:genoma_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:genoma_app/features/auth/presentation/pages/splash_page.dart';
import 'package:genoma_app/features/auth/presentation/pages/home_page.dart';
import 'package:genoma_app/features/auth/presentation/pages/login_page.dart';
import 'package:genoma_app/features/auth/presentation/pages/register_page.dart';

// Pacientes Feature
import 'package:genoma_app/features/pacientes/presentation/cubits/pacientes_cubit.dart';
import 'package:genoma_app/features/pacientes/presentation/pages/pacientes_list_page.dart';

// Medicos Feature
import 'package:genoma_app/features/medicos/presentation/cubits/medicos_cubit.dart';
import 'package:genoma_app/features/medicos/presentation/pages/medicos_list_page.dart';

// Testes Feature
import 'package:genoma_app/features/testes/presentation/cubits/testes_cubit.dart';
import 'package:genoma_app/features/testes/presentation/pages/testes_list_page.dart';

// Pedidos Feature
import 'package:genoma_app/features/pedidos/presentation/cubits/pedidos_cubit.dart';
import 'package:genoma_app/features/pedidos/presentation/pages/pedidos_list_page.dart';

// Resultados Feature
import 'package:genoma_app/features/resultados/presentation/cubits/resultados_cubit.dart';
import 'package:genoma_app/features/resultados/presentation/pages/resultados_list_page.dart';

// Admin Feature
import 'package:genoma_app/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:genoma_app/features/admin/presentation/pages/admin_users_page.dart';
import 'package:genoma_app/features/admin/presentation/pages/generic_admin_table_page.dart';
import 'package:genoma_app/features/utilizadores/presentation/cubits/utilizadores_cubit.dart';

// Importar os pages existentes para as rotas
import 'package:genoma_app/features/empresas/presentation/pages/empresas_page.dart';
import 'package:genoma_app/features/empresas/presentation/cubits/empresas_cubit.dart';

import 'package:genoma_app/injection_container.dart' as di;

/// Configuração do roteador com GoRouter
/// Inicia na página de Splash para verificar autenticação
final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Erro')),
    body: Center(
      child: Text(
        'Página não encontrada: ${state.error}',
        textAlign: TextAlign.center,
      ),
    ),
  ),
  observers: [
    _GoRouterObserver(),
  ],
  routes: [
    // ====== ROTAS DE AUTENTICAÇÃO ======

    /// Rota Splash - Página de carregamento inicial
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<AuthCubit>(),
        child: const SplashPage(),
      ),
    ),

    /// Rota de Login - Página inicial da aplicação
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<AuthCubit>(),
        child: const LoginPage(),
      ),
    ),

    /// Rota de Registro
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<AuthCubit>(),
        child: const RegisterPage(),
      ),
    ),

    // ====== ROTAS PRINCIPAIS ======

    /// Home Page com menu de navegação
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<AuthCubit>(),
        child: const HomePage(),
      ),
    ),

    // ====== ROTAS DE PACIENTES ======

    GoRoute(
      path: '/pacientes',
      name: 'pacientes',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<PacientesCubit>(),
        child: const PacientesListPage(),
      ),
    ),

    // ====== ROTAS DE MÉDICOS ======

    GoRoute(
      path: '/medicos',
      name: 'medicos',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<MedicosCubit>(),
        child: const MedicosListPage(),
      ),
    ),

    // ====== ROTAS DE TESTES ======

    GoRoute(
      path: '/testes',
      name: 'testes',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<TestesCubit>(),
        child: const TestesListPage(),
      ),
    ),

    // ====== ROTAS DE PEDIDOS ======

    GoRoute(
      path: '/pedidos',
      name: 'pedidos',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<PedidosCubit>(),
        child: const PedidosListPage(),
      ),
    ),

    // ====== ROTAS DE RESULTADOS ======

    GoRoute(
      path: '/resultados',
      name: 'resultados',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<ResultadosCubit>(),
        child: const ResultadosListPage(),
      ),
    ),

    // ====== ROTAS DE ADMIN ======

    GoRoute(
      path: '/admin',
      name: 'admin-dashboard',
      builder: (context, state) => const AdminDashboardPage(),
    ),

    GoRoute(
      path: '/admin/users',
      name: 'admin-users',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<UtilizadoresCubit>(),
        child: const AdminUsersPage(),
      ),
    ),

    // Outras tabelas Administrativas
    GoRoute(
      path: '/admin/perfis',
      name: 'perfis-list',
      builder: (context, state) => const GenericAdminTablePage(title: 'Perfis'),
    ),

    GoRoute(
      path: '/admin/empresas',
      name: 'empresas-list',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<EmpresasCubit>(),
        child: const EmpresasPage(),
      ),
    ),

    GoRoute(
      path: '/admin/postos',
      name: 'postos-list',
      builder: (context, state) => const GenericAdminTablePage(title: 'Postos'),
    ),

    GoRoute(
      path: '/admin/testes',
      name: 'testes-list',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<TestesCubit>(),
        child: const TestesListPage(),
      ),
    ),

    GoRoute(
      path: '/admin/itens',
      name: 'itens-list',
      builder: (context, state) => const GenericAdminTablePage(title: 'Itens de Pesquisa'),
    ),

    GoRoute(
      path: '/admin/kits',
      name: 'kits-list',
      builder: (context, state) => const GenericAdminTablePage(title: 'Kits'),
    ),

    GoRoute(
      path: '/admin/processos',
      name: 'processos-list',
      builder: (context, state) => const GenericAdminTablePage(title: 'Processos'),
    ),

    GoRoute(
      path: '/admin/medicos',
      name: 'medicos-list',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<MedicosCubit>(),
        child: const MedicosListPage(),
      ),
    ),

    GoRoute(
      path: '/admin/pacientes',
      name: 'pacientes-list',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<PacientesCubit>(),
        child: const PacientesListPage(),
      ),
    ),

    GoRoute(
      path: '/admin/pedidos',
      name: 'pedidos-list',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<PedidosCubit>(),
        child: const PedidosListPage(),
      ),
    ),

    GoRoute(
      path: '/admin/resultados',
      name: 'resultados-list',
      builder: (context, state) => BlocProvider.value(
        value: di.getIt<ResultadosCubit>(),
        child: const ResultadosListPage(),
      ),
    ),
  ],
);

/// Observer para rastrear mudanças de rota
class _GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Navegando para: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Volta de: ${route.settings.name}');
  }
}
