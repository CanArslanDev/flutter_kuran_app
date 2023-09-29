class Surah {
  int? number;
  String? name;
  int? numberOfVerses;
  String? nameOriginal;
  String? controller;
  Surah({
    this.number,
    this.name,
    this.numberOfVerses,
    this.nameOriginal,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var surah = Surah();
    surah.number = json['id'];
    surah.name = json['name'];
    surah.numberOfVerses = json['verse_count'];
    surah.nameOriginal = json['name_original'];
    return surah;
  }
}

class NameSurah {
  String? arab;
  String? id;
  String? en;
  String? translationEn;
  String? translationId;
  NameSurah(
      {this.arab, this.id, this.en, this.translationEn, this.translationId});

  factory NameSurah.fromJson(Map<String, dynamic> json) {
    return NameSurah(
      arab: json['short'],
      en: json['transliteration']['en'],
      id: json['transliteration']['id'],
      translationEn: json['translation']['en'],
      translationId: json['translation']['id'],
    );
  }
}

class Revelation {
  String? arab;
  String? en;
  String? id;

  Revelation({this.arab, this.id, this.en});

  factory Revelation.fromJson(Map<String, dynamic> json) {
    return Revelation(
      arab: json['arab'],
      en: json['en'],
      id: json['id'],
    );
  }
}
