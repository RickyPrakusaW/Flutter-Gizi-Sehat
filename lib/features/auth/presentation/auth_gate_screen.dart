import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // status unknown = masih nunggu Firebase
    if (auth.status == AuthStatus.unknown) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.status == AuthStatus.authenticated) {
      // sudah login -> langsung ke dashboard
      Future.microtask(() {
        Navigator.pushReplacementNamed(
          context,
          AppRouter.dashboard,
        );
      });
    } else if (auth.status == AuthStatus.unauthenticated) {
      // belum login -> ke login
      Future.microtask(() {
        Navigator.pushReplacementNamed(
          context,
          AppRouter.login,
        );
      });
    }

    // sementara: blank widget supaya nggak ngedraw dua kali
    return const SizedBox.shrink();
  }
}
