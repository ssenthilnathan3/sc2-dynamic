import 'package:flutter/material.dart';

Widget textFieldWidget(data) {
  final TextEditingController controller = TextEditingController();

  return TextFormField(
      decoration: InputDecoration(
        labelText: data["label_name"],
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
      initialValue: "",
      enabled: true ? data["enable_ui"] == 1 : false);
}

Widget dropDownWidget(data) {
  var value = "";
  return DropdownButton(
      value: value,
      items: data["list_options"],
      onChanged: (val) {
        value = val!;
      });
}
