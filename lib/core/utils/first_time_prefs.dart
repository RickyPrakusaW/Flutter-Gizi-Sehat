import 'package:shared_preferences/shared_preferences.dart';

// =======================================================
// 🧠 FIRST TIME PREFS – PENJAGA INGATAN APLIKASI
// =======================================================
// Dia nggak pelupa,
// dia cuma nyimpen satu hal penting:
// "Ini user baru apa bukan?" 🤔
//
// ASCII MEMORY:
//
//    🧠
//   (•_•)
//   <) )╯  REMEMBER
//   / \
//
// =======================================================

class FirstTimePrefs {
  // 🔑 Key sakti di SharedPreferences
  // Jangan ganti sembarangan, nanti user “lahir kembali” 😱
  static const String _key = 'first_time_user';

  // ===================================================
  // 👶 Check First Time User
  // ===================================================
  // true  → user baru, tampilkan onboarding ✨
  // false → user lama, langsung gas 🚀
  static Future<bool> isFirstTime() async {
    print("");
    print("🧠 ================================");
    print("🧠 Cek: apakah ini first time user?");
    print("🧠 ================================");
    print("");

    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool(_key) ?? true;

    print("👶 First time user: $isFirst");
    return isFirst;
  }

  // ===================================================
  // 🏁 Tandai Bukan First Time
  // ===================================================
  // Dipanggil setelah onboarding selesai
  // Sekali aja, jangan PHP 😌
  static Future<void> markNotFirstTime() async {
    print("");
    print("🏁 ================================");
    print("🏁 Menandai user sebagai BUKAN user baru");
    print("🏁 Onboarding tidak akan muncul lagi");
    print("🏁 ================================");
    print("");

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);

    print("✅ Status first time berhasil disimpan");
  }
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < PREFS >
    < MEMORY >
     /     \

Tips SharedPreferences:
- Jangan simpan data sensitif ❌
- Cocok buat flag & setting kecil ✅
- Kalau data hilang → uninstall itu reset 😅

print("🧠 FirstTimePrefs ready!");
===========================================================
*/
