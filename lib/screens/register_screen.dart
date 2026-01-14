import 'package:flutter/material.dart';

// =======================================================
// 📝 REGISTER SCREEN – LAHIRNYA USER BARU
// =======================================================
// Di sinilah user memulai perjalanan hidup sehat 🌱
// Kalau gagal di sini, biasanya karena:
// - password kurang panjang 😅
// - lupa centang S&K 😈
//
// ASCII FLOW:
//
//   👤 → ✍️ Form → ☑️ Setuju → 🚀 Daftar
//
// =======================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ===================================================
  // 🧾 FORM KEY
  // ===================================================
  // Kunci sakral validasi form
  final _formKey = GlobalKey<FormState>();

  // ===================================================
  // ✍️ TEXT CONTROLLERS
  // ===================================================
  // Jangan lupa dispose, ini bukan PHP ❌
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // ===================================================
  // 👁️ STATE UI
  // ===================================================
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _agreeTos = false;

  // ===================================================
  // 🎨 WARNA LOKAL (KHUSUS REGISTER)
  // ===================================================
  static const kAccent = Color(0xFF5DB075);
  static const kBg = Color(0xFFFCFBF4);

  @override
  void dispose() {
    print("");
    print("🧹 ================================");
    print("🧹 RegisterScreen dispose()");
    print("🧹 Controller dibersihkan");
    print("🧹 ================================");
    print("");

    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ===================================================
  // 📐 BORDER INPUT
  // ===================================================
  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
  );

  // ===================================================
  // 🚀 SUBMIT FORM
  // ===================================================
  void _submit() {
    print("");
    print("🚀 ================================");
    print("🚀 Tombol DAFTAR ditekan");
    print("🚀 ================================");
    print("");

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      print("❌ Validasi gagal");
      return;
    }

    if (!_agreeTos) {
      print("⚠️ User belum setuju S&K");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Centang persetujuan S&K dan Kebijakan Privasi'),
        ),
      );
      return;
    }

    // TODO: ganti dengan API / Firebase Auth
    print("✅ Registrasi dummy berhasil");
    print("👤 Nama  : ${_nameCtrl.text}");
    print("📧 Email : ${_emailCtrl.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil (dummy)')),
    );

    // Navigator.pop(context); // balik ke login kalau mau
  }

  @override
  Widget build(BuildContext context) {
    print("🖥️ Build RegisterScreen");

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Daftar'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: DecoratedBox(
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
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Buat Akun Baru',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Bergabunglah dengan GiziSehat untuk memantau tumbuh kembang anak.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 18),

                        // ===============================
                        // 👤 NAMA
                        // ===============================
                        const Text(
                          'Nama Lengkap',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Nama lengkap Anda',
                            prefixIcon:
                            const Icon(Icons.person_outline),
                            border: _border,
                            enabledBorder: _border,
                            focusedBorder: _border,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                          ),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Nama wajib diisi'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // ===============================
                        // 📧 EMAIL
                        // ===============================
                        const Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType:
                          TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'nama@email.com',
                            prefixIcon:
                            const Icon(Icons.email_outlined),
                            border: _border,
                            enabledBorder: _border,
                            focusedBorder: _border,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            final ok = RegExp(
                                r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(v);
                            return ok
                                ? null
                                : 'Masukkan email yang valid';
                          },
                        ),
                        const SizedBox(height: 14),

                        // ===============================
                        // 🔒 PASSWORD
                        // ===============================
                        const Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure1,
                          decoration: InputDecoration(
                            hintText: 'Minimal 8 karakter',
                            prefixIcon:
                            const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                      () => _obscure1 = !_obscure1),
                              icon: Icon(_obscure1
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                            border: _border,
                            enabledBorder: _border,
                            focusedBorder: _border,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password wajib diisi';
                            }
                            if (v.length < 8) {
                              return 'Minimal 8 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // ===============================
                        // 🔁 KONFIRMASI PASSWORD
                        // ===============================
                        const Text(
                          'Konfirmasi Password',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: _obscure2,
                          decoration: InputDecoration(
                            hintText: 'Ulangi password',
                            prefixIcon:
                            const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                      () => _obscure2 = !_obscure2),
                              icon: Icon(_obscure2
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                            border: _border,
                            enabledBorder: _border,
                            focusedBorder: _border,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                          ),
                          validator: (v) =>
                          (v != _passCtrl.text)
                              ? 'Password tidak sama'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // ===============================
                        // ☑️ TOS
                        // ===============================
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreeTos,
                              activeColor: kAccent,
                              onChanged: (v) => setState(
                                      () => _agreeTos = v ?? false),
                            ),
                            const Expanded(
                              child: Padding(
                                padding:
                                EdgeInsets.only(top: 12),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Saya menyetujui ',
                                    children: [
                                      TextSpan(
                                        text:
                                        'Syarat & Ketentuan',
                                        style: TextStyle(
                                          color: kAccent,
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(text: ' dan '),
                                      TextSpan(
                                        text:
                                        'Kebijakan Privasi',
                                        style: TextStyle(
                                          color: kAccent,
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // ===============================
                        // 🚀 BUTTON DAFTAR
                        // ===============================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor: kAccent,
                              padding:
                              const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
===========================================================
ASCII MOTIVATION:

   (⌐■_■)
    < REGISTER >
    < CLEAN >
     /     \

Catatan jujur:
- UI kamu sudah rapi ✅
- Validasi masuk akal ✅
- Tinggal colok Firebase Auth 🔥

print("📝 RegisterScreen siap produksi");
===========================================================
*/
