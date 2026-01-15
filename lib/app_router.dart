// =======================================================
// 🗺️ APP ROUTER – PETA KEHIDUPAN APLIKASI
// =======================================================
// Kalau user nyasar, jangan salahin GPS ❌
// Salahin route 😌
//
// ASCII MAP:
//        🧑
//        |
//   [ AuthGate 🔐 ]
//        |
//   ┌────┴─────┐
//   |          |
//[Login]   [Register]
//   |          |
//   └────┬─────┘
//        |
//   [Dashboard 🏠]
//
// =======================================================

import 'package:flutter/material.dart';

// ===============================
// 📦 Import Screen
// ===============================
// Tiap screen = satu dunia 🌍
// Salah import = dunia hancur 💥
import 'package:gizi_sehat_mobile_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/login_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/register_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/auth_gate_screen.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/home_screen.dart';

// =======================================================
// 🚦 AppRouter
// =======================================================
// Semua jalan menuju widget ada di sini
// Salah satu typo = nyasar ke onboarding 😆
class AppRouter {

  // ===============================
  // 🏷️ Nama-nama Route
  // ===============================
  // Anggap aja ini nama jalan
  // Konsisten = hidup damai 🧘
  static const String authGate = '/auth-gate'; // 🔐 Gerbang utama
  static const String onboarding = '/onboarding'; // 👋 Sambutan pertama
  static const String login = '/login'; // 🔑 Masuk pakai iman & password
  static const String register = '/register'; // 📝 Daftar jadi warga baru
  static const String dashboard = '/dashboard'; // 🏠 Rumah utama user

  // ===================================================
  // 🧠 onGenerateRoute
  // ===================================================
  // Otak dari sistem navigasi 🧠
  // Flutter: "Mau ke mana bos?" 🤔
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    // 🕵️‍♂️ DEBUG ROUTING
    print("");
    print("🧭 ================================");
    print("🧭 Navigasi diminta ke route:");
    print("🧭 👉 ${settings.name}");
    print("🧭 ================================");
    print("");

    switch (settings.name) {

    // ===============================
    // 🔐 AUTH GATE
    // ===============================
    // Satpam aplikasi 🚓
    // Login dulu baru lewat
      case authGate:
        print("🔐 Masuk AuthGate → cek login user...");
        return MaterialPageRoute(
          builder: (_) => const AuthGateScreen(),
          settings: settings,
        );

    // ===============================
    // 👋 ONBOARDING
    // ===============================
    // User baru, masih polos ✨
      case onboarding:
        print("👋 Ke Onboarding → user baru nih!");
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

    // ===============================
    // 🔑 LOGIN
    // ===============================
    // Tempat mengetik password sambil deg-degan 😰
      case login:
        print("🔑 Ke Login → semoga password benar 🤞");
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

    // ===============================
    // 📝 REGISTER
    // ===============================
    // Daftar akun, gratis*
    // *dibayar dengan bug 🐛
      case register:
        print("📝 Ke Register → user baru lahir 🎉");
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

    // ===============================
    // 🏠 DASHBOARD
    // ===============================
    // Rumah utama, tempat healing 🥗
      case dashboard:
        print("🏠 Ke Dashboard → selamat datang di rumah!");
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

    // ===============================
    // ❓ DEFAULT ROUTE
    // ===============================
    // Kalau route nggak dikenal:
    // "Balik ke onboarding aja ya 😅"
      default:
        print("❓ Route tidak dikenal!");
        print("↩️ Dialihkan ke Onboarding...");
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
    }
  }
}

// =======================================================
// 🎉 END OF ROUTER
// =======================================================
//
// ASCII MOTIVATION:
//
//   (⌐■_■)
//    <) )╯  DEBUG
//    / \
//
// Tips hidup sebagai Flutter Dev:
// - Jangan hardcode route ❌
// - Selalu pakai AppRouter ✅
// - print() itu teman, bukan musuh 🫂
// - Tapi di production… hapus 😈
//
// print("Happy navigating! 🚦🚀");
// =======================================================
