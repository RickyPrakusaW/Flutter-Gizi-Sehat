import 'dart:async';

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

class _AuthGateScreenState extends State<AuthGateScreen>
    with SingleTickerProviderStateMixin {
  // Animasi controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  // Status untuk animasi bertahap
  double _logoOpacity = 0.0;
  double _textOpacity = 0.0;
  double _loadingOpacity = 0.0;

  // Status pengecekan
  bool _isChecking = true;
  String _statusMessage = 'Memulai aplikasi...';

  @override
  void initState() {
    super.initState();

    // Setup animation controller dengan duration 1200ms
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Setup berbagai jenis animasi
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF4CAF50),
      end: const Color(0xFF2196F3),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Memulai animasi bertahap
    _startStaggeredAnimations();

    // Memulai proses pengecekan
    _checkAuthStatus();
  }

  void _startStaggeredAnimations() async {
    // Delay untuk animasi logo
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _logoOpacity = 1.0);

    // Delay untuk animasi teks
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _textOpacity = 1.0);

    // Delay untuk animasi loading
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _loadingOpacity = 1.0);

    // Memulai animation controller
    _animationController.forward();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Pengecekan first time
      setState(() => _statusMessage = 'Memeriksa pengaturan...');
      final isFirstTime = await FirstTimePrefs.isFirstTime();

      if (isFirstTime && mounted) {
        setState(() => _statusMessage = 'Menyiapkan pengalaman pertama...');
        await Future.delayed(const Duration(milliseconds: 500));
        await FirstTimePrefs.markNotFirstTime();

        // Navigasi ke onboarding dengan animasi
        _navigateWithAnimation(AppRouter.onboarding);
        return;
      }

      // Pengecekan status auth
      setState(() => _statusMessage = 'Memeriksa status autentikasi...');
      await Future.delayed(const Duration(milliseconds: 500));

      final auth = Provider.of<AuthProvider>(context, listen: false);

      // Simulasi pengecekan status
      await Future.delayed(const Duration(milliseconds: 800));

      if (auth.status == AuthStatus.authenticated) {
        setState(() => _statusMessage = 'Login berhasil! Mengarahkan...');
        await Future.delayed(const Duration(milliseconds: 500));

        // Navigasi ke dashboard dengan animasi
        _navigateWithAnimation(AppRouter.dashboard);
      } else if (auth.status == AuthStatus.unauthenticated) {
        setState(() => _statusMessage = 'Mengarahkan ke halaman login...');
        await Future.delayed(const Duration(milliseconds: 500));

        // Navigasi ke login dengan animasi
        _navigateWithAnimation(AppRouter.login);
      } else {
        // Status checking atau unknown
        setState(() => _statusMessage = 'Mengarahkan ke halaman login...');
        await Future.delayed(const Duration(milliseconds: 500));

        // Default ke login
        _navigateWithAnimation(AppRouter.login);
      }

    } catch (error) {
      // Error handling dengan snackbar
      if (mounted) {
        _showErrorSnackBar('Terjadi kesalahan: ${error.toString()}');

        // Fallback ke login screen setelah error
        await Future.delayed(const Duration(seconds: 2));
        _navigateWithAnimation(AppRouter.login);
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  void _navigateWithAnimation(String routeName) async {
    // Animasi sebelum navigasi
    await _animationController.reverse();

    if (mounted) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 350;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2196F3),
              const Color(0xFF4CAF50),
              const Color(0xFF9C27B0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              children: [
                // Background pattern atau efek
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/pattern.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.2),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Konten utama
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo dengan animasi scale dan fade
                        AnimatedOpacity(
                          opacity: _logoOpacity,
                          duration: const Duration(milliseconds: 800),
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: isSmallScreen ? 80.0 : 100.0,
                              height: isSmallScreen ? 80.0 : 100.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.health_and_safety,
                                size: isSmallScreen ? 40.0 : 50.0,
                                color: _colorAnimation.value,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Teks judul dengan animasi slide
                        AnimatedOpacity(
                          opacity: _textOpacity,
                          duration: const Duration(milliseconds: 800),
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              children: [
                                Text(
                                  'GiziSehat',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 28.0 : 36.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Asisten Gizi Keluarga',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14.0 : 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Loading indicator dengan animasi
                        AnimatedOpacity(
                          opacity: _loadingOpacity,
                          duration: const Duration(milliseconds: 800),
                          child: Column(
                            children: [
                              RotationTransition(
                                turns: _rotationAnimation,
                                child: Container(
                                  width: isSmallScreen ? 40.0 : 50.0,
                                  height: isSmallScreen ? 40.0 : 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Status message
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _statusMessage,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12.0 : 14.0,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 8),

                                    // Progress dots
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(3, (index) {
                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              _animationController.value > (index + 1) * 0.25 ? 1.0 : 0.3,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Versi atau informasi tambahan
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Versi 1.0.0',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10.0 : 12.0,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tombol skip (opsional, untuk debugging)
                if (_isChecking && !_animationController.isAnimating)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    right: 16,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          // Haptic feedback
                          Feedback.forTap(context);
                          _navigateWithAnimation(AppRouter.login);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                        child: const Text(
                          'Lewati',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}