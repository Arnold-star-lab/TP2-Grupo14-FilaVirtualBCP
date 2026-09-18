abstract class AuthRepository {
  Future<void> login(String dni, String password);
  Future<void> register(String dni, String password);
  Future<void> logout();
  Stream<String?> get authStateChanges;
}
