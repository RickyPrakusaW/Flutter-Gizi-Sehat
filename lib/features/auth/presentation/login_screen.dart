import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  // Animasi controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _buttonColorAnimation;
  late Animation<double> _logoScaleAnimation;

  // Validasi real-time
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  // Untuk animasi forgot password
  bool _showForgotPassword = false;

  @override
  void initState() {
    super.initState();

    // Setup animasi controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animasi fade untuk seluruh screen
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animasi slide untuk form fields
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Animasi scale untuk tombol
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Animasi warna tombol
    _buttonColorAnimation = ColorTween(
      begin: Colors.grey[400],
      end: const Color(0xFF2196F3),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animasi scale untuk logo
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animasi dengan delay bertahap
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });

    // Setup real-time validation listeners
    _setupValidationListeners();

    // Delay untuk menampilkan forgot password
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _showForgotPassword = true;
      });
    });
  }

  void _setupValidationListeners() {
    _emailCtrl.addListener(() {
      setState(() {
        _isEmailValid = _validateEmail(_emailCtrl.text) == null;
      });
    });

    _passCtrl.addListener(() {
      setState(() {
        _isPasswordValid = _validatePassword(_passCtrl.text) == null;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      // Animasi shake jika validasi gagal
      _playErrorAnimation();
      return;
    }

    final auth = context.read<AuthProvider>();

    final ok = await auth.login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      // Feedback sukses dengan animasi
      await _showSuccessAnimation(context);

      // Navigasi ke dashboard dengan animasi
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else {
      final msg = auth.errorMessage ?? 'Login gagal. Periksa email dan password Anda.';
      _showErrorSnackBar(context, msg);
    }
  }

  void _playErrorAnimation() async {
    await _animationController.forward();
    await _animationController.reverse();
    await _animationController.forward();
  }

  Future<void> _showSuccessAnimation(BuildContext context) async {
    // Overlay dengan animasi sukses
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Login Berhasil!',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: 1500));
    overlayEntry.remove();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        animation: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  // Validators dengan pesan error yang informatif
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '📧 Email tidak boleh kosong!';
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(value)) {
      return '📧 Format email tidak valid!';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '🔒 Password harus diisi!';
    }

    if (value.length < 8) {
      return '🔒 Password minimal 8 karakter!';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Warna dinamis berdasarkan tema
    final primaryColor = colorScheme.primary;
    final backgroundColor = isDark
        ? const Color(0xFF0F1525)
        : const Color(0xFFF0F7FF);
    final surfaceColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF333333);
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    // Gradient background
    final gradientColors = isDark
        ? [
      const Color(0xFF0F1525),
      const Color(0xFF1A237E),
      const Color(0xFF311B92),
    ]
        : [
      const Color(0xFFE3F2FD),
      const Color(0xFFF0F7FF),
      const Color(0xFFE8F5E9),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button (opsional untuk login screen)
                  _buildBackButton(context, theme, primaryColor),
                  const SizedBox(height: 20),

                  // Logo dan brand dengan animasi
                  _buildLogoSection(theme, primaryColor, textColor),
                  const SizedBox(height: 40),

                  // Form login dengan animasi slide
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildLoginForm(
                      context,
                      auth,
                      theme,
                      surfaceColor,
                      textColor,
                      hintColor,
                      primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol login dengan animasi
                  _buildLoginButton(auth, theme, primaryColor),
                  const SizedBox(height: 32),

                  // Fitur forgot password dengan animasi fade
                  _buildForgotPasswordSection(context, theme, primaryColor),
                  const SizedBox(height: 24),

                  // Link ke register dengan animasi
                  _buildRegisterLink(context, theme, primaryColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, ThemeData theme, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: primaryColor,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildLogoSection(ThemeData theme, Color primaryColor, Color textColor) {
    return ScaleTransition(
      scale: _logoScaleAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.9),
                      primaryColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang Kembali! 👋',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aplikasi GiziSehat',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Masuk ke akun Anda untuk mengakses panduan gizi, rekomendasi menu, dan fitur kesehatan keluarga lainnya.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: textColor.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(
      BuildContext context,
      AuthProvider auth,
      ThemeData theme,
      Color surfaceColor,
      Color textColor,
      Color hintColor,
      Color primaryColor,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Field email
            _buildEmailField(theme, textColor, hintColor, primaryColor),
            const SizedBox(height: 20),

            // Field password
            _buildPasswordField(theme, textColor, hintColor, primaryColor),
            const SizedBox(height: 8),

            // Password strength indicator (jika ada input)
            if (_passCtrl.text.isNotEmpty)
              _buildPasswordStrengthIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(
      ThemeData theme,
      Color textColor,
      Color hintColor,
      Color primaryColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.email_outlined, size: 16),
            const SizedBox(width: 8),
            Text(
              '📧 Alamat Email',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: 'nama@email.com',
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: Icon(Icons.email_outlined, color: hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: hintColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: hintColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            filled: true,
            fillColor: primaryColor.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            suffixIcon: _isEmailValid && _emailCtrl.text.isNotEmpty
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
          ),
          validator: _validateEmail,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      ThemeData theme,
      Color textColor,
      Color hintColor,
      Color primaryColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lock_outline, size: 16),
            const SizedBox(width: 8),
            Text(
              '🔒 Password',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passCtrl,
          obscureText: _obscure,
          textInputAction: TextInputAction.done,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          onFieldSubmitted: (_) => _onSubmit(),
          decoration: InputDecoration(
            hintText: 'Masukkan password Anda',
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: Icon(Icons.lock_outline, color: hintColor),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isPasswordValid && _passCtrl.text.isNotEmpty)
                  Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() => _obscure = !_obscure);
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: hintColor,
                      key: ValueKey<bool>(_obscure),
                    ),
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: hintColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: hintColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            filled: true,
            fillColor: primaryColor.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
          validator: _validatePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _passCtrl.text;
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    Color getColor() {
      if (password.isEmpty) return Colors.grey;
      if (strength < 2) return Colors.red;
      if (strength < 3) return Colors.orange;
      return Colors.green;
    }

    String getText() {
      if (password.isEmpty) return '';
      if (strength < 2) return 'Lemah';
      if (strength < 3) return 'Sedang';
      return 'Kuat';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 4,
                backgroundColor: Colors.grey.shade300,
                color: getColor(),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              getText(),
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton(AuthProvider auth, ThemeData theme, Color primaryColor) {
    return AnimatedBuilder(
      animation: _buttonColorAnimation,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : _onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _buttonColorAnimation.value,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF2196F3).withOpacity(0.3),
            ),
            child: auth.isLoading
                ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.login, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Masuk ke Akun',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPasswordSection(BuildContext context, ThemeData theme, Color primaryColor) {
    return AnimatedOpacity(
      opacity: _showForgotPassword ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                _showForgotPasswordDialog(context, theme, primaryColor);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                '🔓 Lupa Password?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Klik di sini untuk mereset password Anda',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context, ThemeData theme, Color primaryColor) {
    return Center(
      child: Column(
        children: [
          Text(
            'Belum punya akun?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                AppRouter.register,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add_alt_1, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '📝 Daftar Akun Baru',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context, ThemeData theme, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.lock_reset, color: Colors.orange),
              const SizedBox(width: 12),
              Text(
                'Lupa Password',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Fitur reset password akan segera tersedia. Untuk sementara, silakan hubungi administrator atau gunakan fitur "Ingat saya" pada login berikutnya.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Tutup',
                style: TextStyle(color: primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Permintaan reset password telah dikirim ke administrator',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              child: const Text('Minta Reset'),
            ),
          ],
        );
      },
    );
  }
}