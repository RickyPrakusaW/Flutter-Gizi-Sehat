/// Update app.dart untuk initialize Supabase di ProviderScope
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../routing/app_router.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

/// Widget utama aplikasi GiziSehat
/// Mengatur tema, routing, dan konfigurasi global aplikasi
class GiziSehatApp extends ConsumerWidget {
  const GiziSehatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'GiziSehat',
      debugShowCheckedModeBanner: false,
      
      // Tema sesuai dengan Material 3 design system
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Router menggunakan go_router dengan auth redirect
      routerConfig: appRouter,
      
      // Lokalisasi aplikasi (siap untuk expand ke bahasa lain)
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
      ],
    );
  }
}
