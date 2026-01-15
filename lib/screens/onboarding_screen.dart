import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// =======================================================
// 🚪 ONBOARDING SCREEN – GERBANG PERTAMA USER
// =======================================================
// Ini halaman kesan pertama.
// Kalau di sini jelek → user cabut 😬
//
// ASCII FLOW:
//
//  📱 App Dibuka
//      |
//  👋 Onboarding
//      |
//  👉 Login / Register
//
// =======================================================

// ======= 🎨 DESIGN TOKENS =======
// Ganti di sini, seluruh UI ikut berubah 😎
const kBg = Color(0xFFFCFBF4);
const kAccent = Color(0xFF5DB075);
const kText = Color(0xFF333333);
const kSpacing = 24.0;

// ======= 📦 DATA MODEL =======
// Satu halaman onboarding = satu item
class OnboardingItem {
  final String image;             // asset lokal
  final String title;             // judul besar
  final String subtitle;          // sub-judul
  final String description;       // penjelasan
  final String? networkFallback;  // cadangan kalau asset ilang 😅

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    this.networkFallback,
  });
}

// ======= 🧪 DUMMY DATA =======
// Ini “cerita” yang kamu ceritakan ke user
const onboardingItems = <OnboardingItem>[
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding1.jpg',
    title: 'Deteksi Gizi dari Foto Makanan',
    subtitle: 'AI pintar untuk analisis nutrisi',
    description:
    'Ambil foto makanan dan dapatkan analisis kandungan gizi secara otomatis.',
    networkFallback:
    'https://via.placeholder.com/800x560.png?text=Onboarding+1',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding2.jpg',
    title: 'Asisten Gizi dan Saran Menu',
    subtitle: 'Konsultasi 24/7 dengan AI',
    description:
    'Dapatkan saran menu sehat sesuai usia anak.',
    networkFallback:
    'https://via.placeholder.com/800x560.png?text=Onboarding+2',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding3.jpg',
    title: 'Cegah Stunting Sejak Dini',
    subtitle: 'Pantau tumbuh kembang anak',
    description:
    'Gunakan kurva pertumbuhan WHO.',
    networkFallback:
    'https://via.placeholder.com/800x560.png?text=Onboarding+3',
  ),
];

// =======================================================
// 📱 ONBOARDING SCREEN
// =======================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void initState() {
    super.initState();
    print("");
    print("👋 ================================");
    print("👋 OnboardingScreen initState()");
    print("👋 ================================");
    print("");

    // Precache gambar pertama supaya UX halus ✨
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🖼️ Precache gambar onboarding pertama");
      precacheImage(
        const AssetImage('assets/images/onboarding/onboarding1.jpg'),
        context,
      );
    });
  }

  @override
  void dispose() {
    print("");
    print("🧹 ================================");
    print("🧹 OnboardingScreen dispose()");
    print("🧹 PageController dibuang");
    print("🧹 ================================");
    print("");

    _controller.dispose();
    super.dispose();
  }

  // ===============================
  // 👉 PINDAH HALAMAN
  // ===============================
  void _toNext() {
    final last = _page == onboardingItems.length - 1;
    print("➡️ Tombol ditekan | page=$_page | last=$last");

    if (last) {
      _goToLogin();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  // ===============================
  // 🔐 KE LOGIN
  // ===============================
  void _goToLogin() {
    print("🔐 Navigasi ke LOGIN");
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    print("🖥️ Build OnboardingScreen | page=$_page");

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ===============================
            // 📖 PAGEVIEW
            // ===============================
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingItems.length,
                onPageChanged: (i) {
                  print("📄 Page berubah ke $i");
                  setState(() => _page = i);
                },
                itemBuilder: (_, i) =>
                    OnboardingPage(item: onboardingItems[i]),
              ),
            ),

            // ===============================
            // ⚫ DOTS + BUTTON
            // ===============================
            Padding(
              padding:
              const EdgeInsets.fromLTRB(kSpacing, 16, kSpacing, 20),
              child: Column(
                children: [
                  _Dots(count: onboardingItems.length, active: _page),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      // Lewati (hilang di halaman terakhir)
                      if (_page != onboardingItems.length - 1)
                        TextButton(
                          onPressed: _goToLogin,
                          child: const Text(
                            'Lewati',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        )
                      else
                        const SizedBox(width: 80),

                      ElevatedButton(
                        onPressed: _toNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10)),
                        ),
                        child: Text(
                          _page ==
                              onboardingItems.length - 1
                              ? 'Mulai Sekarang'
                              : 'Lanjut',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// 🖼️ SINGLE ONBOARDING PAGE
// =======================================================
class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(kSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RoundedImage(
            width: width * 0.82,
            height: width * 0.68,
            assetPath: item.image,
            networkFallback: item.networkFallback,
          ),
          const SizedBox(height: 36),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// 🧠 IMAGE WITH FALLBACK
// =======================================================
class _RoundedImage extends StatelessWidget {
  final double width;
  final double height;
  final String assetPath;
  final String? networkFallback;

  const _RoundedImage({
    required this.width,
    required this.height,
    required this.assetPath,
    this.networkFallback,
  });

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      print("❌ Asset tidak ditemukan: $path");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: width,
        height: height,
        child: FutureBuilder<bool>(
          future: _assetExists(assetPath),
          builder: (context, snap) {
            if (snap.connectionState ==
                ConnectionState.waiting) {
              return Container(color: Colors.grey.shade200);
            }
            if (snap.data == true) {
              return Image.asset(assetPath, fit: BoxFit.cover);
            }
            if (networkFallback != null) {
              return Image.network(networkFallback!,
                  fit: BoxFit.cover);
            }
            return const Center(
              child: Text('Asset tidak ditemukan'),
            );
          },
        ),
      ),
    );
  }
}

// =======================================================
// ⚫ DOT INDICATOR
// =======================================================
class _Dots extends StatelessWidget {
  final int count;
  final int active;
  const _Dots({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: selected ? 22 : 8,
          decoration: BoxDecoration(
            color: selected ? kAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

/*
===========================================================
ASCII CLOSING:

   (•‿•)ノ
   Welcome to GiziSehat
   Swipe with confidence 👉

Catatan jujur:
- UX onboarding kamu sudah solid ✅
- Fallback asset = keputusan dewasa 🧠
- Tinggal simpan flag "first_time_user" 🚀

print("🎉 Onboarding siap produksi");
===========================================================
*/
