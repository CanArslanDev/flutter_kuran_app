class Verse {
  Verse({
    this.surahName,
    this.verseNumber,
    this.verse,
    this.page,
    this.juzNumber,
    this.transcription,
    this.translation,
    this.surahId,
  });

  // verse_number, verse, transcription, translation["text"]
  String? surahName;
  int? verseNumber;
  String? verse;
  int? page;
  int? juzNumber;
  String? transcription;
  Translation? translation;
  int? surahId;

  factory Verse.fromJson(Map<String, dynamic> json, String surahName) => Verse(
        surahName: surahName,
        verseNumber: json["verse_number"],
        verse: json["verse"],
        page: json["page"],
        juzNumber: json["juzNumber"],
        transcription: json["transcription"],
        translation: Translation.fromJson(json["translation"]),
        surahId: json["surah_id"]
      );
}

class Audio {
  Audio({
    this.primary,
    this.secondary,
  });

  String? primary;
  List<String>? secondary;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        primary: json["primary"],
        secondary: List<String>.from(json["secondary"].map((x) => x)),
      );
}

class Meta {
  Meta({
    this.juz,
    this.page,
    this.manzil,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  int? juz;
  int? page;
  int? manzil;
  int? ruku;
  int? hizbQuarter;
  // Sajda? sajda;
  bool? sajda;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        juz: json["juz"],
        page: json["page"],
        manzil: json["manzil"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
        // sajda: Sajda.fromJson(
        //   json["sajda"],
        // ),
        sajda: json["sajda"],
      );
}

// class Sajda {
//     Sajda({
//         this.recommended,
//         this.obligatory,
//     });

//     bool? recommended;
//     bool? obligatory;

//     factory Sajda.fromJson(Map<String, dynamic> json) => Sajda(
//         recommended: json["recommended"],
//         obligatory: json["obligatory"],
//     );
// }

class Number {
  Number({
    this.inQuran,
    this.inSurah,
  });

  int? inQuran;
  int? inSurah;

  factory Number.fromJson(Map<String, dynamic> json) => Number(
        inQuran: json["inQuran"],
        inSurah: json["inSurah"],
      );
}

class Tafsir {
  Tafsir({
    this.id,
  });

  Id? id;

  factory Tafsir.fromJson(Map<String, dynamic> json) => Tafsir(
        id: Id.fromJson(json["id"]),
      );
}

class Id {
  Id({
    this.short,
    this.long,
  });

  String? short;
  String? long;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        short: json["short"],
        long: json["long"],
      );

  Map<String, dynamic> toJson() => {
        "short": short,
        "long": long,
      };
}

class TextVerse {
  TextVerse({
    this.arab,
    this.transliteration,
  });

  String? arab;
  Transliteration? transliteration;

  factory TextVerse.fromJson(Map<String, dynamic> json) => TextVerse(
        arab: json["arab"],
        transliteration: Transliteration.fromJson(json["transliteration"]),
      );
}

class Transliteration {
  Transliteration({
    this.en,
  });

  String? en;

  factory Transliteration.fromJson(Map<String, dynamic> json) =>
      Transliteration(
        en: json["en"],
      );
}

class Translation {
  Translation({
    this.id,
    this.text,
    this.author,
  });

  int? id;
  String? text;
  String? author;

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["id"],
        text: json["text"],
    author: json["author"]["name"]
      );
}
