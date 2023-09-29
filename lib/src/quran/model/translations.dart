class TranslationsOfVerse {
  TranslationsOfVerse({
    this.id,
    this.author,
    this.text,
  });

  int? id;
  Author? author;
  String? text;

  factory TranslationsOfVerse.fromJson(Map<String, dynamic> json) => TranslationsOfVerse(
        id: json["id"],
        author: Author.fromJson(json["author"]),
        text: json["text"],
      );
}

class Author {
  Author({
    this.id,
    this.name,
    this.description,
  });

  int? id;
  String? name;
  String? description;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );
}
