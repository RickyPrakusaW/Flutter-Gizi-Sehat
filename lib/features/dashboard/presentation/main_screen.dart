/// Halaman utama aplikasi dengan bottom navigation
/// Mengatur navigasi antara halaman-halaman utama (Beranda, Tumbuh, Gizi, Asisten, Profil)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routing/route_names.dart';
import '../pages/dashboard_page.dart';
import '../pages/growth_page.dart';
import '../pages/nutrition_page.dart';
import '../../assistant/presentation/pages/assistant_page.dart';
import '../../profile/presentation/pages/profile_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home_filled),
      label: AppStrings.homeNav,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.trending_up_outlined),
      activeIcon: Icon(Icons.trending_up),
      label: AppStrings.growthNav,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_outlined),
      activeIcon: Icon(Icons.restaurant),
      label: AppStrings.nutritionNav,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.smart_toy_outlined),
      activeIcon: Icon(Icons.smart_toy),
      label: AppStrings.assistantNav,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outlined),
      activeIcon: Icon(Icons.person),
      label: AppStrings.profileNav,
    ),
  ];

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);

    final routeNames = [
      RouteNames.home,
      RouteNames.growth,
      RouteNames.nutrition,
      RouteNames.assistant,
      RouteNames.profile,
    ];

    context.goNamed(routeNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: _navItems,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardPage();
      case 1:
        return const GrowthPage();
      case 2:
        return const NutritionPage();
      case 3:
        return const AssistantPage();
      case 4:
        return const ProfilePage();
      default:
        return const DashboardPage();
    }
  }
}
