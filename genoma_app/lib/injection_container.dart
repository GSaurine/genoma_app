// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/local_storage_service.dart';
import 'core/storage/secure_storage_service.dart';

// ========== AUTH FEATURE ==========
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/cubits/auth_cubit.dart';

// ========== PACIENTES FEATURE ==========
import 'features/pacientes/data/datasources/pacientes_remote_datasource.dart';
import 'features/pacientes/data/repositories/pacientes_repository_impl.dart';
import 'features/pacientes/domain/repositories/pacientes_repository.dart';
import 'features/pacientes/presentation/cubits/pacientes_cubit.dart';

// ========== MEDICOS FEATURE ==========
import 'features/medicos/data/datasources/medicos_remote_datasource.dart';
import 'features/medicos/data/repositories/medicos_repository_impl.dart';
import 'features/medicos/domain/repositories/medicos_repository.dart';
import 'features/medicos/presentation/cubits/medicos_cubit.dart';

// ========== TESTES FEATURE ==========
import 'features/testes/data/datasources/testes_remote_datasource.dart';
import 'features/testes/data/repositories/testes_repository_impl.dart';
import 'features/testes/domain/repositories/testes_repository.dart';
import 'features/testes/presentation/cubits/testes_cubit.dart';

// ========== PEDIDOS FEATURE ==========
import 'features/pedidos/data/datasources/pedidos_remote_datasource.dart';
import 'features/pedidos/data/repositories/pedidos_repository_impl.dart';
import 'features/pedidos/domain/repositories/pedidos_repository.dart';
import 'features/pedidos/presentation/cubits/pedidos_cubit.dart';

// ========== RESULTADOS FEATURE ==========
import 'features/resultados/data/datasources/resultados_remote_datasource.dart';
import 'features/resultados/data/repositories/resultados_repository_impl.dart';
import 'features/resultados/domain/repositories/resultados_repository.dart';
import 'features/resultados/presentation/cubits/resultados_cubit.dart';

// ========== UTILIZADORES FEATURE ==========
import 'features/utilizadores/data/datasources/utilizadores_remote_datasources.dart';
import 'features/utilizadores/data/repositories/utilizadores_repository_impl.dart';
import 'features/utilizadores/domain/repositories/utilizadores_repository.dart';
import 'features/utilizadores/presentation/cubits/utilizadores_cubit.dart';

/// GetIt Service Locator Instance
final getIt = GetIt.instance;

/// Configura todas as dependências da aplicação
/// 
/// Deve ser chamado no main() antes de criar a aplikação:
/// ```dart
/// await setupDependencies();
/// runApp(const App());
/// ```
Future<void> setupDependencies() async {
  // ========== Shared Preferences (Local Storage) ==========
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // ========== Secure Storage ==========
  const secureStorage = FlutterSecureStorage();
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  // ========== Storage Services ==========
  getIt.registerSingleton<SecureStorageService>(
    SecureStorageServiceImpl(secureStorage: secureStorage),
  );

  getIt.registerSingleton<LocalStorageService>(
    LocalStorageServiceImpl(sharedPreferences: sharedPreferences),
  );

  // ========== Connectivity ==========
  getIt.registerSingleton<Connectivity>(Connectivity());

  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(),
  );

  // ========== HTTP Client (Dio) ==========
  // O DioClient já inclui os interceptadores automaticamente
  final dioClient = DioClient(
    baseUrl: AppConfig.apiBaseUrl,
  );
  getIt.registerSingleton<DioClient>(dioClient);

  // ========== AUTH FEATURE ==========
  // Remote DataSource
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Local DataSource
  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(localStorageService: getIt<LocalStorageService>()),
  );

  // Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
      dioClient: getIt<DioClient>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(repository: getIt<AuthRepository>()),
  );

  // Cubit
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );

  // ========== PACIENTES FEATURE ==========
  getIt.registerSingleton<PacientesRemoteDataSource>(
    PacientesRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerSingleton<PacientesRepository>(
    PacientesRepositoryImpl(
      remoteDataSource: getIt<PacientesRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerSingleton<PacientesCubit>(
    PacientesCubit(repository: getIt<PacientesRepository>()),
  );

  // ========== MEDICOS FEATURE ==========
  getIt.registerSingleton<MedicosRemoteDataSource>(
    MedicosRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerSingleton<MedicosRepository>(
    MedicosRepositoryImpl(
      remoteDataSource: getIt<MedicosRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerSingleton<MedicosCubit>(
    MedicosCubit(repository: getIt<MedicosRepository>()),
  );

  // ========== TESTES FEATURE ==========
  getIt.registerSingleton<TestesRemoteDataSource>(
    TestesRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerSingleton<TestesRepository>(
    TestesRepositoryImpl(
      remoteDataSource: getIt<TestesRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerSingleton<TestesCubit>(
    TestesCubit(repository: getIt<TestesRepository>()),
  );

  // ========== PEDIDOS FEATURE ==========
  getIt.registerSingleton<PedidosRemoteDataSource>(
    PedidosRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerSingleton<PedidosRepository>(
    PedidosRepositoryImpl(
      remoteDataSource: getIt<PedidosRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerSingleton<PedidosCubit>(
    PedidosCubit(repository: getIt<PedidosRepository>()),
  );

  // ========== RESULTADOS FEATURE ==========
  getIt.registerSingleton<ResultadosRemoteDataSource>(
    ResultadosRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerSingleton<ResultadosRepository>(
    ResultadosRepositoryImpl(
      remoteDataSource: getIt<ResultadosRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerSingleton<ResultadosCubit>(
    ResultadosCubit(repository: getIt<ResultadosRepository>()),
  );

  // ========== UTILIZADORES FEATURE ==========
  getIt.registerSingleton<UtilizadoresRemoteDataSource>(
    UtilizadoresRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerSingleton<UtilizadoresRepository>(
    UtilizadoresRepositoryImpl(
      remoteDataSource: getIt<UtilizadoresRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerSingleton<UtilizadoresCubit>(
    UtilizadoresCubit(repository: getIt<UtilizadoresRepository>()),
  );
}

/// Registra um repositório no container
/// Uso: registerRepository<MinhaRepository>(implementacao);
void registerRepository<T extends Object>(T repository) {
  getIt.registerSingleton<T>(repository);
}

/// Registra um use case no container
/// Uso: registerUseCase<MeuUseCase>(implementacao);
void registerUseCase<T extends Object>(T useCase) {
  getIt.registerSingleton<T>(useCase);
}

/// Registra um BLoC ou Cubit no container
/// Uso: registerBloc<MeuCubit>(implementacao);
void registerBloc<T extends Object>(T bloc) {
  getIt.registerSingleton<T>(bloc);
}

/// Helper para obter uma dependência
/// Uso: final service = resolve<MeuService>();
T resolve<T extends Object>() {
  return getIt<T>();
}
