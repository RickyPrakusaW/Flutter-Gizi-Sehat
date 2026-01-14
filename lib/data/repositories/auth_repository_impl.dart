import 'package:gizi_sehat_mobile_app/core/services/auth_service.dart';
import 'auth_repository.dart';

// =======================================================
// 🧱 AUTH REPOSITORY IMPLEMENTATION
// =======================================================
// Ini jembatan:
// UI ❌❌❌ Firebase
// UI ✅ Repository ✅ Service 🔥
//
// ASCII FLOW:
//
//   UI 🖥️
//    |
//    v
//  AuthRepositoryImpl 🧱
//    |
//    v
//   AuthService 🔥
//    |
//    v
// Firebase Auth ☁️
//
// =======================================================

class AuthRepositoryImpl implements AuthRepository {
  // 🔌 Dependency: AuthService
  // Bisa diganti mock kalau mau testing 😎
  final AuthService _service;

  // Constructor injection
  AuthRepositoryImpl(this._service) {
    print("🧱 AuthRepositoryImpl dibuat");
  }

  // ===================================================
  // 👀 WATCH AUTH STATE
  // ===================================================
  // Firebase user ➡️ Domain user
  // Mapping biar UI tetap suci ✨
  @override
  Stream<AuthUserData?> watchAuthState() {
    print("👀 watchAuthState() mulai dipantau...");

    return _service.authStateChanges().map((user) {
      if (user == null) {
        print("🚫 User belum login / sudah logout");
        return null;
      }

      print("✅ User terdeteksi");
      print("🆔 UID   : ${user.uid}");
      print("📧 Email : ${user.email}");

      return AuthUserData(
        uid: user.uid,
        email: user.email,
      );
    });
  }

  // ===================================================
  // 🔑 LOGIN
  // ===================================================
  // UI panggil login,
  // repository neruskan tanpa drama 😌
  @override
  Future<void> login(String email, String password) {
    print("");
    print("🔑 ================================");
    print("🔑 Repository LOGIN dipanggil");
    print("📧 Email: $email");
    print("🔑 ================================");
    print("");

    return _service.signInWithEmail(
      email: email,
      password: password,
    );
  }

  // ===================================================
  // 📝 REGISTER
  // ===================================================
  // Lahirnya akun baru ke dunia digital 🎉
  @override
  Future<void> register(String email, String password) async {
    print("");
    print("📝 ================================");
    print("📝 Repository REGISTER dipanggil");
    print("📧 Email: $email");
    print("📝 ================================");
    print("");

    await _service.registerWithEmail(
      email: email,
      password: password,
    );

    print("🎉 Repository: Register selesai");
  }

  // ===================================================
  // 🚪 LOGOUT
  // ===================================================
  // Logout elegan, tanpa ribut
  @override
  Future<void> logout() {
    print("");
    print("🚪 ================================");
    print("🚪 Repository LOGOUT dipanggil");
    print("👋 Sampai jumpa user!");
    print("🚪 ================================");
    print("");

    return _service.signOut();
  }
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < REPO >
    < CLEAN >
     /     \

Tips Repository:
- Repository ≠ Service ❌
- Repository = translator domain 🧠
- Firebase jangan bocor ke UI 🚿

print("🧱 AuthRepositoryImpl ready!");
===========================================================
*/
