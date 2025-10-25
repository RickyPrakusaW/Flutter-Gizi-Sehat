import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/firebase_options.dart';
import 'app_router.dart';

import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

import 'features/profile/state/theme_provider.dart';
import 'features/auth/state/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
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
      themeMode: themeProvider.themeMode,

      // Penting: kita nggak langsung ke login/onboarding.
      // Kita masuk ke AuthGate dulu buat cek udah login apa belum.
      initialRoute: AppRouter.authGate,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
