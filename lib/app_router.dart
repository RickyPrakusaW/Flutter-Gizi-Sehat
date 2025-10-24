import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/login_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/register_screen.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/home_screen.dart';

class AppRouter {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
      // fallback kalau route gak dikenal
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    }
  }
}
