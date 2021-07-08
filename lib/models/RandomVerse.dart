class RandomVerse {
  int number;
  String audioUrl;
  String audioName;
  String surahNameAR;
  String surahNameEN;
  int numberOfAyah;
  int ayahsInSurah;
  String ayahText;
  RandomVerse({
    this.number,
    this.audioUrl,
    this.audioName,
    this.surahNameAR,
    this.surahNameEN,
    this.numberOfAyah,
    this.ayahsInSurah,
    this.ayahText,
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
    );
  }
}
