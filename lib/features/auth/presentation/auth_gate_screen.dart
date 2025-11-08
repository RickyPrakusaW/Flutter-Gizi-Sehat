import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/core/utils/first_time_prefs.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final isFirstTime = await FirstTimePrefs.isFirstTime();
    if (isFirstTime) {
      // Jika pertama kali buka app, arahkan ke onboarding
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.onboarding);
      }
      await FirstTimePrefs.markNotFirstTime();
      return;
    }

    // Jika bukan pertama kali, cek status auth
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.status == AuthStatus.authenticated) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    } else if (auth.status == AuthStatus.unauthenticated) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
