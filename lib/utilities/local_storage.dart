import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future storeData({
    required String key,
    required Map<String, dynamic> data,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var stored = await prefs.setString(key, jsonEncode(data));
    return stored;
  }

  Future<Map<String, dynamic>> getData({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDateString = prefs.getString(key);
    Map<String, dynamic> data =
        userDateString != null ? Map.from(jsonDecode(userDateString)) : {};
    return data;
  }

  Future<bool> removeEverything() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
