import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gizi_sehat_mobile_app/data/repositories/auth_repository.dart';
import 'package:gizi_sehat_mobile_app/data/repositories/auth_repository_impl.dart';
import 'package:gizi_sehat_mobile_app/core/services/auth_service.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepositoryImpl(AuthService());
  StreamSubscription<AuthUserData?>? _authSub;

  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _currentEmail;
  String? get currentEmail => _currentEmail;

  AuthProvider() {
    // Dengarkan perubahan login/logout dari Firebase
    _authSub = _repo.watchAuthState().listen((userData) {
      if (userData == null) {
        _status = AuthStatus.unauthenticated;
        _currentEmail = null;
      } else {
        _status = AuthStatus.authenticated;
        _currentEmail = userData.email;
      }
      notifyListeners();
    });
  }

  /// Login user menggunakan email & password Firebase Auth
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _repo.login(email, password);
      debugPrint('✅ Login success: $email');
      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      _setLoading(false);
      _setError(_readableError(e));
      return false;
    }
  }

  /// Registrasi user baru di Firebase Auth
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _repo.register(email, password);
      debugPrint('✅ Register success: $email');

      // Setelah register → langsung logout agar user kembali ke halaman login
      await _repo.logout();

      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('❌ Register error: $e');
      _setLoading(false);
      _setError(_readableError(e));
      return false;
    }
  }

  /// Logout user dari Firebase Auth
  Future<void> logout() async {
    await _repo.logout();
    debugPrint('👋 User logged out');
  }

  // ============ Internal Helpers ============
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _readableError(Object e) {
    final raw = e.toString();

    // Mapping error Firebase Auth ke bahasa manusia
    if (raw.contains('email-already-in-use')) {
      return 'Email sudah terdaftar';
    }
    if (raw.contains('invalid-email')) {
      return 'Format email tidak valid';
    }
    if (raw.contains('weak-password')) {
      return 'Password terlalu lemah';
    }
    if (raw.contains('user-not-found') ||
        (raw.contains('no user record'))) {
      return 'Akun tidak ditemukan';
    }
    if (raw.contains('wrong-password')) {
      return 'Password salah';
    }

    // Fallback
    return 'Terjadi kesalahan: $raw';
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
