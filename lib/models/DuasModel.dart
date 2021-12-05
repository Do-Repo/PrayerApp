class DuasModel {
  int id;
  String title;
  List<Sections> children;

  DuasModel({
    required this.id,
    required this.title,
    required this.children,
  });

  factory DuasModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DuasModel(
        id: json["id"],
        title: json["title"],
        children: json["children"]
            .map<Sections>((section) => Sections.fromJson(section))
            .toList());
  }
}

class Sections {
  int id;
  String title;
  List<Cases> children;
  Sections({
    required this.id,
    required this.title,
    required this.children,
  });
  factory Sections.fromJson(Map<String, dynamic> json) {
    return Sections(
        id: json["id"],
        title: json["title"],
        children: json["children"]
            .map<Cases>((cases) => Cases.fromJson(cases))
            .toList());
  }
}

class Cases {
  int id;
  String arabic;
  String english;
  String ref;
  Cases({
    required this.id,
    required this.arabic,
    required this.english,
    required this.ref,
  });
  factory Cases.fromJson(Map<String, dynamic> json) {
    return Cases(
        id: json["id"],
        arabic: json["arabic"],
        english: json["english"],
        ref: json["ref"]);
  }
}
