import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/screens/onboarding_screen.dart';
import 'package:gizi_sehat_mobile_app/screens/login_screen.dart';
import 'package:gizi_sehat_mobile_app/screens/register_screen.dart';
import 'package:gizi_sehat_mobile_app/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GiziSehatApp());
}

class GiziSehatApp extends StatelessWidget {
  const GiziSehatApp({super.key});

  // Palet warna utama aplikasi
  static const Color kAccent = Color(0xFF5DB075);
  static const Color kBg = Color(0xFFFCFBF4);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: kAccent);

    return MaterialApp(
      title: 'GiziSehat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: kBg,

        // AppBar minimalis
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
          centerTitle: true,
        ),

        // Tombol utama (rounded)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        // TextField rounded konsisten
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kAccent, width: 1.4),
          ),
        ),

        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          elevation: 2,
        ),
      ),

      // Start dari Onboarding
      initialRoute: '/',
      routes: {
        '/': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },

      // Fallback kalau ada route tak dikenal
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }
}
