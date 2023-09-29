class SurahFavorite {
  int? id;
  int? userId;
  int? surahId;
  String? controller;

  SurahFavorite({
    this.id,
    this.userId,
    this.surahId,
  });

  factory SurahFavorite.fromJson(Map<String, dynamic> json) => SurahFavorite(
        id: json["id"],
        userId: json["user_id"],
        surahId: json["surah_id"],
      );
}
