import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ===============================
// 🔥 Import sakti mandraguna 🔥
// ===============================
import 'config/firebase_options.dart';
import 'app_router.dart';

// 🎨 Tema terang & gelap (biar nggak silau tengah malam)
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

// 🧠 State management zone
import 'features/profile/state/theme_provider.dart';
import 'features/auth/state/auth_provider.dart';

Future<void> main() async {
  // 🛑 Wajib hukumnya sebelum async di main
  WidgetsFlutterBinding.ensureInitialized();

  print("🚀 Aplikasi GiziSehat sedang bangun tidur...");
  print("☕ Seduh kopi dulu, inisialisasi dimulai...");

  // =====================================
  // 🔥 FIREBASE INITIALIZATION 🔥
  // =====================================
  /*
      ASCII ART TIME 😎

        ( ͡° ͜ʖ ͡°)
         |  FIREBASE
        /|\
        / \
  */
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("✅ Firebase berhasil diinisialisasi 🎉");

  // =====================================
  // 💾 SharedPreferences check
  // =====================================
  await SharedPreferences.getInstance();
  print("🧠 SharedPreferences siap digunakan!");

  // =====================================
  // 🚀 Launch the App
  // =====================================
  print("🏃‍♂️ runApp() dipanggil... GASSS!");

  runApp(
    MultiProvider(
      providers: [
        // 🌗 Provider untuk tema (dark / light)
        ChangeNotifierProvider(create: (_) {
          print("🎨 ThemeProvider aktif!");
          return ThemeProvider();
        }),

        // 🔐 Provider untuk autentikasi
        ChangeNotifierProvider(create: (_) {
          print("🔑 AuthProvider aktif!");
          return AuthProvider();
        }),
      ],
      child: const GiziSehatApp(),
    ),
  );
}

// =====================================
// 🌱 ROOT APPLICATION WIDGET
// =====================================
class GiziSehatApp extends StatelessWidget {
  const GiziSehatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 👀 Pantau perubahan theme (kayak CCTV tapi halal)
    final themeProvider = context.watch<ThemeProvider>();

    print("🎭 ThemeMode saat ini: ${themeProvider.themeMode}");

    return MaterialApp(
      title: 'GiziSehat 🥗',
      debugShowCheckedModeBanner: false, // ❌ Hilangkan banner DEBUG (biar kelihatan pro 😎)

      // 🌞 Mode terang buat siang hari
      theme: buildLightTheme(),

      // 🌚 Mode gelap buat programmer begadang
      darkTheme: buildDarkTheme(),

      // 🎛️ Mode tema berdasarkan pilihan user
      themeMode: themeProvider.themeMode,

      /*
        🧭 Routing Zone
        Kenapa pakai AuthGate?
        Karena hidup itu penuh validasi,
        termasuk validasi login 💔➡️❤️
      */

      initialRoute: AppRouter.authGate,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

/*
==================================================
🎉 SELAMAT!
Kalau kamu baca sampai sini, berarti:
- Kamu programmer sejati 💻
- Tidak takut async 😤
- Siap debug jam 2 pagi 🌙

BUG itu bukan musuh,
BUG itu teman yang terlalu jujur 🐛

print("Semangat ngoding! 💪🔥");
==================================================
*/
