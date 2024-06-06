import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sc2_dynamic_flutter/utils/prefs_handler.dart';

class Http {
  static String url = "http://192.168.126.123:3000";

  static getData() async {
    try {
      final res = await http.get(Uri.parse("${url}/parseExcelToJSON"));
      // print(res.body);
      if (res.statusCode == 200) {
        var resp_data = jsonDecode(res.body.toString());
        PrefsHandler.saveDataToLocal(resp_data["data"]);
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
