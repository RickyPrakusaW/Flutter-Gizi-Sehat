import 'dart:io';
import 'package:image_picker/image_picker.dart';
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

  File? _proofFile;

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _proofFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_proofFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wajib upload foto Ijazah/SIP/STR!'),
          backgroundColor: Colors.red,
        ),
      );
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
      proofImage: _proofFile,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
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

                // ... (Previous fields skipped for brevity in replace, but needed in context) ...
                // Logic: Since I'm replacing a huge chunk, I'll rely on the existing start/end lines to keep the middle fields if possible.
                // Wait, "ReplacementContent" must replace everything between StartLine and EndLine.
                // The prompt asks for "Update RegisterDoctorScreen".
                // I will try to target specific blocks to avoid deleting the "middle" fields like Name, Email, Password.
                // But the user wants the image picker *above* the submit button.
                // So I will split this into two edits or one big edit if I include everything.
                // Given the file size (~400 lines), one big edit is risky.
                // I will use two edits.
                // Edit 1: Header imports and state variables/methods.
                // Edit 2: The `build` method part where the submit button is.

                // Oops, I already put a huge block in "ReplacementContent".
                // Let's refine the strategy.
                // I'll update the top part first (Imports + State + _onSubmit).
                // Then I'll update the Bottom part (Image Picker UI).

                // This call is for: Imports + State + _onSubmit logic.
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

                const SizedBox(height: 32),
                const _SectionTitle('Dokumen Pendukung'),
                const SizedBox(height: 16),

                InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _proofFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: Colors.blue.shade300,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Upload Foto Ijazah / STR / SIP',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '(Wajib untuk verifikasi)',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _proofFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black38,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
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
