import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sc2_dynamic_flutter/model/ui_datamodel.dart';
import 'package:sc2_dynamic_flutter/utils/api_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Field> _fields = [];
  var _jsonData;
  Future<void> _fetchData() async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    var jsonData = _preferences.getString('data');
    final List<dynamic> jsonList = json.decode(jsonData!);
    final List<Field> fields =
        jsonList.map((json) => Field.fromJson(json)).toList();

    setState(() {
      _fields = fields;
      _jsonData = jsonList;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Fetcher'),
      ),
      body: Center(
        child: _jsonData.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final field = _fields[index];
                  return ListTile(
                    title: Text(field.labelName),
                    subtitle: Text(
                        'Type: ${field.uiType.type}, Required: ${field.uiType.required}'),
                  );
                },
              ),
      ),
    );
  }
}
