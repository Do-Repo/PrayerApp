class HadithListing {
  String bookname;
  int bookid;
  bool onError;
  HadithListing({
    required this.onError,
    required this.bookname,
    required this.bookid,
  });
  factory HadithListing.fromJson(Map<String, dynamic> json, bool onError) {
    return HadithListing(
        onError: onError, bookid: json['Book_ID'], bookname: json['Book_Name']);
  }
}

class HadithChapter {
  String chapter;
  int chapterid;
  bool onError;
  HadithChapter({
    required this.onError,
    required this.chapter,
    required this.chapterid,
  });
  factory HadithChapter.fromJson(Map<String, dynamic> json, bool onError) {
    return HadithChapter(
        onError: onError,
        chapter: json['Chapter_Name'],
        chapterid: json['Chapter_ID']);
  }
}

class HadithsEN {
  int hadithid;
  String text;
  String sanad;
  bool onError;
  HadithsEN({
    required this.hadithid,
    required this.onError,
    required this.text,
    required this.sanad,
  });
  factory HadithsEN.fromJson(Map<String, dynamic> json, bool onError) {
    return HadithsEN(
        onError: onError,
        hadithid: json['Hadith_ID'],
        text: json['En_Text'],
        sanad: json['En_Sanad']);
  }
}

class HadithsAR {
  int hadithid;
  String text;
  String sanad;
  bool onError;
  HadithsAR({
    required this.hadithid,
    required this.text,
    required this.sanad,
    required this.onError,
  });
  factory HadithsAR.fromJson(Map<String, dynamic> json, bool onError) {
    return HadithsAR(
        onError: onError,
        hadithid: json['Hadith_ID'],
        text: json['Ar_Text'],
        sanad: json['Ar_Sanad_1']);
  }
}
