// ===============================
// 🚀 GiziSehat App
// ===============================
// Motto hidup:
// "Kalau bisa clean code, kenapa harus clean hati?" 💔😂
//
// ASCII ART:
//        _________
//       |  FLUTTER |
//       |  APP 🚀  |
//       |__________|
//          ||
//       ☕ ||  🐛  <- bug yang ikut ngopi
//          ||
//
// ===============================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🧠 State management biar nggak stres
import 'package:firebase_core/firebase_core.dart'; // 🔥 Firebase siap bakar bug
import 'package:shared_preferences/shared_preferences.dart'; // 💾 Ingatan app (lebih kuat dari mantan)

import 'config/firebase_options.dart';
import 'app_router.dart';

import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'features/profile/state/theme_provider.dart';
import 'features/auth/state/auth_provider.dart';

Future<void> main() async {
  // ⛔ Wajib! Kalau nggak, Flutter bisa ngambek
  WidgetsFlutterBinding.ensureInitialized();

  // ===============================
  // 🔥 Firebase Initialization
  // ===============================
  // Doa sebelum init:
  // "Semoga tidak error, amin" 🙏😂
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ===============================
  // 💾 SharedPreferences
  // ===============================
  // Biar data kecil nggak hilang
  // Kayak kenangan... tapi versi aman 😌
  await SharedPreferences.getInstance();

  // ===============================
  // 🚀 Jalankan Aplikasi
  // ===============================
  runApp(
    MultiProvider(
      providers: [
        // 🎨 Ngurus tema: light / dark / sesuai mood developer
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // 🔐 Ngurus login, logout, dan kegalauan auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const GiziSehatApp(),
    ),
  );
}

// ===============================
// 🥗 GiziSehatApp
// ===============================
// App utama, induk semesta 🌌
// Semua widget berasal dari sini
class GiziSehatApp extends StatelessWidget {
  const GiziSehatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 👀 Mantau theme provider
    // Kayak mantau status doi... sering tapi penting 😆
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'GiziSehat',

      // 🚫 Hilangkan banner DEBUG biar kelihatan profesional
      // Padahal bug masih di mana-mana 😜
      debugShowCheckedModeBanner: false,

      // ☀️ Tema terang (buat yang optimis)
      theme: buildLightTheme(),

      // 🌙 Tema gelap (buat programmer malam hari)
      darkTheme: buildDarkTheme(),

      // 🎚️ Mode tema mengikuti pilihan user
      themeMode: themeProvider.themeMode,

      // ===============================
      // 🔐 Routing & Auth
      // ===============================
      // ❗ Tidak langsung ke login / onboarding
      // Kita cek dulu:
      // "User sudah login belum, bro?" 🤔
      initialRoute: AppRouter.authGate,

      // 🗺️ Semua jalan ada di AppRouter
      // Salah route = nyasar = error 😅
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

// ===============================
// 🎉 END OF FILE
// ===============================
// Jika code ini error:
// 1. Tarik napas 😮‍💨
// 2. Cek log 🔍
// 3. Ngopi ☕
// 4. Ulangi lagi 💪
//
// Happy coding! 🚀😄
