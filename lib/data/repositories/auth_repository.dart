class AuthUserData {
  final String uid;
  final String? email;
  const AuthUserData({
    required this.uid,
    required this.email,
  });
}

abstract class AuthRepository {
  Stream<AuthUserData?> watchAuthState();
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();
}
