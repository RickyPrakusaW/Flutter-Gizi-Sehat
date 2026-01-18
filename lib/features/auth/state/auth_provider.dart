import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gizi_sehat_mobile_app/data/repositories/auth_repository.dart';
import 'package:gizi_sehat_mobile_app/data/repositories/auth_repository_impl.dart';
import 'package:gizi_sehat_mobile_app/core/services/auth_service.dart';
import 'package:gizi_sehat_mobile_app/features/auth/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

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
        _userModel = null;
        _userSub?.cancel(); // Cancel subscription to prevent stale data updates
        _userSub = null;
      } else {
        _status = AuthStatus.authenticated;
        _currentEmail = userData.email;
        _fetchUserRole(userData.uid);
      }
      notifyListeners();
    });
  }

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  StreamSubscription<DocumentSnapshot>? _userSub;

  void _fetchUserRole(String uid) {
    _userSub?.cancel();
    _userSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
          (doc) {
            if (doc.exists && doc.data() != null) {
              _userModel = UserModel.fromJson(doc.data()!);
              debugPrint(
                'User updated: ${_userModel?.email}, Role: ${_userModel?.role}, Status: ${_userModel?.status}',
              );
              notifyListeners();
            }
          },
          onError: (e) {
            debugPrint('Error listening to user role: $e');
          },
        );
  }

  /// Login user menggunakan email & password Firebase Auth
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      await _repo.login(email, password);
      debugPrint('Login success: $email');
      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      _setLoading(false);
      _setError(_readableError(e));
      return false;
    }
  }

  /// Registrasi user baru di Firebase Auth
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    UserRole role = UserRole.parent,
    String? title,
    String? specialist,
    String? strNumber,
    String? sipNumber,
    String? practiceLocation,
    String? alumni,
    int? experienceYear,
    File? proofImage,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _repo.register(
        email,
        password,
        role: role,
        name: name,
        title: title,
        specialist: specialist,
        strNumber: strNumber,
        sipNumber: sipNumber,
        practiceLocation: practiceLocation,
        alumni: alumni,
        experienceYear: experienceYear,
        proofImage: proofImage,
      );
      debugPrint('Register success: $email');

      // Setelah register → langsung logout agar user kembali ke halaman login
      await _repo.logout();

      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      _setLoading(false);
      _setError(_readableError(e));
      return false;
    }
  }

  /// Login user menggunakan Google Sign-In
  /// Method ini akan:
  /// 1. Membuka dialog Google Sign-In
  /// 2. User memilih akun Google
  /// 3. Otomatis sign in ke Firebase
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      await _repo.signInWithGoogle();
      debugPrint('Google Sign-In success');
      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      _setLoading(false);
      _setError(_readableError(e));
      return false;
    }
  }

  /// Logout user dari Firebase Auth
  Future<void> logout() async {
    // 1. Clear state lokal DULUAN agar UI langsung bereaksi/reset
    _status = AuthStatus.unauthenticated;
    _currentEmail = null;
    _userModel = null;
    _userSub?.cancel();
    _userSub = null;

    // 2. Notify listeners agar UI yang bergantung pada authState segera update
    notifyListeners();

    // 3. Lakukan logout sesungguhnya di Firebase/Repo
    await _repo.logout();
    debugPrint('User logged out (Cleaned local state)');
  }

  // ============ Profile Updates ============

  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    String? province,
    String? city,
    String? district,
  }) async {
    _setLoading(true);
    try {
      final user = _repo.currentUser;
      if (user != null) {
        // Update Firestore
        final Map<String, dynamic> data = {};
        if (name != null) data['name'] = name;
        if (photoUrl != null) data['profileImage'] = photoUrl;
        if (province != null) data['province'] = province;
        if (city != null) data['city'] = city;
        if (district != null) data['district'] = district;

        if (data.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update(data);
        }
      }
      _setLoading(false);
    } catch (e) {
      debugPrint('Update profile error: $e');
      _setLoading(false);
      _setError('Gagal memperbarui profil: $e');
      rethrow;
    }
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
    if (raw.contains('user-not-found') || (raw.contains('no user record'))) {
      return 'Akun tidak ditemukan';
    }
    if (raw.contains('wrong-password')) {
      return 'Password salah';
    }
    // Error untuk Google Sign-In
    if (raw.contains('dibatalkan') || raw.contains('cancelled')) {
      return 'Login dengan Google dibatalkan';
    }
    if (raw.contains('network_error') || raw.contains('network')) {
      return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
    }

    // Fallback
    return 'Terjadi kesalahan: $raw';
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _userSub?.cancel();
    super.dispose();
  }
}
