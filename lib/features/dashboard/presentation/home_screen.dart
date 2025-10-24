import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/growth_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/nutrition_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/assistant_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = const [
    DashboardPage(),  // Beranda
    GrowthPage(),     // Tumbuh
    NutritionPage(),  // Menu
    AssistantPage(),  // Asisten
    ProfilePage(),    // Profil
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ❗JANGAN hardcode AppColors.bg lagi
      backgroundColor: theme.scaffoldBackgroundColor,

      body: _pages[_currentIndex],

      // Bottom nav dibungkus container biar ada border top tipis.
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

          // ❗BIARKAN theme yang ngatur warna selected/unselected,
          // jadi jangan override selectedItemColor/unselectedItemColor lagi.

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
              icon: Icon(Icons.local_hospital_outlined),
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
