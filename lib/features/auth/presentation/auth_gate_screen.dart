import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/core/utils/first_time_prefs.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

/// Screen pertama yang muncul saat aplikasi dibuka
/// Memeriksa status autentikasi dan first-time user untuk menentukan navigasi awal
class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  /// Status apakah sedang melakukan pengecekan
  bool _isChecking = true;
  /// Pesan status yang ditampilkan kepada user
  String _statusMessage = 'Memulai aplikasi...';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Memeriksa apakah user pertama kali menggunakan app
  /// Jika ya -> Onboarding, jika sudah login -> Dashboard, jika belum -> Login
  Future<void> _checkAuthStatus() async {
    try {
      setState(() => _statusMessage = 'Memeriksa pengaturan...');
      final isFirstTime = await FirstTimePrefs.isFirstTime();

      // Jika user pertama kali, tampilkan onboarding
      if (isFirstTime && mounted) {
        setState(() => _statusMessage = 'Menyiapkan pengalaman pertama...');
        await Future.delayed(const Duration(milliseconds: 800));
        await FirstTimePrefs.markNotFirstTime();

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.onboarding);
        }
        return;
      }

      // Cek status autentikasi user
      setState(() => _statusMessage = 'Memeriksa status autentikasi...');
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      final auth = Provider.of<AuthProvider>(context, listen: false);

      // Jika sudah login, arahkan ke dashboard
      if (auth.status == AuthStatus.authenticated) {
        setState(() => _statusMessage = 'Login berhasil! Mengarahkan...');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        }
      } else {
        // Jika belum login, arahkan ke halaman login
        setState(() => _statusMessage = 'Mengarahkan ke halaman login...');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.login);
        }
      }
    } catch (error) {
      // Jika terjadi error, tampilkan snackbar dan arahkan ke login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${error.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.login);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'GiziSehat',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Asisten Gizi Keluarga',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
              const SizedBox(height: 24),
              Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
