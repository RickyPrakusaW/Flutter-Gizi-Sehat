import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/theme/light_theme.dart';
import 'package:gizi_sehat_mobile_app/theme/dark_theme.dart';
import 'package:gizi_sehat_mobile_app/features/profile/state/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const GiziSehatApp(),
    ),
  );
}

class GiziSehatApp extends StatelessWidget {
  const GiziSehatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'GiziSehat',
      debugShowCheckedModeBanner: false,

      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeProvider.themeMode, // <- dinamis dari provider

      initialRoute: AppRouter.onboarding,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
