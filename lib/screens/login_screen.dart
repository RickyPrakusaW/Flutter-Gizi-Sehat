import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  static const kAccent = Color(0xFF5DB075);

  late final TabController _tab;
  bool _obscureLogin = true;
  bool _obscureReg1 = true;
  bool _obscureReg2 = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
  );

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

  Widget _socialButton(IconData icon, String label) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 20, color: Colors.black87),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(label,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE6E6E6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFCFBF4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Icon(Icons.favorite, color: kAccent, size: 56),
              const SizedBox(height: 8),
              const Text('GiziSehat',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Asisten Gizi untuk Keluarga Sehat',
                  style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 18),

              // Kartu + Tab
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    children: [
                      // Segmented Tab
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
                                color: Colors.black.withValues(alpha: 0.06),
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

                      // Konten kedua tab
                      SizedBox(
                        height: 520, // biar stabil, tidak “lompat”
                        child: TabBarView(
                          controller: _tab,
                          children: [
                            // =========== MASUK ===========
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Masuk ke Akun Anda',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                const Text(
                                  'Selamat datang kembali! Masukkan email dan password Anda.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),

                                // Email
                                TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'nama@email.com',
                                    prefixIcon:
                                    const Icon(Icons.email_outlined),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Password
                                TextField(
                                  obscureText: _obscureLogin,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Password Anda',
                                    prefixIcon:
                                    const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() =>
                                      _obscureLogin = !_obscureLogin),
                                      icon: Icon(_obscureLogin
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/home');
                                    },
                                    child: const Text('Masuk'),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text('Lupa password?',
                                        style: TextStyle(color: kAccent)),
                                  ),
                                ),
                              ],
                            ),

                            // =========== DAFTAR ===========
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Buat Akun Baru',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                const Text(
                                  'Bergabunglah dengan GiziSehat untuk memantau tumbuh kembang anak.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),

                                const Text('Nama Lengkap',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Nama lengkap Anda',
                                    prefixIcon:
                                    const Icon(Icons.person_outline),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                const Text('Email',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'nama@email.com',
                                    prefixIcon:
                                    const Icon(Icons.email_outlined),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                const Text('Password',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextField(
                                  obscureText: _obscureReg1,
                                  decoration: InputDecoration(
                                    hintText: 'Minimal 8 karakter',
                                    prefixIcon:
                                    const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                              () => _obscureReg1 = !_obscureReg1),
                                      icon: Icon(_obscureReg1
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                const Text('Konfirmasi Password',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextField(
                                  obscureText: _obscureReg2,
                                  decoration: InputDecoration(
                                    hintText: 'Ulangi password',
                                    prefixIcon:
                                    const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                              () => _obscureReg2 = !_obscureReg2),
                                      icon: Icon(_obscureReg2
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 12),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Daftar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),
              _dividerWithText('atau lanjutkan dengan'),
              const SizedBox(height: 12),
              _socialButton(Icons.g_mobiledata, 'Google'),
              const SizedBox(height: 10),
              _socialButton(Icons.apple, 'Apple'),

              const SizedBox(height: 16),
              // jangan pakai const agar bisa refer ke kAccent
              Text.rich(
                TextSpan(
                  text: 'Dengan mendaftar, Anda menyetujui ',
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: 'Syarat & Ketentuan',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: kAccent),
                    ),
                    const TextSpan(text: ' dan '),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: kAccent),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
