import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final TabController _tab;
  final _loginKey = GlobalKey<FormState>();
  final _registerKey = GlobalKey<FormState>();

  // Login
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginObscure = true;

  // Register
  final _name = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPassword = TextEditingController();
  final _regPassword2 = TextEditingController();
  bool _regObscure = true;
  bool _regObscure2 = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    _name.dispose();
    _regEmail.dispose();
    _regPassword.dispose();
    _regPassword2.dispose();
    super.dispose();
  }

  // ====== UI helpers ======
  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
  );

  Widget _socialButton(IconData icon, String label, {VoidCallback? onTap}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: Colors.black87),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE6E6E6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _dividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E5E5))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: const TextStyle(color: Colors.grey)),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E5E5))),
      ],
    );
  }

  // ====== Actions (dummy) ======
  void _doLogin() {
    if (_loginKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil (dummy)')),
      );
    }
  }

  void _doRegister() {
    if (_registerKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil (dummy)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF5DB075);

    return Scaffold(
      // Background halus (gradasi)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFFDFCF7), Color(0xFFF4F9F2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    // Logo kecil
                    const Icon(Icons.favorite, color: Color(0xFF5DB075), size: 56),
                    const SizedBox(height: 8),
                    const Text('GiziSehat',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),

                    // Kartu auth
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                        child: Column(
                          children: [
                            // Tab Masuk / Daftar (segmented)
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F4F3),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: TabBar(
                                controller: _tab,
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.black54,
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Tab(text: 'Masuk'),
                                  Tab(text: 'Daftar'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            SizedBox(
                              height: 520, // agar tinggi stabil
                              child: TabBarView(
                                controller: _tab,
                                children: [
                                  // ==================== MASUK ====================
                                  Form(
                                    key: _loginKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Masuk ke Akun Anda',
                                          style: TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Selamat datang kembali! Masukkan email dan password Anda.',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Email',
                                            style: TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _loginEmail,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: 'nama@email.com',
                                            prefixIcon: const Icon(Icons.email_outlined),
                                            border: _border, enabledBorder: _border, focusedBorder: _border,
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Email tidak boleh kosong';
                                            }
                                            if (!v.contains('@')) {
                                              return 'Masukkan email yang valid';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 14),

                                        const Text('Password',
                                            style: TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _loginPassword,
                                          obscureText: _loginObscure,
                                          decoration: InputDecoration(
                                            hintText: 'Password Anda',
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            suffixIcon: IconButton(
                                              onPressed: () =>
                                                  setState(() => _loginObscure = !_loginObscure),
                                              icon: Icon(_loginObscure
                                                  ? Icons.visibility_outlined
                                                  : Icons.visibility_off_outlined),
                                            ),
                                            border: _border, enabledBorder: _border, focusedBorder: _border,
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Password tidak boleh kosong';
                                            }
                                            if (v.length < 6) return 'Minimal 6 karakter';
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 18),

                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _doLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: green,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text('Masuk',
                                                style: TextStyle(color: Colors.white, fontSize: 16)),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Center(
                                          child: TextButton(
                                            onPressed: () {},
                                            child: const Text('Lupa password?',
                                                style: TextStyle(color: Color(0xFF5DB075))),
                                          ),
                                        ),

                                        const SizedBox(height: 8),
                                        _dividerWithText('atau lanjutkan dengan'),
                                        const SizedBox(height: 12),
                                        _socialButton(Icons.g_mobiledata, 'Google'),
                                        const SizedBox(height: 10),
                                        _socialButton(Icons.apple, 'Apple'),
                                      ],
                                    ),
                                  ),

                                  // ==================== DAFTAR ====================
                                  Form(
                                    key: _registerKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Buat Akun Baru',
                                          style: TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Bergabunglah dengan GiziSehat untuk memantau tumbuh kembang anak.',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 16),

                                        const Text('Nama Lengkap',
                                            style: TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _name,
                                          decoration: InputDecoration(
                                            hintText: 'Nama lengkap Anda',
                                            prefixIcon: const Icon(Icons.person_outline),
                                            border: _border, enabledBorder: _border, focusedBorder: _border,
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                          ),
                                          validator: (v) =>
                                          (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                                        ),
                                        const SizedBox(height: 14),

                                        const Text('Email',
                                            style: TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _regEmail,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: 'nama@email.com',
                                            prefixIcon: const Icon(Icons.email_outlined),
                                            border: _border, enabledBorder: _border, focusedBorder: _border,
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Email tidak boleh kosong';
                                            }
                                            if (!v.contains('@')) {
                                              return 'Masukkan email yang valid';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 14),

                                        const Text('Password',
                                            style: TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _regPassword,
                                          obscureText: _regObscure,
                                          decoration: InputDecoration(
                                            hintText: 'Minimal 8 karakter',
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            suffixIcon: IconButton(
                                              onPressed: () =>
                                                  setState(() => _regObscure = !_regObscure),
                                              icon: Icon(_regObscure
                                                  ? Icons.visibility_outlined
                                                  : Icons.visibility_off_outlined),
                                            ),
                                            border: _border, enabledBorder: _border, focusedBorder: _border,
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Password wajib diisi';
                                            }
                                            if (v.length < 8) return 'Minimal 8 karakter';
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 14),

                                        const Text('Konfirmasi Password',
                                            style: TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _regPassword2,
                                          obscureText: _regObscure2,
                                          decoration: InputDecoration(
                                            hintText: 'Ulangi password',
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            suffixIcon: IconButton(
                                              onPressed: () =>
                                                  setState(() => _regObscure2 = !_regObscure2),
                                              icon: Icon(_regObscure2
                                                  ? Icons.visibility_outlined
                                                  : Icons.visibility_off_outlined),
                                            ),
                                            border: _border, enabledBorder: _border, focusedBorder: _border,
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                          ),
                                          validator: (v) {
                                            if (v != _regPassword.text) {
                                              return 'Password tidak sama';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 18),

                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _doRegister,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: green,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text('Daftar',
                                                style: TextStyle(color: Colors.white, fontSize: 16)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    _dividerWithText('atau lanjutkan dengan'),
                    const SizedBox(height: 12),
                    _socialButton(Icons.g_mobiledata, 'Google'),
                    const SizedBox(height: 10),
                    _socialButton(Icons.apple, 'Apple'),

                    const SizedBox(height: 18),
                    Text.rich(
                      TextSpan(
                        text: 'Dengan mendaftar, Anda menyetujui ',
                        style: const TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: TextStyle(color: green, fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: TextStyle(color: green, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
