import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hidePass = true;
  bool _hideConfirm = true;

  // Animasi controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _buttonColorAnimation;

  // Validasi real-time
  bool _isNameValid = true;
  bool _isEmailValid = true;
  bool _isPhoneValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmValid = true;

  @override
  void initState() {
    super.initState();

    // Setup animasi controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Animasi scale untuk tombol
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Animasi warna tombol
    _buttonColorAnimation = ColorTween(
      begin: Colors.grey[400],
      end: const Color(0xFF4CAF50),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animasi
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });

    // Setup real-time validation listeners
    _setupValidationListeners();
  }

  void _setupValidationListeners() {
    _nameCtrl.addListener(() {
      setState(() {
        _isNameValid = _nameCtrl.text.isNotEmpty;
      });
    });

    _emailCtrl.addListener(() {
      setState(() {
        _isEmailValid = _validateEmail(_emailCtrl.text) == null;
      });
    });

    _phoneCtrl.addListener(() {
      setState(() {
        _isPhoneValid = _validatePhone(_phoneCtrl.text) == null;
      });
    });

    _passCtrl.addListener(() {
      setState(() {
        _isPasswordValid = _validatePassword(_passCtrl.text) == null;
        _isConfirmValid = _validateConfirmPassword(_confirmCtrl.text) == null;
      });
    });

    _confirmCtrl.addListener(() {
      setState(() {
        _isConfirmValid = _validateConfirmPassword(_confirmCtrl.text) == null;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      // Animasi shake jika validasi gagal
      _playErrorAnimation();
      return;
    }

    final auth = context.read<AuthProvider>();

    final ok = await auth.register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      // Feedback sukses dengan animasi
      await _showSuccessDialog(context);

      // Navigasi ke login screen dengan animasi
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.login,
            (route) => false,
      );
    } else {
      final msg = auth.errorMessage ?? 'Registrasi gagal';
      _showErrorSnackBar(context, msg);
    }
  }

  void _playErrorAnimation() async {
    await _animationController.forward();
    await _animationController.reverse();
    await _animationController.forward();
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animasi lingkaran sukses
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '🎉 Registrasi Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Akun Anda telah berhasil dibuat. Silakan login untuk melanjutkan.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(120, 48),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '👤 Nama lengkap wajib diisi!';
    }
    if (value.length < 3) {
      return '👤 Nama minimal 3 karakter!';
    }
    return null;
  }

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

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '📱 Nomor telepon diperlukan!';
    }

    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
    if (!phoneRegex.hasMatch(value)) {
      return '📱 Nomor telepon tidak valid!';
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

    // Password strength validation
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return '🔒 Password harus mengandung huruf besar!';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return '🔒 Password harus mengandung angka!';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '🔐 Konfirmasi password harus diisi!';
    }

    if (value != _passCtrl.text) {
      return '🔐 Password tidak cocok!';
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
    final surfaceColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final backgroundColor = isDark
        ? const Color(0xFF0F1525)
        : const Color(0xFFF0F7FF);
    final textColor = isDark ? Colors.white : const Color(0xFF333333);
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan back button dan judul
                _buildHeader(context, theme, primaryColor),
                const SizedBox(height: 24),

                // Judul dan deskripsi
                _buildTitleSection(theme, textColor),
                const SizedBox(height: 32),

                // Form registrasi
                SlideTransition(
                  position: _slideAnimation,
                  child: _buildRegisterForm(
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

                // Tombol daftar
                _buildRegisterButton(auth, theme),
                const SizedBox(height: 24),

                // Link ke login
                _buildLoginLink(context, theme, primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, Color primaryColor) {
    return Row(
      children: [
        // Back button dengan animasi
        GestureDetector(
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
        ),
        const Spacer(),
        Text(
          'Buat Akun Baru',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 40), // Placeholder untuk balance layout
      ],
    );
  }

  Widget _buildTitleSection(ThemeData theme, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🚀 Mulai Perjalanan Gizi Sehat',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bergabunglah dengan ribuan keluarga yang telah memperbaiki kesehatan mereka melalui panduan gizi yang tepat.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: textColor.withOpacity(0.7),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(
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
            // Field nama lengkap
            _buildNameField(theme, textColor, hintColor, primaryColor),
            const SizedBox(height: 20),

            // Field email
            _buildEmailField(theme, textColor, hintColor, primaryColor),
            const SizedBox(height: 20),

            // Field nomor telepon
            _buildPhoneField(theme, textColor, hintColor, primaryColor),
            const SizedBox(height: 20),

            // Field password
            _buildPasswordField(theme, textColor, hintColor, primaryColor),
            const SizedBox(height: 20),

            // Field konfirmasi password
            _buildConfirmPasswordField(theme, textColor, hintColor, primaryColor),
            const SizedBox(height: 8),

            // Indikator strength password
            _buildPasswordStrengthIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(
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
            const Icon(Icons.person_outline, size: 16),
            const SizedBox(width: 8),
            Text(
              '👤 Nama Lengkap',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameCtrl,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: 'Masukkan nama lengkap Anda',
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: Icon(Icons.account_circle_outlined, color: hintColor),
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
            suffixIcon: _isNameValid && _nameCtrl.text.isNotEmpty
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
          ),
          validator: _validateName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
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
              '📧 Email',
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
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: 'contoh@email.com',
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

  Widget _buildPhoneField(
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
            const Icon(Icons.phone_outlined, size: 16),
            const SizedBox(width: 8),
            Text(
              '📱 Nomor Telepon',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: '0812 3456 7890',
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: Icon(Icons.phone_outlined, color: hintColor),
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
            suffixIcon: _isPhoneValid && _phoneCtrl.text.isNotEmpty
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
          ),
          validator: _validatePhone,
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
          obscureText: _hidePass,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: 'Minimal 8 karakter',
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
                    setState(() => _hidePass = !_hidePass);
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
                      _hidePass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: hintColor,
                      key: ValueKey<bool>(_hidePass),
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

  Widget _buildConfirmPasswordField(
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
            const Icon(Icons.lock_reset_outlined, size: 16),
            const SizedBox(width: 8),
            Text(
              '🔐 Konfirmasi Password',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmCtrl,
          obscureText: _hideConfirm,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: 'Ketik ulang password Anda',
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: Icon(Icons.lock_reset_outlined, color: hintColor),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isConfirmValid && _confirmCtrl.text.isNotEmpty)
                  Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() => _hideConfirm = !_hideConfirm);
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
                      _hideConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: hintColor,
                      key: ValueKey<bool>(_hideConfirm),
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
          validator: _validateConfirmPassword,
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
        const SizedBox(height: 4),
        Text(
          'Password harus mengandung huruf besar, angka, dan minimal 8 karakter',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AuthProvider auth, ThemeData theme) {
    return AnimatedBuilder(
      animation: _buttonColorAnimation,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: _buttonColorAnimation.value,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
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
                const Icon(Icons.app_registration_outlined),
                const SizedBox(width: 12),
                Text(
                  'Daftar Sekarang',
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

  Widget _buildLoginLink(BuildContext context, ThemeData theme, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              AppRouter.login,
            );
          },
          child: Text(
            'Masuk di sini',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}