/// Tambah auth-gate ke route names
/// Konstanta nama-nama route untuk navigasi yang aman
/// Menghindari typo dalam navigasi antar halaman
abstract class RouteNames {
  // Auth Routes
  static const String authGate = 'auth-gate';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';

  // Main Routes
  static const String home = 'home';
  static const String growth = 'growth';
  static const String nutrition = 'nutrition';
  static const String assistant = 'assistant';
  static const String profile = 'profile';
  static const String healthServices = 'health-services';
}

/// Konstanta path route untuk navigasi
abstract class RoutePaths {
  // Auth Paths
  static const String authGate = '/auth-gate';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // Main Paths
  static const String home = '/';
  static const String growth = '/growth';
  static const String nutrition = '/nutrition';
  static const String assistant = '/assistant';
  static const String profile = '/profile';
  static const String healthServices = '/health-services';
}
