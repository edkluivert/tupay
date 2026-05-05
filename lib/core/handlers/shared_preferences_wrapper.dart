import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tupay/core/logger/app_logger.dart';

/// Shared Preferences Stores Wrapper used for storing / caching data.

class SharedPreferencesWrapper {
  SharedPreferencesWrapper(this._preferences);

  final SharedPreferences _preferences;

  String? getString(String key) => _preferences.getString(key);

  Future<String> setString(String key, String value) async {
    await _preferences.setString(key, value);
    return value;
  }

  Future<Map<String, dynamic>?> getMap(String key) async {
    try {
      final map = getString(key);
      return map == null ? null : json.decode(map) as Map<String, dynamic>;
    } catch (e, st) {
      AppLogger.e( st);
      return null;
    }
  }

  Future<Map<String, dynamic>?> setMap(
    String key,
    Map<String, dynamic> value,
  ) async {
    await setString(key, json.encode(value));
    return value;
  }


  int? getInt(String key) => _preferences.getInt(key);

  Future<int> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
    return value;
  }

  bool? getBool(String key) {
    final value = _preferences.getBool(key);
    AppLogger.i('SharedPreferences getBool: $key = $value');
    return value;
  }

  Future<bool> setBool({
    required String key,
    required bool value,
}) async {
    await _preferences.setBool(key, value);
    AppLogger.i('SharedPreferences setBool: $key = $value');
    return value;
  }

  bool contains(String key) => _preferences.containsKey(key);

  Future<bool> remove(String key) => _preferences.remove(key);

  Future<bool> clear() => _preferences.clear();
}

class SharedPrefsKey {
  const SharedPrefsKey._();

  static const String appState = 'appState';
  static const String firstTimer = 'firstTimer';
  static const String login = 'login';

}
