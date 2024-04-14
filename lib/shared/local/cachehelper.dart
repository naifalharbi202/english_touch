import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData(key) {
    return sharedPreferences!.get(key);
  }

  // This method to make saving in shared prefrences easier
  static Future<bool> saveData({
    required key,
    required value,
  }) async {
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> removeData(key) async {
    return await sharedPreferences!.remove(key);
  }
}
