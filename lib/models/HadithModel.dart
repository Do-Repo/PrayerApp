class HadithListing {
  String bookname;
  int bookid;
  HadithListing({
    required this.bookname,
    required this.bookid,
  });
  factory HadithListing.fromJson(Map<String, dynamic> json) {
    return HadithListing(bookid: json['Book_ID'], bookname: json['Book_Name']);
  }
}

class HadithChapter {
  String chapter;
  int chapterid;
  HadithChapter({
    required this.chapter,
    required this.chapterid,
  });
  factory HadithChapter.fromJson(Map<String, dynamic> json) {
    return HadithChapter(
        chapter: json['Chapter_Name'], chapterid: json['Chapter_ID']);
  }
}

class HadithsEN {
  int hadithid;
  String text;
  String sanad;
  HadithsEN({
    required this.hadithid,
    required this.text,
    required this.sanad,
  });
  factory HadithsEN.fromJson(Map<String, dynamic> json) {
    return HadithsEN(
        hadithid: json['Hadith_ID'],
        text: json['En_Text'],
        sanad: json['En_Sanad']);
  }
}

class HadithsAR {
  int hadithid;
  String text;
  String sanad;
  HadithsAR({
    required this.hadithid,
    required this.text,
    required this.sanad,
  });
  factory HadithsAR.fromJson(Map<String, dynamic> json) {
    return HadithsAR(
        hadithid: json['Hadith_ID'],
        text: json['Ar_Text'],
        sanad: json['Ar_Sanad_1']);
  }
}
