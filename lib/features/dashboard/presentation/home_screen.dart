import 'package:flutter/material.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/child_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/moms_page.dart';
import 'package:gizi_sehat_mobile_app/features/dashboard/presentation/pages/assistant_page.dart';
import 'package:gizi_sehat_mobile_app/features/doctor/presentation/pages/doctor_list_screen.dart';

/// Screen utama dengan bottom navigation bar
/// Mengatur 5 halaman utama: Beranda, Child, Moms, Asisten, Komunitas
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Index tab yang sedang aktif
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
        const ChildPage(),
        const MomsPage(),
        const AssistantPage(),
        const DoctorListScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor ??
              theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
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
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.child_care),
              label: 'Child',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pregnant_woman),
              label: 'Moms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              label: 'Asisten',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'Konsultasi',
            ),
          ],
        ),
      ),
    );
  }
}
