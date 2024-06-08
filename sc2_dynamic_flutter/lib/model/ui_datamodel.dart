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
  final int min;
  final int max;
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
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 1,
      labelName: json['label_name'] ?? 'Default Label',
      fieldTypeW: json['field_type_w'] ?? 'Default W',
      fieldTypeM: json['field_type_m'] ?? 'Default M',
      associatedColumnName:
          json['associated_column_name'] ?? 'Default Column Name',
      columnType: json['column_type'] ?? 'Default Column Type',
      required: json['required'] ?? 'No',
      enableUi: json['enabled_ui'] is int
          ? json['enabled_ui']
          : int.tryParse(json['enabled_ui'].toString()) ?? 1,
      listOptions: json['list_options'] ?? '',
      min: json['min'] is int
          ? json['min']
          : int.tryParse(json['min'].toString()) ?? 0,
      max: json['max'] is int
          ? json['max']
          : int.tryParse(json['max'].toString()) ?? 0,
      uiType: json['ui_type'] != null
          ? UiType.fromJson(json['ui_type'])
          : UiType.defaultUiType(),
    );
  }

  static Field defaultField() {
    return Field(
      id: 1,
      labelName: 'Default Label',
      fieldTypeW: 'Default W',
      fieldTypeM: 'Default M',
      associatedColumnName: 'Default Column Name',
      columnType: 'Default Column Type',
      required: 'No',
      enableUi: 1,
      listOptions: '',
      min: 255,
      max: 255,
      uiType: UiType.defaultUiType(),
    );
  }
}

class UiType {
  final String type;
  final String label;
  final String buttons;
  final String required;

  UiType({
    required this.type,
    required this.label,
    required this.buttons,
    required this.required,
  });

  factory UiType.fromJson(Map<String, dynamic> json) {
    return UiType(
      type: json['type'] ?? 'Default Type',
      label: json['label'] ?? 'Default Label',
      buttons: json['buttons'] ?? '',
      required: json['required'] ?? 'No',
    );
  }

  static UiType defaultUiType() {
    return UiType(
      type: 'Default Type',
      label: 'Default Label',
      buttons: '',
      required: 'No',
    );
  }
}
