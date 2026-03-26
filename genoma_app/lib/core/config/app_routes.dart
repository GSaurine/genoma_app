/// Definição de todas as rotas nomeadas da aplicação
class AppRoutes {
  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Pacientes routes
  static const String pacientesList = '/pacientes';
  static const String pacienteDetail = '/pacientes/:id';
  static const String pacienteForm = '/pacientes/form';
  static const String pacienteEdit = '/pacientes/:id/edit';

  // Medicos routes
  static const String medicosList = '/medicos';
  static const String medicoDetail = '/medicos/:id';
  static const String medicoForm = '/medicos/form';
  static const String medicoEdit = '/medicos/:id/edit';

  // Testes routes
  static const String testesList = '/testes';
  static const String testeDetail = '/testes/:id';
  static const String testeForm = '/testes/form';

  // Pedidos routes
  static const String pedidosList = '/pedidos';
  static const String pedidoDetail = '/pedidos/:id';
  static const String pedidoForm = '/pedidos/form';

  // Resultados routes
  static const String resultadosList = '/resultados';
  static const String resultadoDetail = '/resultados/:id';

  // Empresas routes
  static const String empresasList = '/empresas';
  static const String empresaDetail = '/empresas/:id';

  // Utilizadores routes
  static const String utilizadoresList = '/utilizadores';
  static const String utilizadorDetail = '/utilizadores/:id';

  // Configurações e perfil
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';

  // Método auxiliar para gerar rotas com parâmetros
  static String pacienteDetailRoute(String id) => '/pacientes/$id';
  static String pacienteEditRoute(String id) => '/pacientes/$id/edit';

  static String medicoDetailRoute(String id) => '/medicos/$id';
  static String medicoEditRoute(String id) => '/medicos/$id/edit';

  static String testeDetailRoute(String id) => '/testes/$id';

  static String pedidoDetailRoute(String id) => '/pedidos/$id';

  static String resultadoDetailRoute(String id) => '/resultados/$id';

  static String empresaDetailRoute(String id) => '/empresas/$id';

  static String utilizadorDetailRoute(String id) => '/utilizadores/$id';
}
