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
const onboardingItems = <OnboardingItem>[
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding1.jpg',
    title: 'Deteksi Gizi dari Foto Makanan',
    subtitle: 'AI pintar untuk analisis nutrisi',
    description:
        'Ambil foto makanan dan dapatkan analisis kandungan gizi secara otomatis. Teknologi AI membantu menghitung kalori, protein, dan nutrisi penting lainnya.',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding2.jpg',
    title: 'Asisten Gizi dan Saran Menu',
    subtitle: 'Konsultasi 24/7 dengan AI',
    description:
        'Dapatkan saran menu sehat sesuai usia anak, konsultasi gizi, dan rekomendasi makanan lokal yang terjangkau. Asisten AI siap membantu kapan saja.',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding3.jpg',
    title: 'Cegah Stunting Sejak Dini',
    subtitle: 'Pantau tumbuh kembang anak dengan mudah',
    description:
        'Gunakan kurva pertumbuhan WHO untuk memantau berat dan tinggi badan anak secara berkala. Deteksi dini risiko stunting untuk masa depan yang lebih sehat.',
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
