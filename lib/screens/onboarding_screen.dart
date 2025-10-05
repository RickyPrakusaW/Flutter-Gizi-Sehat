import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// ======= Design tokens (mudah diganti) =======
const kBg = Color(0xFFFCFBF4);
const kAccent = Color(0xFF5DB075);
const kText = Color(0xFF333333);
const kSpacing = 24.0;

/// ======= Data model =======
class OnboardingItem {
  final String image;             // path asset: assets/images/onboarding/xxx.jpg
  final String title;
  final String subtitle;
  final String description;
  final String? networkFallback;  // opsional: fallback via internet

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    this.networkFallback,
  });
}

/// ======= Dummy data =======
const onboardingItems = <OnboardingItem>[
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding1.jpg',
    title: 'Deteksi Gizi dari Foto Makanan',
    subtitle: 'AI pintar untuk analisis nutrisi',
    description:
    'Ambil foto makanan dan dapatkan analisis kandungan gizi secara otomatis. Teknologi AI membantu menghitung kalori, protein, dan nutrisi penting lainnya.',
    networkFallback: 'https://via.placeholder.com/800x560.png?text=Onboarding+1',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding2.jpg',
    title: 'Asisten Gizi dan Saran Menu',
    subtitle: 'Konsultasi 24/7 dengan AI',
    description:
    'Dapatkan saran menu sehat sesuai usia anak, konsultasi gizi, dan rekomendasi makanan lokal yang terjangkau. Asisten AI siap membantu kapan saja.',
    networkFallback: 'https://via.placeholder.com/800x560.png?text=Onboarding+2',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding3.jpg',
    title: 'Cegah Stunting Sejak Dini',
    subtitle: 'Pantau tumbuh kembang anak dengan mudah',
    description:
    'Gunakan kurva pertumbuhan WHO untuk memantau berat dan tinggi badan anak secara berkala. Deteksi dini risiko stunting untuk masa depan yang lebih sehat.',
    networkFallback: 'https://via.placeholder.com/800x560.png?text=Onboarding+3',
  ),
];

/// ======= Screen =======
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
    // Precache gambar pertama biar nggak ngedip
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/onboarding/onboarding1.jpg'), context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toNext() {
    final last = _page == onboardingItems.length - 1;
    if (last) {
      _goToLogin();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _goToLogin() {
    // ganti onboarding dengan login
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ===== Halaman
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingItems.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => OnboardingPage(item: onboardingItems[i]),
              ),
            ),

            // ===== Indicator + Tombol
            Padding(
              padding: const EdgeInsets.fromLTRB(kSpacing, 16, kSpacing, 20),
              child: Column(
                children: [
                  _Dots(count: onboardingItems.length, active: _page),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Lewati (sembunyikan di halaman terakhir)
                      if (_page != onboardingItems.length - 1)
                        TextButton(
                          onPressed: _goToLogin,
                          child: const Text(
                            'Lewati',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      else
                        const SizedBox(width: 80),

                      // Lanjut / Mulai Sekarang
                      ElevatedButton(
                        onPressed: _toNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          _page == onboardingItems.length - 1 ? 'Mulai Sekarang' : 'Lanjut',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
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

/// ======= One onboarding page widget =======
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
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kText),
          ),
          const SizedBox(height: 10),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kAccent),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// ======= Rounded image with graceful fallback =======
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
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pakai FutureBuilder untuk cek asset ada/tidak → fallback ke network bila perlu
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FutureBuilder<bool>(
          future: _assetExists(assetPath),
          builder: (context, snap) {
            final hasAsset = snap.data == true;
            if (snap.connectionState == ConnectionState.waiting) {
              return Container(color: Colors.grey.shade200);
            }
            if (hasAsset) {
              return Image.asset(assetPath, fit: BoxFit.cover);
            }
            if (networkFallback != null) {
              return Image.network(networkFallback!, fit: BoxFit.cover);
            }
            return Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text('Asset tidak ditemukan', style: TextStyle(color: Colors.grey)),
            );
          },
        ),
      ),
    );
  }
}

/// ======= Dot indicator =======
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
