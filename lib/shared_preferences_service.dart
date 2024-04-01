import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._();

  static SharedPreferencesService get instance => _instance!;

  static SharedPreferencesService? _instance;

  late final SharedPreferences _prefs;

  static Future<void> initialize() async {
    _instance ??= SharedPreferencesService._();
    _instance!._prefs = await SharedPreferences.getInstance();
  }

  Future<void> add(String key, Object? value) async {
    await _instance!._prefs.setString(key, jsonEncode(value));
  }

  dynamic get(String key) {
    return jsonDecode(_instance!._prefs.getString(key) ?? '');
  }

  Future<void> delete(String key) async {
    await _instance!._prefs.remove(key);
  }
}
