import 'dart:convert';

class Field {
  final int id;
  final String labelName;
  final String fieldTypeW;
  final String fieldTypeM;
  final String associatedColumnName;
  final String columnType;
  final String required;
  final int enableUi;
  final String listOptions;
  final String min;
  final String max;
  final UiType uiType;

  Field({
    required this.id,
    required this.labelName,
    required this.fieldTypeW,
    required this.fieldTypeM,
    required this.associatedColumnName,
    required this.columnType,
    required this.required,
    required this.enableUi,
    required this.listOptions,
    required this.min,
    required this.max,
    required this.uiType,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      labelName: json['label_name'],
      fieldTypeW: json['field_type_w'],
      fieldTypeM: json['field_type_m'],
      associatedColumnName: json['associated_column_name'],
      columnType: json['column_type'],
      required: json['required'],
      enableUi: json['enable_ui'],
      listOptions: json['list_options'],
      min: json['min'],
      max: json['max'],
      uiType: UiType.fromJson(json['ui_type']),
    );
  }
}

class UiType {
  final String type;
  final String label;
  final String listOptions;
  final String required;

  UiType({
    required this.type,
    required this.label,
    required this.listOptions,
    required this.required,
  });

  factory UiType.fromJson(Map<String, dynamic> json) {
    return UiType(
      type: json['type'],
      label: json['label'],
      listOptions: json['list_options'],
      required: json['required'],
    );
  }
}
