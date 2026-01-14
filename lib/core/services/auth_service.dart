// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:flutter/foundation.dart';

/// Simple cross-backend user model used by the unified API
class SimpleUser {
  final String id;
  final String? email;

  SimpleUser({required this.id, this.email});

  @override
  String toString() => 'SimpleUser(id: $id, email: $email)';
}

/// Unified interface for auth service adapters
abstract class IAuthService {
  SimpleUser? get currentUser;
  Stream<SimpleUser?> authStateChanges();
  Future<SimpleUser?> signInWithEmail({
    required String email,
    required String password,
  });
  Future<SimpleUser?> signUpWithEmail({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> resetPasswordForEmail(String email);
  Future<void> updatePassword(String newPassword);
}

/// Firebase adapter
class FirebaseAuthAdapter implements IAuthService {
  final fb.FirebaseAuth _auth;

  FirebaseAuthAdapter({fb.FirebaseAuth? instance})
      : _auth = instance ?? fb.FirebaseAuth.instance;

  @override
  SimpleUser? get currentUser {
    final u = _auth.currentUser;
    if (u == null) return null;
    return SimpleUser(id: u.uid, email: u.email);
  }

  @override
  Stream<SimpleUser?> authStateChanges() {
    return _auth.authStateChanges().map((fb.User? u) {
      if (u == null) return null;
      return SimpleUser(id: u.uid, email: u.email);
    });
  }

  @override
  Future<SimpleUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final u = cred.user;
    if (kDebugMode) {
      print('[FirebaseAuth] signIn: ${u?.email}');
    }
    return u == null ? null : SimpleUser(id: u.uid, email: u.email);
  }

  @override
  Future<SimpleUser?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final u = cred.user;
    if (kDebugMode) {
      print('[FirebaseAuth] signUp: ${u?.email}');
    }
    return u == null ? null : SimpleUser(id: u.uid, email: u.email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    if (kDebugMode) print('[FirebaseAuth] signOut');
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
    if (kDebugMode) print('[FirebaseAuth] resetPassword email sent to $email');
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    final u = _auth.currentUser;
    if (u == null) throw Exception('No authenticated user to update password');
    await u.updatePassword(newPassword);
    if (kDebugMode) print('[FirebaseAuth] password updated');
  }
}

/// Supabase adapter
class SupabaseAuthAdapter implements IAuthService {
  final sb.SupabaseClient _supabase;

  SupabaseAuthAdapter(this._supabase);

  @override
  SimpleUser? get currentUser {
    final u = _supabase.auth.currentUser;
    if (u == null) return null;
    return SimpleUser(id: u.id, email: u.email);
  }

  @override
  Stream<SimpleUser?> authStateChanges() {
    // Supabase's onAuthStateChange yields AuthState changes; map to SimpleUser
    return _supabase.auth.onAuthStateChange.map((sb.AuthState state) {
      final session = state.session;
      final u = session?.user ?? _supabase.auth.currentUser;
      if (u == null) return null;
      return SimpleUser(id: u.id, email: u.email);
    });
  }

  @override
  Future<SimpleUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );
    final u = res.user;
    if (kDebugMode) {
      print('[SupabaseAuth] signIn: ${u?.email}');
    }
    return u == null ? null : SimpleUser(id: u.id, email: u.email);
  }

  @override
  Future<SimpleUser?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final res = await _supabase.auth.signUp(
      email: email.trim(),
      password: password.trim(),
    );
    final u = res.user;
    if (kDebugMode) {
      print('[SupabaseAuth] signUp: ${u?.email}');
    }
    return u == null ? null : SimpleUser(id: u.id, email: u.email);
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    if (kDebugMode) print('[SupabaseAuth] signOut');
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(email.trim());
    if (kDebugMode) {
      print('[SupabaseAuth] resetPassword email requested for $email');
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      sb.UserAttributes(password: newPassword.trim()),
    );
    if (kDebugMode) print('[SupabaseAuth] password updated');
  }
}

/// Simple enum to pick backend
enum AuthBackend { firebase, supabase }

/// Unified service that delegates to the chosen adapter.
/// Use UnifiedAuthService.firebase() or UnifiedAuthService.supabase(client)
class UnifiedAuthService implements IAuthService {
  final IAuthService _delegate;
  final AuthBackend backend;

  UnifiedAuthService._(this._delegate, this.backend);

  factory UnifiedAuthService.firebase({fb.FirebaseAuth? instance}) {
    return UnifiedAuthService._(
      FirebaseAuthAdapter(instance: instance),
      AuthBackend.firebase,
    );
  }

  factory UnifiedAuthService.supabase(sb.SupabaseClient client) {
    return UnifiedAuthService._(
      SupabaseAuthAdapter(client),
      AuthBackend.supabase,
    );
  }

  // convenience: create from a flag
  factory UnifiedAuthService.fromBackend({
    required AuthBackend backend,
    fb.FirebaseAuth? firebaseInstance,
    sb.SupabaseClient? supabaseClient,
  }) {
    switch (backend) {
      case AuthBackend.firebase:
        return UnifiedAuthService.firebase(instance: firebaseInstance);
      case AuthBackend.supabase:
        if (supabaseClient == null) {
          throw ArgumentError.value(supabaseClient, 'supabaseClient',
              'SupabaseClient must be provided for Supabase backend');
        }
        return UnifiedAuthService.supabase(supabaseClient);
    }
  }

  @override
  SimpleUser? get currentUser => _delegate.currentUser;

  @override
  Stream<SimpleUser?> authStateChanges() => _delegate.authStateChanges();

  @override
  Future<SimpleUser?> signInWithEmail(
      {required String email, required String password}) =>
      _delegate.signInWithEmail(email: email, password: password);

  @override
  Future<SimpleUser?> signUpWithEmail(
      {required String email, required String password}) =>
      _delegate.signUpWithEmail(email: email, password: password);

  @override
  Future<void> signOut() => _delegate.signOut();

  @override
  Future<void> resetPasswordForEmail(String email) =>
      _delegate.resetPasswordForEmail(email);

  @override
  Future<void> updatePassword(String newPassword) =>
      _delegate.updatePassword(newPassword);
}
