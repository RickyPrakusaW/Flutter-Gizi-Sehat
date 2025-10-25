import 'package:gizi_sehat_mobile_app/core/services/auth_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl(this._service);

  @override
  Stream<AuthUserData?> watchAuthState() {
    return _service.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUserData(
        uid: user.uid,
        email: user.email,
      );
    });
  }

  @override
  Future<void> login(String email, String password) {
    return _service.signInWithEmail(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> register(String email, String password) async {
    await _service.registerWithEmail(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return _service.signOut();
  }
}
