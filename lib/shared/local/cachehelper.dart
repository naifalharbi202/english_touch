import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData(key) {
    return sharedPreferences!.get(key);
  }

  // Sources added by user
  static getListData(key) {
    List<String>? data = sharedPreferences!.getStringList(key);
    return data;
  }

  // // Save Cards Data
  //   static Future<void> saveMapData(String key, Map<String, dynamic> data) async {
  //   await sharedPreferences!.setString(key, json.encode(data));
  // }

  // // Get Cards Data
  // static Map<String, dynamic>? getMapData(String key) {
  //   final jsonString = sharedPreferences!.getString(key);
  //   if (jsonString != null) {
  //     return json.decode(jsonString) as Map<String, dynamic>;
  //   }
  //   return null;
  // }

  static Map<String, dynamic>? getUserData(String key) {
    final jsonString = sharedPreferences!.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> saveUserData(
      String key, Map<String, dynamic> data) async {
    await sharedPreferences!.setString(key, json.encode(data));
  }

  // This method to make saving in shared prefrences easier
  static Future<bool> saveData({
    required key,
    required value,
  }) async {
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is List<String>)
      return await sharedPreferences!.setStringList(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> removeData(key) async {
    return await sharedPreferences!.remove(key);
  }
}
