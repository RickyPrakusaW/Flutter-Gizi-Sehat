// =======================================================
// 👤 AUTH USER DATA & REPOSITORY
// =======================================================
// Ini bukan cuma class,
// ini kontrak suci antara UI dan Auth layer 🧾
//
// ASCII ARCHITECTURE:
//
//   UI 🖥️
//    |
//    v
//  REPO 🧠
//    |
//    v
// FIREBASE 🔥
//
// =======================================================

class AuthUserData {
  // 🆔 ID unik dari Firebase
  // Identitas digital, bukan NIK 😌
  final String uid;

  // 📧 Email user (boleh null, jangan baper)
  final String? email;

  // Constructor sederhana & jujur
  const AuthUserData({
    required this.uid,
    required this.email,
  });

  @override
  String toString() {
    // Debug helper ala manusia
    print("");
    print("👤 ================================");
    print("👤 AuthUserData dibuat");
    print("🆔 UID   : $uid");
    print("📧 Email : $email");
    print("👤 ================================");
    print("");

    return 'AuthUserData(uid: $uid, email: $email)';
  }
}

// =======================================================
// 🧠 AUTH REPOSITORY (CONTRACT)
// =======================================================
// Ini janji suci:
// - Mau pakai Firebase? boleh 🔥
// - Mau pakai mock? silakan 🧪
// UI tidak perlu tahu isinya 😎
abstract class AuthRepository {

  // ===================================================
  // 👀 Watch Auth State
  // ===================================================
  // Dipantau seumur hidup aplikasi
  // Login → Logout → Login → Kopi ☕
  Stream<AuthUserData?> watchAuthState();

  // ===================================================
  // 🔑 LOGIN
  // ===================================================
  // Jangan lupa:
  // email benar + password benar = bahagia
  Future<void> login(String email, String password);

  // ===================================================
  // 📝 REGISTER
  // ===================================================
  // User baru lahir ke dunia digital 🎉
  Future<void> register(String email, String password);

  // ===================================================
  // 🚪 LOGOUT
  // ===================================================
  // Keluar dengan elegan, tanpa drama
  Future<void> logout();
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < CLEAN >
    < ARCH >
     /     \

Tips Arsitektur:
- Repository = kontrak, bukan implementasi ❌
- UI jangan tahu Firebase langsung 🧼
- Kalau mau test → tinggal mock 😎

print("🧠 Auth domain layer ready!");
===========================================================
*/
