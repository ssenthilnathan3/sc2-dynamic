import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sc2_dynamic_flutter/utils/prefs_handler.dart';

class Http {
  static String url = "http://192.168.23.123:3000";

  static Future<void> getData() async {
    try {
      final res = await http.get(Uri.parse("$url/parseExcelToJSON"));
      // print("Response status: ${res.statusCode}");
      // print("Raw response body: ${res.body}");

      if (res.statusCode == 200) {
        var rawData = res.body;
        var parsedJson = jsonDecode(rawData);

        if (parsedJson.containsKey('data') && parsedJson['data'] is List) {
          var dataList = parsedJson['data'] as List;

          PrefsHandler.saveDataToLocal("ui_data", jsonEncode(dataList));
        } else {
          print("Data format error: 'data' field is missing or not a list");
        }
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  static Future<String> postData(
      Map<String, dynamic> postData, String assessmentName) async {
    String result = '';
    try {
      final uri = Uri.parse('$url/postFormData/$assessmentName');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(postData);

      final res = await http.post(uri, headers: headers, body: body);

      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        result = 'Form Created Successfully';
      } else {
        result = 'Form Failed';
      }
    } catch (e) {
      result = 'Error: $e';
    }
    return result;
  }
}
