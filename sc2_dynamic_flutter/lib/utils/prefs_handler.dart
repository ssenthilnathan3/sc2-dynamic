import 'package:shared_preferences/shared_preferences.dart';

class PrefsHandler {
  static void saveDataToLocal(data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("ui_data", data);
  }
}
