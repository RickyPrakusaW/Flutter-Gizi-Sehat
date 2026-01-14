import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class FirstTimePrefs {
  static const String _key = 'first_time_user';

  /// Check if this is the first time the app is launched
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  /// Mark that the app has been launched before
  static Future<void> markNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
  }

  static const String _keyFirstTime = 'first_time_user';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  /// Check apakah ini first time user membuka app
  // static Future<bool> isFirstTime() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     return prefs.getBool(_keyFirstTime) ?? true;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('[FirstTimePrefs Error] isFirstTime: $e');
  //     }
  //     return true; // Default ke first time jika error
  //   }
  // }
  //
  // /// Mark bahwa user sudah membuka app sebelumnya
  // static Future<void> markNotFirstTime() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setBool(_keyFirstTime, false);
  //     if (kDebugMode) {
  //       print('[FirstTimePrefs] User marked as not first time');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('[FirstTimePrefs Error] markNotFirstTime: $e');
  //     }
  //   }
  // }

  /// Check apakah onboarding sudah completed
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyOnboardingCompleted) ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('[FirstTimePrefs Error] isOnboardingCompleted: $e');
      }
      return false;
    }
  }

  /// Mark onboarding sebagai completed
  static Future<void> markOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyOnboardingCompleted, true);
      if (kDebugMode) {
        print('[FirstTimePrefs] Onboarding marked as completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[FirstTimePrefs Error] markOnboardingCompleted: $e');
      }
    }
  }

  /// Reset semua preferences (untuk testing atau logout)
  static Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFirstTime, true);
      await prefs.setBool(_keyOnboardingCompleted, false);
      if (kDebugMode) {
        print('[FirstTimePrefs] All preferences reset');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[FirstTimePrefs Error] reset: $e');
      }
    }
  }
}
