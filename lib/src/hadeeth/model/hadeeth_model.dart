// To parse this JSON data, do
//
//     final hadeethModel = hadeethModelFromJson(jsonString);

import 'dart:convert';

HadeethModel hadeethModelFromJson(String str) =>
    HadeethModel.fromJson(json.decode(str));

String hadeethModelToJson(HadeethModel data) => json.encode(data.toJson());

class HadeethModel {
  HadeethModel({
    required this.id,
    required this.title,
    required this.hadeeth,
    required this.attribution,
    required this.grade,
    required this.explanation,
    required this.hints,
    required this.categories,
    required this.translations,
  });

  String id;
  String title;
  String hadeeth;
  String attribution;
  String grade;
  String explanation;
  List<dynamic> hints;
  List<String> categories;
  List<String> translations;

  factory HadeethModel.fromJson(Map<String, dynamic> json) => HadeethModel(
        id: json["id"],
        title: json["title"],
        hadeeth: json["hadeeth"],
        attribution: json["attribution"],
        grade: json["grade"],
        explanation: json["explanation"],
        hints: List<dynamic>.from(json["hints"].map((x) => x)),
        categories: List<String>.from(json["categories"].map((x) => x)),
        translations: List<String>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "hadeeth": hadeeth,
        "attribution": attribution,
        "grade": grade,
        "explanation": explanation,
        "hints": List<dynamic>.from(hints.map((x) => x)),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "translations": List<dynamic>.from(translations.map((x) => x)),
      };
}
