import 'package:shared_preferences/shared_preferences.dart';

class PrefsHandler {
  static Future<void> saveDataToLocal(key, data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key.toString(), data.toString());
  }

  static Future<String?> getDataFromLocal(key) async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    return data;
  }
}
