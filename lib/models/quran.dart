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

class RandomVerse {
  int? number;
  String? audioUrl;
  String? audioName;
  String? surahNameAR;
  String? surahNameEN;
  int? numberOfAyah;
  int? ayahsInSurah;
  String? ayahText;
  int? numberOfSurah;
  RandomVerse({
    this.number,
    this.audioUrl,
    this.audioName,
    this.surahNameAR,
    this.surahNameEN,
    this.numberOfAyah,
    this.ayahsInSurah,
    this.ayahText,
    this.numberOfSurah,
  });

  factory RandomVerse.fromJson(Map<String, dynamic> json) {
    return RandomVerse(
      audioUrl: json['data']['audio'],
      audioName: json['data']['edition']['name'],
      number: json['data']['number'],
      surahNameEN: json['data']['surah']['englishName'],
      surahNameAR: json['data']['surah']['name'],
      numberOfAyah: json['data']['numberInSurah'],
      ayahsInSurah: json['data']['surah']['numberOfAyahs'],
      ayahText: json['data']['text'],
      numberOfSurah: json['data']['surah']['number'],
    );
  }
}
