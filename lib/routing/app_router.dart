/// Update routing dengan proper AuthGate dan auth state handling dari Riverpod
/// Konfigurasi routing aplikasi GiziSehat menggunakan go_router
/// Mengelola navigasi antar halaman dan state routing dengan auth protection
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../features/auth/presentation/auth_gate_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/dashboard/presentation/main_screen.dart';
import '../features/growth/presentation/growth_screen.dart';
import '../features/nutrition/presentation/nutrition_screen.dart';
import '../features/assistant/presentation/assistant_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/health_services/presentation/health_services_screen.dart';
import '../presentation/error_screen.dart';

/// Provider untuk GoRouter dengan proper auth redirect logic
final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateAsync = ref.watch(authStateStreamProvider);

  return GoRouter(
    initialLocation: '/auth-gate',
    debugLogDiagnostics: false,
    
    redirect: (BuildContext context, GoRouterState state) {
      final isGoingToAuthGate = state.matchedLocation == '/auth-gate';
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';
      
      // Handle loading state - stay on current page
      if (authStateAsync.isLoading && !isGoingToAuthGate) {
        return null;
      }

      // When data is loaded, check auth state
      final user = authStateAsync.whenData((data) => data).asData?.value;
      final isAuthenticated = user != null;

      // If user is authenticated and trying to access auth pages, redirect to home
      if (isAuthenticated && (isGoingToLogin || isGoingToRegister)) {
        return '/';
      }

      // If user is not authenticated and not on auth pages, redirect to auth gate
      if (!isAuthenticated && 
          !isGoingToAuthGate && 
          !isGoingToLogin && 
          !isGoingToRegister && 
          !isGoingToOnboarding) {
        return '/auth-gate';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/auth-gate',
        name: 'auth-gate',
        builder: (context, state) => const AuthGateScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Dashboard/Home Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainScreen(),
        routes: [
          // Growth Tracking
          GoRoute(
            path: 'growth',
            name: 'growth',
            builder: (context, state) => const GrowthScreen(),
          ),

          // Nutrition & Menu
          GoRoute(
            path: 'nutrition',
            name: 'nutrition',
            builder: (context, state) => const NutritionScreen(),
          ),

          // AI Assistant
          GoRoute(
            path: 'assistant',
            name: 'assistant',
            builder: (context, state) => const AssistantScreen(),
          ),

          // Profile
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // Health Services
          GoRoute(
            path: 'health-services',
            name: 'health-services',
            builder: (context, state) => const HealthServicesScreen(),
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});
