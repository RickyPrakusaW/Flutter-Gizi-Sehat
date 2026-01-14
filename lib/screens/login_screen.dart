import 'package:flutter/material.dart';

// =======================================================
// 🔐 LOGIN & REGISTER SCREEN
// =======================================================
// Ini halaman PENTING.
// Kalau user gagal login di sini → app kamu MATI.
//
// ASCII FLOW:
//
//   👤 User
//     |
//   🔐 Login / Register
//     |
//   🏠 Home
//
// =======================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  static const kAccent = Color(0xFF5DB075);

  late final TabController _tab;

  // 👁️ Toggle visibility password
  bool _obscureLogin = true;
  bool _obscureReg1 = true;
  bool _obscureReg2 = true;

  @override
  void initState() {
    super.initState();
    print("");
    print("🔐 ================================");
    print("🔐 LoginScreen initState()");
    print("🔐 ================================");
    print("");

    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    print("");
    print("🧹 ================================");
    print("🧹 LoginScreen dispose()");
    print("🧹 TabController dibuang");
    print("🧹 ================================");
    print("");

    _tab.dispose();
    super.dispose();
  }

  // =======================================================
  // 🧱 BORDER INPUT – konsisten & reusable
  // =======================================================
  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
  );

  // =======================================================
  // ➖ Divider dengan teks di tengah
  // =======================================================
  Widget _dividerWithText(String text) {
    print("➖ Render divider: $text");
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

  // =======================================================
  // 🌐 Tombol login sosial (dummy)
  // =======================================================
  Widget _socialButton(IconData icon, String label) {
    print("🌐 Render social button: $label");
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          print("🚧 Social login '$label' belum diimplementasi");
        },
        icon: Icon(icon, size: 20, color: Colors.black87),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE6E6E6)),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("🖥️ Build LoginScreen");

    const bg = Color(0xFFFCFBF4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              // =======================================================
              // 🧠 HEADER BRAND
              // =======================================================
              const SizedBox(height: 8),
              const Icon(Icons.favorite, color: kAccent, size: 56),
              const SizedBox(height: 8),
              const Text(
                'GiziSehat',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Asisten Gizi untuk Keluarga Sehat',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 18),

              // =======================================================
              // 📦 CARD LOGIN / REGISTER
              // =======================================================
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
                      // ===============================
                      // 🧭 TAB LOGIN / REGISTER
                      // ===============================
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
                                color:
                                Colors.black.withValues(alpha: 0.06),
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

                      // ===================================================
                      // 📄 TAB CONTENT
                      // ===================================================
                      SizedBox(
                        height: 520, // mencegah UI lompat
                        child: TabBarView(
                          controller: _tab,
                          children: [
                            // ===============================
                            // 🔐 MASUK
                            // ===============================
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Masuk ke Akun Anda',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Selamat datang kembali!',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),

                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: const Icon(
                                        Icons.email_outlined),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                  ),
                                ),
                                const SizedBox(height: 14),

                                TextField(
                                  obscureText: _obscureLogin,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(
                                        Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() =>
                                        _obscureLogin =
                                        !_obscureLogin);
                                        print("👁️ Toggle password login");
                                      },
                                      icon: Icon(_obscureLogin
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                  ),
                                ),
                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("✅ Login dummy → /home");
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    },
                                    child: const Text('Masuk'),
                                  ),
                                ),
                              ],
                            ),

                            // ===============================
                            // 📝 DAFTAR
                            // ===============================
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Buat Akun Baru',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Daftar untuk mulai perjalanan sehat.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),

                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Nama lengkap',
                                    prefixIcon: const Icon(
                                        Icons.person_outline),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                  ),
                                ),
                                const SizedBox(height: 14),

                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    prefixIcon: const Icon(
                                        Icons.email_outlined),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                  ),
                                ),
                                const SizedBox(height: 14),

                                TextField(
                                  obscureText: _obscureReg1,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: const Icon(
                                        Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() =>
                                        _obscureReg1 =
                                        !_obscureReg1);
                                        print("👁️ Toggle password daftar");
                                      },
                                      icon: Icon(_obscureReg1
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                    border: _border,
                                    enabledBorder: _border,
                                    focusedBorder: _border,
                                  ),
                                ),
                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(
                                          "📝 Register dummy ditekan");
                                    },
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
            ],
          ),
        ),
      ),
    );
  }
}

/*
===========================================================
ASCII FOOTER:

   🔐  (•_•)
      <)   )╯
       /   \

Login screen siap tempur.
Tinggal sambungkan ke AuthProvider / Firebase.
===========================================================
*/
