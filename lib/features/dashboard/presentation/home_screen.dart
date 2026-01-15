import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/growth_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/nutrition_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/assistant_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/profile_page.dart';

/// Screen utama dengan bottom navigation bar
/// Mengatur 5 halaman utama: Beranda, Tumbuh, Menu, Asisten, Profil
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Index tab yang sedang aktif (0=Beranda, 1=Tumbuh, 2=Menu, 3=Asisten, 4=Profil)
  int _currentIndex = 0;

  /// List semua halaman yang ditampilkan berdasarkan tab
  List<Widget> get _pages => [
    DashboardPage(
      onNavigateToTab: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    const GrowthPage(),
    const NutritionPage(),
    const AssistantPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor ??
              theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_outlined),
              label: 'Tumbuh',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              label: 'Asisten',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
