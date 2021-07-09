class QuranPicker {
  int number;
  String name;

  int numberOfAyahs;
  QuranPicker({
    this.number,
    this.name,
    this.numberOfAyahs,
  });

  factory QuranPicker.fromJson(Map<String, dynamic> json) {
    return QuranPicker(
      number: json['number'],
      name: json['name'],
      numberOfAyahs: json['numberOfAyahs'],
    );
  }
}
