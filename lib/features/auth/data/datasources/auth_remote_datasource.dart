import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Helpers to simulate BCP DNI domain
  String _formatEmail(String dni) => '$dni@bcp.com';

  Future<void> login(String dni, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _formatEmail(dni),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al iniciar sesión.');
    }
  }

  Future<void> register(String dni, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: _formatEmail(dni),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al registrar.');
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('El DNI no está registrado.');
      case 'wrong-password':
        return Exception('Contraseña incorrecta.');
      case 'email-already-in-use':
        return Exception('Este DNI ya se encuentra registrado.');
      case 'weak-password':
        return Exception('La contraseña es muy débil (mínimo 6 caracteres).');
      case 'invalid-credential':
        return Exception('Credenciales inválidas, verifica tu DNI y contraseña.');
      default:
        return Exception(e.message ?? 'Error de autenticación.');
    }
  }
}
