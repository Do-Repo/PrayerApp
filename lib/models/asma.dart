class Asma {
  String name;
  String transliteration;
  int number;
  String meaning;
  Asma({
    required this.name,
    required this.transliteration,
    required this.number,
    required this.meaning,
  });
  factory Asma.fromJson(Map<String, dynamic> map) {
    return Asma(
      name: map['name'] ?? '',
      transliteration: map['transliteration'] ?? '',
      number: map['number']?.toInt() ?? 0,
      meaning: map['en']['meaning'] ?? '',
    );
  }
}
