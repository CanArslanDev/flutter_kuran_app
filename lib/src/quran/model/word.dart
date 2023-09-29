class Word{

  Word({
    this.sortNumber,
    this.transcription,
    this.turkish,
    this.root,
  });

  int? sortNumber;
  String? transcription;
  String? turkish;
  String? root;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
      sortNumber: json["sort_number"],
      transcription: json["transcription"],
      turkish: json["turkish"],
      root: json["root"] != null ? json["root"]["arabic"] : "",
  );
}