import 'package:shared_preferences/shared_preferences.dart';

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
}
