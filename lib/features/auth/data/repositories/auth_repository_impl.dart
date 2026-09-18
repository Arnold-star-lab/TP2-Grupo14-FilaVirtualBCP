import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> login(String dni, String password) {
    return remoteDataSource.login(dni, password);
  }

  @override
  Future<void> register(String dni, String password) {
    return remoteDataSource.register(dni, password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Stream<String?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((User? user) => user?.email?.split('@').first);
  }
}
