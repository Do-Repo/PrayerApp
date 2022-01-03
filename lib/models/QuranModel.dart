class QuranPicker {
  int number;
  String name;
  int numberOfAyahs;
  String relevationType;
  String englishName;
  String englishNameTranslation;

  QuranPicker({
    required this.number,
    required this.name,
    required this.numberOfAyahs,
    required this.relevationType,
    required this.englishName,
    required this.englishNameTranslation,
  });

  factory QuranPicker.fromJson(Map<String, dynamic> json) {
    return QuranPicker(
      number: json['number'],
      name: json['name'],
      numberOfAyahs: json['numberOfAyahs'],
      relevationType: json['revelationType'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
    );
  }
}

class QuranAR {
  String audio;
  String ayah;
  QuranAR({
    required this.audio,
    required this.ayah,
  });

  factory QuranAR.fromJson(Map<String, dynamic> json) {
    return QuranAR(
      audio: json['audio'],
      ayah: json['text'],
    );
  }
}

class QuranEN {
  String? ayah;

  QuranEN({this.ayah});

  factory QuranEN.fromJson(Map<String, dynamic> json) {
    return QuranEN(
      ayah: json['text'],
    );
  }
}
