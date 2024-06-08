import 'package:flutter/material.dart';
import 'package:sc2_dynamic_flutter/utils/prefs_handler.dart';

Widget textFieldWidget(int id, String label, int enabled) {
  final TextEditingController controller = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
        onChanged: (value) => PrefsHandler.saveDataToLocal(id, value),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.black87, fontSize: 17, fontFamily: 'AvenirLight'),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 216, 216, 216)),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        style: const TextStyle(
            color: Colors.black87, fontSize: 17, fontFamily: 'AvenirLight'),
        controller: controller,
        enabled: true ? enabled == 1 : false),
  );
}

Widget dropDownWidget(int id, String labelName, List<String> options) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelName),
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        PrefsHandler.saveDataToLocal(id, newValue!);
      },
    ),
  );
}
