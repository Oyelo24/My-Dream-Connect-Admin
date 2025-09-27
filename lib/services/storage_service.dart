import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _usernameKey = 'username';
  static const String _roleKey = 'role';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _authTokenKey = 'authToken';

  static Future<void> saveUserData(String username, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_roleKey, role);
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_roleKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Token management methods
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_roleKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}
