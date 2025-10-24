import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: panggil auth_repository.register(...)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil (dummy)')),
    );

    Navigator.pushReplacementNamed(context, AppRouter.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // warna teks utama (judul, isi form)
    final headingColor =
    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    // warna teks sekunder (hint, label kecil)
    final subtitleColor =
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    // warna kartu (surface)
    final sectionBg = theme.colorScheme.surface; // dark: #1C1C1C, light: #FFFFFF

    // border kartu
    final borderColor =
    isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Daftar Akun',
          style: TextStyle(
            color: headingColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: headingColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: sectionBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nama Lengkap
                  TextFormField(
                    controller: _nameCtrl,
                    style: TextStyle(
                      color: headingColor,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      labelStyle: TextStyle(
                        color: subtitleColor,
                      ),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: headingColor,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: subtitleColor,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      // TODO: validators.email(v)
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _hidePass,
                    style: TextStyle(
                      color: headingColor,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: subtitleColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: subtitleColor,
                        ),
                        onPressed: () =>
                            setState(() => _hidePass = !_hidePass),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (v.length < 6) {
                        return 'Minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Konfirmasi Password
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _hideConfirm,
                    style: TextStyle(
                      color: headingColor,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      labelStyle: TextStyle(
                        color: subtitleColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: subtitleColor,
                        ),
                        onPressed: () =>
                            setState(() => _hideConfirm = !_hideConfirm),
                      ),
                    ),
                    validator: (v) {
                      if (v != _passCtrl.text) {
                        return 'Tidak sama dengan password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Tombol Buat Akun
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _register,
                      child: const Text(
                        'Buat Akun',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sudah punya akun? Masuk
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.login,
                      );
                    },
                    child: const Text(
                      'Sudah punya akun? Masuk',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
