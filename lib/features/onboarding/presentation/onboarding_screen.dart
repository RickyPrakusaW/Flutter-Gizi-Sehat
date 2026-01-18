import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

/// Model data untuk item onboarding
class OnboardingItem {
  final String image;
  final String title;
  final String subtitle;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

/// Data onboarding yang ditampilkan (3 halaman)
/// Data onboarding yang ditampilkan (3 halaman)
const onboardingItems = <OnboardingItem>[
  OnboardingItem(
    // Gambar 2: Wanita Hamil (Mulai dari masa kehamilan)
    image: 'assets/images/onboarding/onboarding2.png',
    title: 'Pantau Gizi Sejak Kehamilan',
    subtitle: 'Kesehatan ibu cermin kesehatan janin',
    description:
    'Dapatkan rekomendasi nutrisi khusus untuk Ibu hamil. Persiapkan 1000 hari pertama kehidupan buah hati Anda dengan asupan gizi yang tepat dan terpantau.',
  ),
  OnboardingItem(
    // Gambar 1: Ibu menyuapi anak (Nutrisi & Makan)
    image: 'assets/images/onboarding/onboarding1.png',
    title: 'Analisis Nutrisi Makanan',
    subtitle: 'Cek kandungan gizi hanya lewat foto',
    description:
    'Bingung dengan menu si Kecil? Foto makanannya dan biarkan AI kami menghitung kalori serta nutrisinya. Pastikan anak makan lahap dengan gizi seimbang.',
  ),
  OnboardingItem(
    // Gambar 3: Ayah mengukur tinggi anak (Tumbuh Kembang)
    image: 'assets/images/onboarding/onboarding3.png',
    title: 'Cegah Stunting Sejak Dini',
    subtitle: 'Monitoring tumbuh kembang secara berkala',
    description:
    'Catat tinggi dan berat badan anak dengan mudah. Gunakan kurva standar WHO untuk mendeteksi risiko stunting lebih awal demi masa depan yang gemilang.',
  ),
];

/// Screen onboarding untuk memperkenalkan fitur-fitur aplikasi
/// Menampilkan 3 halaman dengan PageView dan navigasi ke login di akhir
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  /// Index halaman onboarding yang sedang ditampilkan
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Navigasi ke halaman login
  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }

  /// Handler untuk tombol next/lanjut
  /// Jika belum di halaman terakhir, pindah ke halaman berikutnya
  /// Jika sudah di halaman terakhir, navigasi ke login
  void _nextPage() {
    if (_currentPage < onboardingItems.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingItems.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(item: onboardingItems[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  /// Membangun section bawah dengan indicator dots dan tombol navigasi
  Widget _buildBottomSection() {
    final isLastPage = _currentPage == onboardingItems.length - 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildDotsIndicator(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isLastPage)
                TextButton(
                  onPressed: _goToLogin,
                  child: const Text(
                    '< Lewati',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                const SizedBox(width: 80),
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isLastPage ? 'Mulai Sekarang' : 'Lanjut >',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Membangun indicator dots untuk menunjukkan halaman aktif
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(onboardingItems.length, (index) {
        final isActive = index == _currentPage;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Widget untuk menampilkan satu halaman onboarding
/// Menampilkan gambar, judul, subtitle, dan deskripsi
class _OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const _OnboardingPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
