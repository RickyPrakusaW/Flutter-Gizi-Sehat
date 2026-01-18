import 'package:flutter/material.dart';

import 'package:gizi_sehat_mobile_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/login_screen.dart';

import 'package:gizi_sehat_mobile_app/features/auth/presentation/role_selection_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/register_parent_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/register_doctor_screen.dart';
import 'package:gizi_sehat_mobile_app/features/auth/presentation/auth_gate_screen.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/home_screen.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/screens/nutrition_schedule_screen.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/screens/food_scanner_screen.dart';
import 'package:gizi_sehat_mobile_app/features/consultation/screens/doctor_list_screen.dart';
import 'package:gizi_sehat_mobile_app/features/consultation/screens/chat_screen.dart';
import 'package:gizi_sehat_mobile_app/features/marketplace/screens/marketplace_screen.dart';
import 'package:gizi_sehat_mobile_app/features/marketplace/screens/cart_screen.dart';
import 'package:gizi_sehat_mobile_app/features/marketplace/screens/invoice_screen.dart';
import 'package:gizi_sehat_mobile_app/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:gizi_sehat_mobile_app/features/doctor_dashboard/presentation/doctor_dashboard_screen.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/profile_page.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/screens/growth_input_screen.dart';
import 'package:gizi_sehat_mobile_app/features/nutrition/screens/growth_result_screen.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/data/models/child_model.dart'; // Dashboard ChildModel
import 'package:gizi_sehat_mobile_app/features/nutrition/models/child_model.dart'; // GrowthRecord only

class AppRouter {
  static const String authGate = '/auth-gate';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register'; // Now Role Selection
  static const String registerParent = '/register-parent';
  static const String registerDoctor = '/register-doctor';
  static const String dashboard = '/dashboard';
  static const String nutritionSchedule = '/nutrition-schedule';
  static const String foodScanner = '/food-scanner';
  static const String doctorList = '/doctor-list';
  static const String chat = '/chat';
  static const String marketplace = '/marketplace';
  static const String cart = '/cart';
  static const String invoice = '/invoice';
  static const String adminDashboard = '/admin-dashboard';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String profile = '/profile';
  static const String growthInput = '/growth-input';
  static const String growthResult = '/growth-result';

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
          builder: (_) => const RoleSelectionScreen(),
          settings: settings,
        );

      case registerParent:
        return MaterialPageRoute(
          builder: (_) => const RegisterParentScreen(),
          settings: settings,
        );

      case registerDoctor:
        return MaterialPageRoute(
          builder: (_) => const RegisterDoctorScreen(),
          settings: settings,
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case nutritionSchedule:
        return MaterialPageRoute(
          builder: (_) => const NutritionScheduleScreen(),
          settings: settings,
        );

      case foodScanner:
        return MaterialPageRoute(
          builder: (_) => const FoodScannerScreen(),
          settings: settings,
        );

      case doctorList:
        return MaterialPageRoute(
          builder: (_) => const DoctorListScreen(),
          settings: settings,
        );

      case chat:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
          settings: settings,
        );

      case marketplace:
        return MaterialPageRoute(
          builder: (_) => const MarketplaceScreen(),
          settings: settings,
        );

      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );

      case invoice:
        return MaterialPageRoute(
          builder: (_) => const InvoiceScreen(),
          settings: settings,
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
          settings: settings,
        );

      case doctorDashboard:
        return MaterialPageRoute(
          builder: (_) => const DoctorDashboardScreen(),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );

      case growthInput:
        final args = settings.arguments as Map<String, dynamic>?;
        final child = args != null ? args['child'] as ChildModel? : null;

        return MaterialPageRoute(
          builder: (_) => GrowthInputScreen(child: child),
          settings: settings,
        );

      case growthResult:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => GrowthResultScreen(
            child: args['child'] as ChildModel,
            record: args['record'] as GrowthRecord,
          ),
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
