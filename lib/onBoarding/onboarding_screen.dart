import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Placeholder data for onboarding pages
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding1.png", // Ganti dengan path gambar Anda
      "title": "Deteksi Gizi dari Foto Makanan",
      "subtitle": "AI pintar untuk analisis nutrisi",
      "description":
          "Ambil foto makanan dan dapatkan analisis kandungan gizi secara otomatis. Teknologi AI membantu menghitung kalori, protein, dan nutrisi penting lainnya.",
    },
    {
      "image": "assets/images/onboarding2.png", // Ganti dengan path gambar Anda
      "title": "Asisten Gizi dan Saran Menu",
      "subtitle": "Konsultasi 24/7 dengan AI",
      "description":
          "Dapatkan saran menu sehat sesuai usia anak, konsultasi gizi, dan rekomendasi makanan lokal yang terjangkau. Asisten AI siap membantu kapan saja.",
    },
    {
      "image": "assets/images/onboarding3.png", // Ganti dengan path gambar Anda
      "title": "Cegah Stunting Sejak Dini",
      "subtitle": "Pantau tumbuh kembang anak dengan mudah",
      "description":
          "Gunakan kurva pertumbuhan WHO untuk memantau berat dan tinggi badan anak secara berkala. Deteksi dini risiko stunting untuk masa depan yang lebih sehat.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToHome() {
    // TODO: Ganti dengan navigasi ke halaman utama aplikasi Anda
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF4), // Warna latar belakang seperti di gambar
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final item = _onboardingData[index];
                  return OnboardingPageContent(
                    imagePath: item['image']!,
                    title: item['title']!,
                    subtitle: item['subtitle']!,
                    description: item['description']!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage != _onboardingData.length - 1)
                        TextButton(
                          onPressed: _navigateToHome, // Tombol Lewati
                          child: const Text(
                            'Lewati',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      else
                        const SizedBox(width: 80), // Placeholder untuk alignment

                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _onboardingData.length - 1) {
                            _navigateToHome(); // Tombol Mulai Sekarang
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5DB075), // Warna tombol hijau
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _currentPage == _onboardingData.length - 1
                              ? 'Mulai Sekarang'
                              : 'Lanjut',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
             const SizedBox(height: 20), // Memberi sedikit ruang di bawah
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? const Color(0xFF5DB075) : Colors.grey.shade300,
      ),
    );
  }
}

class OnboardingPageContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;

  const OnboardingPageContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gambar akan berbentuk persegi dengan sudut membulat
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.7, // Aspek rasio bisa disesuaikan
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Sudut membulat untuk gambar
              image: DecorationImage(
                // Jika menggunakan aset lokal, pastikan path benar dan sudah ditambahkan di pubspec.yaml
                // image: AssetImage(imagePath), 
                // Placeholder jika gambar belum ada
                image: NetworkImage('https://via.placeholder.com/400x300.png?text=Image+Placeholder'),
                fit: BoxFit.cover,
              ),
               boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 4,
                  blurRadius: 12,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF5DB075), // Warna hijau untuk subtitle
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
