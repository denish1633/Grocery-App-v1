import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _prefs;
  static const String _tokenKey = 'auth_token';

  /// Initialize SharedPreferences (call this in main before runApp)
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save token
  static Future<void> setToken(String token) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_tokenKey, token);
  }

  /// Get token asynchronously
  static Future<String?> getToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString(_tokenKey);
  }

  /// Get token synchronously (only works after init)
  static String? getTokenSync() {
    return _prefs?.getString(_tokenKey);
  }

  /// Remove token
  static Future<void> removeToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_tokenKey);
  }

  /// Check if a token exists
  static Future<bool> hasToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.containsKey(_tokenKey);
  }
}
