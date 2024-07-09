// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

List<ConfigModel> configModelFromJson(String str) => List<ConfigModel>.from(
    json.decode(str).map((x) => ConfigModel.fromJson(x)));

String configModelToJson(List<ConfigModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConfigModel {
  dynamic date;
  List<String> breakfast;
  List<String> lunch;
  List<String> dinner;
  bool grub;

  ConfigModel(
      {required this.date,
      required this.breakfast,
      required this.lunch,
      required this.dinner,
      required this.grub});

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        date: json["date"],
        grub: json["grub"],
        breakfast: List<String>.from(json["breakfast"].map((x) => x)),
        lunch: List<String>.from(json["lunch"].map((x) => x)),
        dinner: List<String>.from(json["dinner"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "grub": grub,
        "date": date,
        "breakfast": List<dynamic>.from(breakfast.map((x) => x)),
        "lunch": List<dynamic>.from(lunch.map((x) => x)),
        "dinner": List<dynamic>.from(dinner.map((x) => x)),
      };
  @override
  String toString() {
    return '{ grub:$grub ,date: $date, breakfast: $breakfast, lunch: $lunch, dinner: $dinner }';
  }
}
