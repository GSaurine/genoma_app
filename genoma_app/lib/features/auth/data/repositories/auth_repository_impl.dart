import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import 'package:genoma_app/core/network/network_info.dart';
import '../../domain/entities/token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';
import 'package:genoma_app/core/network/dio_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final DioClient dioClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.dioClient,
  });

  @override
  Future<Either<Failure, Token>> login({
    required String email,
    required String password,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }

      final token = await remoteDataSource.login(email: email, password: password);
      print('DEBUG: Token recebido com sucesso');
      await localDataSource.saveToken(token as TokenModel);
      print('DEBUG: Token salvo no cache');
      
      // Definir o header de autorização no DioClient para as próximas requisições
      dioClient.setAuthorizationHeader(token.accessToken);
      print('DEBUG: Header de autorização definido: Bearer ${token.accessToken.substring(0, 10)}...');
      
      // Buscar o usuário após o login para popular o cache local
      print('DEBUG: Buscando usuário atual (/auth/me)...');
      final user = await remoteDataSource.getCurrentUser();
      print('DEBUG: Usuário recebido: ${user.name}');
      await localDataSource.saveCurrentUser(user as UserModel);
      print('DEBUG: Usuário salvo no cache local');
      
      return Right(token);
    } catch (e) {
      return Left(
        ApiFailure(message: 'Erro ao fazer login: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }

      final user = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      await localDataSource.saveCurrentUser(user as UserModel);
      return Right(user);
    } catch (e) {
      return Left(
        ApiFailure(message: 'Erro ao registrar: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAll();
      dioClient.removeAuthorizationHeader();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Erro ao fazer logout: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCurrentUser();
      if (user == null) {
        return Left(CacheFailure(message: 'Usuário não encontrado'));
      }
      return Right(user);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Erro ao obter usuário: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Token>> refreshToken() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }

      final token = await remoteDataSource.refreshToken();
      await localDataSource.saveToken(token);
      return Right(token);
    } catch (e) {
      return Left(
        ApiFailure(message: 'Erro ao renovar token: ${e.toString()}'),
      );
    }
  }
}
