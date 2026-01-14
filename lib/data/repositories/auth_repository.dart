import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/auth_service.dart';

/// =======================
/// MODEL USER AUTH
/// =======================
class AuthUserData {
  final String uid;
  final String? email;
  final String? displayName;
  final DateTime? lastSignInAt;

  const AuthUserData({
    required this.uid,
    required this.email,
    this.displayName,
    this.lastSignInAt,
  });

  factory AuthUserData.fromSupabaseUser(User user) {
    return AuthUserData(
      uid: user.id,
      email: user.email,
      displayName: user.userMetadata?['display_name'] as String?,
      lastSignInAt: user.lastSignInAt == null
          ? null
          : DateTime.tryParse(user.lastSignInAt!),
    );
  }
}

/// =======================
/// ABSTRACT REPOSITORY
/// (gabungan kontrak lama + fitur baru)
/// =======================
abstract class AuthRepository {
  Stream<AuthUserData?> watchAuthState();
  AuthUserData? getCurrentUser();

  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();

  /// optional but recommended
  Future<void> resetPassword(String email);
  Future<void> updatePassword(String newPassword);
}

/// =======================
/// IMPLEMENTATION
/// =======================
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  /// Listen perubahan auth (login / logout)
  @override
  Stream<AuthUserData?> watchAuthState() {
    return _authService.watchAuthState().map((state) {
      final user = state.session?.user;
      if (user == null) return null;
      return AuthUserData.fromSupabaseUser(user);
    });
  }

  /// Ambil user saat ini
  @override
  AuthUserData? getCurrentUser() {
    final user = _authService.currentUser;
    if (user == null) return null;
    return AuthUserData.fromSupabaseUser(user);
  }

  /// Login (kontrak kode utama)
  @override
  Future<void> login(String email, String password) async {
    await _authService.signInWithEmail(
      email: email,
      password: password,
    );
  }

  /// Register (kontrak kode utama)
  @override
  Future<void> register(String email, String password) async {
    await _authService.signUpWithEmail(
      email: email,
      password: password,
    );
  }

  /// Logout
  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  /// Reset password via email
  @override
  Future<void> resetPassword(String email) async {
    await _authService.resetPasswordForEmail(email);
  }

  /// Update password user login
  @override
  Future<void> updatePassword(String newPassword) async {
    await _authService.updatePassword(newPassword);
  }
}
