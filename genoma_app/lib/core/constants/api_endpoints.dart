/// Definição de todos os endpoints da API
class ApiEndpoints {
  // Auth endpoints
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authVerifyToken = '/auth/verify';

  // Pacientes endpoints
  static const String pacientes = '/pacientes';
  static String pacienteById(String id) => '/pacientes/$id';
  static const String pacientesCreate = '/pacientes';
  static String pacienteUpdate(String id) => '/pacientes/$id';
  static String pacienteDelete(String id) => '/pacientes/$id';
  static const String pacientesSearch = '/pacientes/search';

  // Médicos endpoints
  static const String medicos = '/medicos';
  static String medicoById(String id) => '/medicos/$id';
  static const String medicosCreate = '/medicos';
  static String medicoUpdate(String id) => '/medicos/$id';
  static String medicoDelete(String id) => '/medicos/$id';

  // Testes endpoints
  static const String testes = '/testes';
  static String testeById(String id) => '/testes/$id';
  static const String testesCreate = '/testes';
  static String testeUpdate(String id) => '/testes/$id';
  static String testeDelete(String id) => '/testes/$id';

  // Pedidos de exames endpoints
  static const String pedidos = '/pedidos';
  static String pedidoById(String id) => '/pedidos/$id';
  static const String pedidosCreate = '/pedidos';
  static String pedidoUpdate(String id) => '/pedidos/$id';
  static String pedidoDelete(String id) => '/pedidos/$id';

  // Resultados detalhados endpoints
  static const String resultados = '/resultados';
  static String resultadoById(String id) => '/resultados/$id';
  static const String resultadosCreate = '/resultados';
  static String resultadoUpdate(String id) => '/resultados/$id';

  // Empresas endpoints
  static const String empresas = '/empresas';
  static String empresaById(String id) => '/empresas/$id';
  static const String empresasCreate = '/empresas';
  static String empresaUpdate(String id) => '/empresas/$id';

  // Utilizadores endpoints
  static const String utilizadores = '/utilizadores';
  static String utilizadorById(String id) => '/utilizadores/$id';
  static const String utilizadoresCreate = '/utilizadores';
  static String utilizadorUpdate(String id) => '/utilizadores/$id';

  // Perfis endpoints
  static const String perfis = '/perfis';
  static String perfilById(String id) => '/perfis/$id';

  // Itens de pesquisa endpoints
  static const String itensPesquisa = '/itens-pesquisa';

  // Composição de testes endpoints
  static const String testeComposicao = '/teste-composicao';
}
