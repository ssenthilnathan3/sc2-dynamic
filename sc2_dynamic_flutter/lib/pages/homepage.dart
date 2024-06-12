import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sc2_dynamic_flutter/utils/api_handler.dart';
import 'package:sc2_dynamic_flutter/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sc2_dynamic_flutter/model/ui_datamodel.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Field> _fields = [];
  bool _isLoading = true;
  String _title = '';

  Future<void> _fetchData() async {
    // Fetch data from API and store in SharedPreferences
    await Http.getData();

    // Retrieve data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    var jsonData = prefs.getString("ui_data");

    if (jsonData != null) {
      // print("Stored JSON data: $jsonData");
      try {
        final List<dynamic> jsonList = json.decode(jsonData);
        // print(jsonList);
        final List<Field> fields =
            jsonList.map((json) => Field.fromJson(json)).toList();
        setState(() {
          _fields = fields;
          _isLoading = false;
          if (fields.isNotEmpty) {
            _title = fields.first.id.toString(); // Assuming `id` is a String
          }
        });
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _postFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final formData = <String, dynamic>{};

    for (Field field in _fields) {
      final value = prefs.getString(field.id.toString());
      if (value != null) {
        formData[field.labelName] = value;
      }
    }

    try {
      var result = await Http.postData(formData, "drymatterresult");
      print(result);
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget buildFormField(Field field) {
    switch (field.uiType.type) {
      case 'button':
        return ElevatedButton(
          onPressed: () {
            _postFormData();
          },
          child: Text(field.uiType.label),
        );
      case 'dropdown':
        List<String> options = field.listOptions.contains(',')
            ? field.listOptions.split(',')
            : field.listOptions.split('/');
        return dropDownWidget(field.id, field.labelName, options);
      case 'textfield':
        return textFieldWidget(field.id, field.labelName, field.enableUi);
      default:
        return Container(); // Default to an empty container if type is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dry Matter Assessment'),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  return buildFormField(_fields[index]);
                },
              ),
            ),
    );
  }
}
