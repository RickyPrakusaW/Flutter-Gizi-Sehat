/// Migrasi dari Firebase Provider ke Supabase Riverpod dengan state management yang lebih robust
/// Provider untuk autentikasi pengguna menggunakan Riverpod dan Supabase
/// Mengelola state login, register, logout, dan session user
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/auth_service.dart';
import '../data/repositories/auth_repository.dart';

// ===== Singleton Providers =====

/// Provider untuk Supabase client instance
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider untuk AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthService(supabase);
});

/// Provider untuk AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService);
});

// ===== State Providers =====

/// Provider untuk stream autentikasi state (listening to auth changes)
final authStateStreamProvider = StreamProvider<AuthUserData?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.watchAuthState();
});

/// Provider untuk user saat ini (synchronous)
final currentUserProvider = Provider<AuthUserData?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getCurrentUser();
});

// ===== State Notifier Providers =====

/// State untuk mengelola loading dan error saat login
class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier untuk mengelola autentikasi pengguna
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState());

  /// Login dengan email dan password
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.loginWithEmail(email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      final errorMessage = _parseErrorMessage(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  /// Register dengan email dan password
  Future<bool> registerWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.registerWithEmail(email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      final errorMessage = _parseErrorMessage(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  /// Logout pengguna
  Future<bool> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.logout();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      final errorMessage = _parseErrorMessage(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  /// Reset password - kirim email reset
  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.resetPassword(email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      final errorMessage = _parseErrorMessage(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  /// Update password pengguna
  Future<bool> updatePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.updatePassword(newPassword);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      final errorMessage = _parseErrorMessage(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  /// Parse error dari Supabase ke human-readable message
  String _parseErrorMessage(dynamic error) {
    if (error is AuthException) {
      // Parse Supabase auth exceptions
      return error.message;
    } else if (error is PostgrestException) {
      return error.message;
    } else {
      return error.toString();
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// StateNotifierProvider untuk AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
