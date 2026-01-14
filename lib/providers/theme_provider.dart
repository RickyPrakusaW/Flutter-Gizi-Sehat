/// Provider untuk mengatur tema aplikasi menggunakan Riverpod
/// Menyimpan preferensi tema ke local storage
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// Notifier untuk mengelola state tema aplikasi
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemePreference();
  }

  /// Memuat preferensi tema dari SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
      state = ThemeMode.values[themeIndex];
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  /// Mengubah tema aplikasi
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      state = themeMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
    } catch (e) {
      // Error handling untuk penyimpanan preferensi
    }
  }

  /// Toggle antara light dan dark theme
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newTheme);
  }
}
