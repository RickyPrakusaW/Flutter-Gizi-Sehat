import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/features/auth/state/auth_provider.dart';
import 'package:gizi_sehat_mobile_app/features/auth/models/user_model.dart';

/// Screen untuk proses registrasi Dokter
/// Form lengkap: Data Diri + Data Profesi (STR, SIP, Lokasi, dll)
class RegisterDoctorScreen extends StatefulWidget {
  const RegisterDoctorScreen({super.key});

  @override
  State<RegisterDoctorScreen> createState() => _RegisterDoctorScreenState();
}

class _RegisterDoctorScreenState extends State<RegisterDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Account Info
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(); // Added phone controller

  // Doctor Info
  final _titleCtrl = TextEditingController(); // Gelar (e.g. Sp.A)
  final _specialistCtrl = TextEditingController(); // e.g. Anak, Gizi
  final _strCtrl = TextEditingController();
  final _sipCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _alumniCtrl = TextEditingController();
  final _expYearCtrl = TextEditingController();

  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _phoneCtrl.dispose();
    _titleCtrl.dispose();
    _specialistCtrl.dispose();
    _strCtrl.dispose();
    _sipCtrl.dispose();
    _locationCtrl.dispose();
    _alumniCtrl.dispose();
    _expYearCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = context.read<AuthProvider>();

    final ok = await auth.register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      role: UserRole.doctor,
      // Optional Doctor Fields
      title: _titleCtrl.text.trim(),
      specialist: _specialistCtrl.text.trim(),
      strNumber: _strCtrl.text.trim(),
      sipNumber: _sipCtrl.text.trim(),
      practiceLocation: _locationCtrl.text.trim(),
      alumni: _alumniCtrl.text.trim(),
      experienceYear: int.tryParse(_expYearCtrl.text.trim()),
    );

    if (!mounted) return;

    if (ok) {
      _showSuccessDialog();
    } else {
      final msg = auth.errorMessage ?? 'Registrasi gagal. Silakan coba lagi.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 28),
            SizedBox(width: 12),
            Expanded(child: Text('Menunggu Verifikasi')),
          ],
        ),
        content: const Text(
          'Terima kasih telah mendaftar sebagai Dokter. \n\n'
          'Data Anda sedang diverifikasi oleh Admin (Max 1x24 Jam). \n'
          'Anda belum bisa login sebelum akun disetujui.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Ke Halaman Login'),
          ),
        ],
      ),
    );
  }

  // Common Validators can be extracted to a mixin or utils, simplified here
  String? _required(String? val, String fieldName) {
    if (val == null || val.isEmpty) return '$fieldName wajib diisi!';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Daftar Dokter / Ahli Gizi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.security, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Data Anda aman & akan diverifikasi untuk kredibilitas.',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const _SectionTitle('Informasi Akun'),
                const SizedBox(height: 16),

                // Nama
                TextFormField(
                  controller: _nameCtrl,
                  decoration: _inputDecoration(
                    'Nama Lengkap (Tanpa Gelar)',
                    Icons.person_outline,
                  ),
                  validator: (v) => _required(v, 'Nama'),
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  decoration: _inputDecoration('Email', Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: _inputDecoration(
                    'Nomor Telepon',
                    Icons.phone_outlined,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Nomor Telepon wajib diisi';
                    }
                    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
                    if (!phoneRegex.hasMatch(v)) {
                      return 'Nomor telepon tidak valid!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  decoration: _inputDecoration('Password', Icons.lock_outline)
                      .copyWith(
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePass = !_hidePass),
                          icon: Icon(
                            _hidePass
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                  obscureText: _hidePass,
                  validator: (v) =>
                      v != null && v.length < 8 ? 'Min 8 karakter' : null,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmCtrl,
                  decoration:
                      _inputDecoration(
                        'Ulangi Password',
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                          icon: Icon(
                            _hideConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                  obscureText: _hideConfirm,
                  validator: (v) =>
                      v != _passCtrl.text ? 'Password tidak sama' : null,
                ),

                const SizedBox(height: 32),
                const _SectionTitle('Data Profesional'),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _titleCtrl,
                        decoration: _inputDecoration(
                          'Gelar',
                          Icons.badge_outlined,
                        ),
                        validator: (v) => _required(v, 'Gelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _specialistCtrl,
                        decoration: _inputDecoration(
                          'Spesialisasi',
                          Icons.category_outlined,
                        ),
                        validator: (v) => _required(v, 'Spesialisasi'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _strCtrl,
                  decoration: _inputDecoration(
                    'Nomor STR',
                    Icons.assignment_ind_outlined,
                  ),
                  validator: (v) => _required(v, 'Nomor STR'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _sipCtrl,
                  decoration: _inputDecoration(
                    'Nomor SIP',
                    Icons.assignment_outlined,
                  ),
                  validator: (v) => _required(v, 'Nomor SIP'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _locationCtrl,
                  decoration: _inputDecoration(
                    'Lokasi Praktik (RS/Klinik)',
                    Icons.local_hospital_outlined,
                  ),
                  validator: (v) => _required(v, 'Lokasi Praktik'),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _alumniCtrl,
                        decoration: _inputDecoration(
                          'Alumni',
                          Icons.school_outlined,
                        ),
                        validator: (v) => _required(v, 'Alumni'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        controller: _expYearCtrl,
                        decoration: _inputDecoration(
                          'Pengalaman (Thn)',
                          Icons.timer_outlined,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => _required(v, 'Lama Pengalaman'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Ajukan Pendaftaran',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 1.5),
      ],
    );
  }
}
