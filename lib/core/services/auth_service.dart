import 'package:firebase_auth/firebase_auth.dart';

// =======================================================
// 🔐 AUTH SERVICE – PENJAGA GERBANG KEHIDUPAN USER
// =======================================================
// Kalau login gagal,
// jangan salahin Firebase ❌
// Cek email & password dulu 😌
//
// ASCII SECURITY:
//
//   ┌───────────────┐
//   │   🔐 AUTH     │
//   │  (•_•)        │
//   │  <) )╯        │
//   │  / \          │
//   └───────────────┘
//
// =======================================================

class AuthService {
  // 🔥 Instance FirebaseAuth
  // Satu instance untuk menguasai segalanya
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===================================================
  // 👤 Current User
  // ===================================================
  // Null = belum login
  // Ada isinya = selamat 🎉
  User? get currentUser {
    print("👤 currentUser dicek");
    return _auth.currentUser;
  }

  // ===================================================
  // 🔄 Auth State Changes
  // ===================================================
  // Listener kehidupan:
  // login ➡️ logout ➡️ login lagi ➡️ kopi ☕
  Stream<User?> authStateChanges() {
    print("🔄 authStateChanges() mulai dipantau...");
    return _auth.authStateChanges();
  }

  // ===================================================
  // 🔑 LOGIN DENGAN EMAIL
  // ===================================================
  // Tempat deg-degan dimulai 😰
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    print("");
    print("🔑 ================================");
    print("🔑 Proses LOGIN dimulai");
    print("📧 Email: $email");
    print("🔑 Password: *** (rahasia negara)");
    print("🔑 ================================");
    print("");

    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("✅ Login berhasil! Selamat datang 🎉");
  }

  // ===================================================
  // 📝 REGISTER DENGAN EMAIL
  // ===================================================
  // User baru lahir ke dunia digital 🌱
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    print("");
    print("📝 ================================");
    print("📝 Proses REGISTER dimulai");
    print("📧 Email: $email");
    print("🔑 Password: *** (tetap rahasia)");
    print("📝 ================================");
    print("");

    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("🎉 Register sukses! Akun berhasil dibuat");
  }

  // ===================================================
  // 🚪 SIGN OUT
  // ===================================================
  // Logout bukan perpisahan,
  // cuma break sebentar 😌
  Future<void> signOut() async {
    print("");
    print("🚪 ================================");
    print("🚪 User melakukan SIGN OUT");
    print("👋 Sampai jumpa lagi!");
    print("🚪 ================================");
    print("");

    await _auth.signOut();

    print("✅ Logout berhasil");
  }
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < AUTH >
    < FIREBASE >
     /     \

Tips Auth:
- Error login? cek email/password dulu ❌
- Jangan print password asli ⚠️
- Auth error itu biasa, panik itu optional 😆

print("🔐 AuthService ready!");
===========================================================
*/
