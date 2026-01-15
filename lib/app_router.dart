import 'package:flutter/material.dart';

import 'package:gizi_sehat_mobile_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/login_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/register_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/auth_gate_screen.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/home_screen.dart';

class AppRouter {
  static const String authGate = '/auth-gate';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authGate:
        return MaterialPageRoute(
          builder: (_) => const AuthGateScreen(),
          settings: settings,
        );

      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
    }
  }
}
