import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/app_router.dart';
import 'package:gizi_sehat_mobile_app/core/constants/app_colors.dart';

/// ======= Design tokens (mudah diganti) =======
final kBg = AppColors.lightBackground;
final kAccent = AppColors.accent;
final kText = AppColors.lightTextPrimary;
const kSpacing = 24.0;

/// ======= Data model =======
class OnboardingItem {
  final String emoji; // Emoji untuk ikon visual
  final String image; // path asset: assets/images/onboarding/xxx.png
  final String title;
  final String subtitle;
  final String description;
  final String? networkFallback; // opsional: kalau asset belum ada
  final Color gradientStart;
  final Color gradientEnd;

  const OnboardingItem({
    required this.emoji,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    this.networkFallback,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

/// ======= Dummy data dengan gradient dan emoji =======
const onboardingItems = <OnboardingItem>[
  OnboardingItem(
    emoji: '🍎',
    image: 'assets/images/onboarding/onboarding1.jpg',
    title: 'Deteksi Gizi dari Foto Makanan 📸',
    subtitle: 'AI pintar untuk analisis nutrisi',
    description:
    'Ambil foto makanan dan dapatkan analisis kandungan gizi secara otomatis. Teknologi AI membantu menghitung kalori, protein, dan nutrisi penting lainnya.',
    networkFallback:
    'https://via.placeholder.com/800x560.png?text=Onboarding+1',
    gradientStart: Color(0xFF6A11CB),
    gradientEnd: Color(0xFF2575FC),
  ),
  OnboardingItem(
    emoji: '🧠',
    image: 'assets/images/onboarding/onboarding2.jpg',
    title: 'Asisten Gizi dan Saran Menu 🍽️',
    subtitle: 'Konsultasi 24/7 dengan AI',
    description:
    'Dapatkan saran menu sehat sesuai usia anak, konsultasi gizi, dan rekomendasi makanan lokal yang terjangkau. Asisten AI siap membantu kapan saja.',
    networkFallback:
    'https://via.placeholder.com/800x560.png?text=Onboarding+2',
    gradientStart: Color(0xFF11998E),
    gradientEnd: Color(0xFF38EF7D),
  ),
  OnboardingItem(
    emoji: '👶',
    image: 'assets/images/onboarding/onboarding3.jpg',
    title: 'Cegah Stunting Sejak Dini 📈',
    subtitle: 'Pantau tumbuh kembang anak dengan mudah',
    description:
    'Gunakan kurva pertumbuhan WHO untuk memantau berat dan tinggi badan anak secara berkala. Deteksi dini risiko stunting untuk masa depan yang lebih sehat.',
    networkFallback:
    'https://via.placeholder.com/800x560.png?text=Onboarding+3',
    gradientStart: Color(0xFFFF416C),
    gradientEnd: Color(0xFFFF4B2B),
  ),
];

/// ======= Screen dengan animasi =======
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _progressAnimation;

  // Untuk animasi bertahap pada setiap halaman
  List<double> _pageAnimations = [0.0, 0.0, 0.0];

  @override
  void initState() {
    super.initState();

    // Setup animation controller untuk efek khusus
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Animasi scale untuk tombol
    _buttonScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Animasi progress bar
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation
    _animationController.forward();

    // Setup listener untuk page changes
    _controller.addListener(_pageListener);
  }

  void _pageListener() {
    final page = _controller.page ?? _currentPage.toDouble();
    setState(() {
      _currentPage = page.round();
      // Update animation progress untuk setiap halaman
      for (int i = 0; i < onboardingItems.length; i++) {
        final distance = (page - i).abs();
        _pageAnimations[i] = (1.0 - distance.clamp(0.0, 1.0));
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_pageListener);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toNext() {
    final isLastPage = _currentPage == onboardingItems.length - 1;

    if (isLastPage) {
      _goToLogin();
    } else {
      // Animasi sebelum pindah halaman
      _animationController.reverse().then((_) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        _animationController.forward();
      });
    }
  }

  void _goToLogin() {
    // Animasi sebelum navigasi
    _animationController.reverse().then((_) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    });
  }

  void _onDotTap(int index) {
    _animationController.reverse().then((_) {
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 350;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              onboardingItems[_currentPage].gradientStart.withOpacity(0.1),
              onboardingItems[_currentPage].gradientEnd.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan skip button
              _buildHeader(size),

              // Pages dengan animasi
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingItems.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      item: onboardingItems[index],
                      animationValue: _pageAnimations[index],
                      isActive: index == _currentPage,
                    );
                  },
                ),
              ),

              // Indicators + Buttons dengan animasi
              _buildFooter(isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo atau brand
          Opacity(
            opacity: 0.8,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        onboardingItems[_currentPage].gradientStart,
                        onboardingItems[_currentPage].gradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.health_and_safety,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'GiziSehat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: onboardingItems[_currentPage].gradientEnd,
                  ),
                ),
              ],
            ),
          ),

          // Skip button (sembunyikan di halaman terakhir)
          if (_currentPage != onboardingItems.length - 1)
            ScaleTransition(
              scale: _buttonScaleAnimation,
              child: OutlinedButton(
                onPressed: _goToLogin,
                style: OutlinedButton.styleFrom(
                  foregroundColor: onboardingItems[_currentPage].gradientEnd,
                  side: BorderSide(
                    color: onboardingItems[_currentPage].gradientEnd.withOpacity(0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text(
                  'Lewati',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        children: [
          // Progress indicator animated
          _buildAnimatedProgressBar(),
          const SizedBox(height: 32),

          // Dots indicator dengan animasi
          _buildAnimatedDots(),
          const SizedBox(height: 32),

          // Tombol utama dengan animasi scale
          ScaleTransition(
            scale: _buttonScaleAnimation,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: onboardingItems[_currentPage].gradientEnd,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: onboardingItems[_currentPage].gradientEnd.withOpacity(0.5),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _currentPage == onboardingItems.length - 1
                        ? '🚀 Mulai Sekarang!'
                        : 'Lanjutkan →',
                    key: ValueKey(_currentPage),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProgressBar() {
    return SizedBox(
      height: 4,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background bar
              Container(
                width: constraints.maxWidth,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Progress bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: constraints.maxWidth * ((_currentPage + 1) / onboardingItems.length),
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      onboardingItems[_currentPage].gradientStart,
                      onboardingItems[_currentPage].gradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(onboardingItems.length, (index) {
        final isActive = index == _currentPage;
        final pageAnimation = _pageAnimations[index];

        return GestureDetector(
          onTap: () => _onDotTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: isActive ? 32 : 12,
            height: 12,
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(
                colors: [
                  onboardingItems[_currentPage].gradientStart,
                  onboardingItems[_currentPage].gradientEnd,
                ],
              )
                  : null,
              color: isActive ? null : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: onboardingItems[_currentPage].gradientEnd.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
                  : null,
            ),
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isActive ? 1.0 : 0.0,
                child: Text(
                  onboardingItems[index].emoji,
                  style: const TextStyle(fontSize: 8),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// ======= One onboarding page dengan animasi =======
class OnboardingPage extends StatefulWidget {
  final OnboardingItem item;
  final double animationValue;
  final bool isActive;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.animationValue,
    required this.isActive,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _subtitleSlideAnimation;
  late Animation<double> _descriptionFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Setup staggered animations
    _imageScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _titleSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _subtitleSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
      ),
    );

    _descriptionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation jika page aktif
    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(OnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset dan play animation jika page menjadi aktif
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar dengan scale animation
              ScaleTransition(
                scale: _imageScaleAnimation,
                child: _RoundedImage(
                  width: width * 0.82,
                  height: width * 0.68,
                  assetPath: widget.item.image,
                  networkFallback: widget.item.networkFallback,
                  gradientStart: widget.item.gradientStart,
                  gradientEnd: widget.item.gradientEnd,
                ),
              ),
              const SizedBox(height: 40),

              // Judul dengan slide animation
              Transform.translate(
                offset: Offset(0, _titleSlideAnimation.value),
                child: Opacity(
                  opacity: _titleSlideAnimation.value == 0.0 ? 1.0 : 0.0,
                  child: Text(
                    widget.item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width < 350 ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: widget.item.gradientEnd,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle dengan slide animation
              Transform.translate(
                offset: Offset(0, _subtitleSlideAnimation.value),
                child: Opacity(
                  opacity: _subtitleSlideAnimation.value == 0.0 ? 1.0 : 0.0,
                  child: Text(
                    widget.item.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width < 350 ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Deskripsi dengan fade animation
              Opacity(
                opacity: _descriptionFadeAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.item.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width < 350 ? 13 : 15,
                      color: Colors.grey.shade800,
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              // Emoji besar sebagai aksen
              const SizedBox(height: 32),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _descriptionFadeAnimation.value,
                child: Text(
                  widget.item.emoji,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ======= Rounded image dengan efek gradient border =======
class _RoundedImage extends StatelessWidget {
  final double width;
  final double height;
  final String assetPath;
  final String? networkFallback;
  final Color gradientStart;
  final Color gradientEnd;

  const _RoundedImage({
    required this.width,
    required this.height,
    required this.assetPath,
    this.networkFallback,
    required this.gradientStart,
    required this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientEnd.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _buildImageContent(),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    try {
      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          if (networkFallback != null) {
            return Image.network(
              networkFallback!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    color: gradientEnd,
                  ),
                );
              },
            );
          }
          return Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, color: gradientEnd, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Gambar tidak tersedia',
                  style: TextStyle(color: gradientEnd),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Text(
          'Error: $e',
          style: TextStyle(color: gradientEnd),
        ),
      );
    }
  }
}