// To parse this JSON data, do
//
//     final hadeethsModel = hadeethsModelFromJson(jsonString);

import 'dart:convert';

HadeethsModel hadeethsModelFromJson(String str) =>
    HadeethsModel.fromJson(json.decode(str));

String hadeethsModelToJson(HadeethsModel data) => json.encode(data.toJson());

class HadeethsModel {
  HadeethsModel({
    required this.data,
    required this.meta,
  });

  List<Datum> data;
  Meta meta;

  factory HadeethsModel.fromJson(Map<String, dynamic> json) => HadeethsModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.translations,
  });

  String id;
  String title;
  List<String> translations;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        translations: List<String>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "translations": List<dynamic>.from(translations.map((x) => x)),
      };
}

class Meta {
  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.totalItems,
    required this.perPage,
  });

  String currentPage;
  int lastPage;
  int totalItems;
  String perPage;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        totalItems: json["total_items"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "total_items": totalItems,
        "per_page": perPage,
      };
}
