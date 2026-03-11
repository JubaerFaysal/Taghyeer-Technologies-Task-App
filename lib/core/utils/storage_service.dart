import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences box;

  static Future<void> init() async {
    box = await SharedPreferences.getInstance();
  }

  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await box.setString('user_data', jsonEncode(userData));
  }

  static Map<String, dynamic>? getUser() {
    final data = box.getString('user_data');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  static Future<void> clearUser() async {
    await box.remove('user_data');
  }

  static bool isLoggedIn() {
    return box.getString('user_data') != null;
  }

  static Future<void> saveThemeMode(bool isDark) async {
    await box.setBool('is_dark_mode', isDark);
  }

  static bool getThemeMode() {
    return box.getBool('is_dark_mode') ?? false;
  }
}
