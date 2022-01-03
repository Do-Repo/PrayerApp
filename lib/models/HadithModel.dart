class HadithListing {
  String bookname;
  int bookid;
  HadithListing({
    required this.bookname,
    required this.bookid,
  });
  factory HadithListing.fromJson(
    Map<String, dynamic> json,
  ) {
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

class Hadiths {
  int hadithid;
  String text;
  String sanad;
  Hadiths({
    required this.hadithid,
    required this.text,
    required this.sanad,
  });
  factory Hadiths.fromJson(Map<String, dynamic> json, bool isArabic) {
    return Hadiths(
        hadithid: json['Hadith_ID'],
        text: json[(isArabic) ? 'Ar_Text' : 'En_Text'],
        sanad: json[(isArabic) ? 'Ar_Sanad_1' : 'En_Sanad']);
  }
}
