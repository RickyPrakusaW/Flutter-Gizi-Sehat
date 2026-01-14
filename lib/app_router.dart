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
  // Harus konsisten, jangan PHP ❌
  static const String authGate = '/auth-gate'; // 🔐 Gerbang utama
  static const String onboarding = '/onboarding'; // 👋 Sambutan pertama
  static const String login = '/login'; // 🔑 Masuk pakai iman & password
  static const String register = '/register'; // 📝 Daftar jadi warga baru
  static const String dashboard = '/dashboard'; // 🏠 Rumah utama user

  // ===================================================
  // 🧠 onGenerateRoute
  // ===================================================
  // Otak dari sistem navigasi 🧠
  // Flutter tanya:
  // "Eh, mau ke mana?" 🤔
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    // 👀 Debug mental:
    // print('Navigasi ke: ${settings.name}');
    switch (settings.name) {

    // ===============================
    // 🔐 AUTH GATE
    // ===============================
    // Cek login dulu, jangan asal masuk 😤
      case authGate:
        return MaterialPageRoute(
          builder: (_) => const AuthGateScreen(),
          settings: settings,
        );

    // ===============================
    // 👋 ONBOARDING
    // ===============================
    // Halo user baru ✨
    // Janji hidup sehat (tapi besok) 😂
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

    // ===============================
    // 🔑 LOGIN
    // ===============================
    // Masuk dengan username & password
    // Salah dikit? Ulang dari awal 😈
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

    // ===============================
    // 📝 REGISTER
    // ===============================
    // Daftar dulu, gratis kok (bug-nya mahal)
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

    // ===============================
    // 🏠 DASHBOARD
    // ===============================
    // Selamat datang di rumah 🥗
    // Di sinilah user betah
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

    // ===============================
    // ❓ DEFAULT ROUTE
    // ===============================
    // Kalau route nggak dikenal:
    // "Yaudah balik ke onboarding aja" 😅
      default:
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
// Tips hidup:
// - Jangan hardcode string route di mana-mana ❌
// - Pakai AppRouter biar hidup tenang 🧘
// - Kalau error, baca stacktrace dulu 😇
//
// Happy navigating! 🚦🚀
