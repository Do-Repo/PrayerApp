import 'dart:convert';
import 'package:application_1/models/HadithModel.dart';
import 'package:application_1/models/PrayerTimeCard.dart';
import 'package:application_1/models/QuranModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:application_1/models/RandomVerse.dart';

// Gets one verse
Future<RandomVerse?> getVerse(String r, int x, AudioPlayer audioPlayer) async {
  print("http://api.alquran.cloud/v1/ayah/${x.toString()}/$r");
  final result = await http
      .get(Uri.parse("http://api.alquran.cloud/v1/ayah/${x.toString()}/$r"));

  var data = jsonDecode(result.body);
  if (result.statusCode == 200) {
    int results = await audioPlayer.setUrl(data['data']['audio']);

    if (results == 1) {
      return RandomVerse.fromJson(jsonDecode(result.body));
    }
  } else {
    print("error");
    return null;
  }
}

// PrayerTimes card information
Future<CardModel?> getCardReady(
    int timeStamp, double latitude, double longitude) async {
  List<Placemark> placemark =
      await placemarkFromCoordinates(latitude, longitude);

  final result = await http.get(Uri.parse(
      "http://api.aladhan.com/v1/timings/${timeStamp.toString().substring(0, 10)}?latitude=${latitude.toString()}&longitude=${longitude.toString()}&method=2"));
  if (result.statusCode == 200) {
    return CardModel.fromJson(jsonDecode(result.body), placemark.first.locality,
        placemark.first.administrativeArea, placemark.first.country);
  } else {
    return null;
  }
}

Future<List<QuranAR>> getAyahAR(int surahNumber, String str) async {
  final result = await http
      .get(Uri.parse("http://api.alquran.cloud/v1/surah/$surahNumber/$str"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data']['ayahs'];
    return jsonResponse.map((data) => new QuranAR.fromJson(data)).toList();
  } else {
    return <QuranAR>[];
  }
}

Future<List<QuranEN>> getAyahEN(int surahNumber) async {
  print(surahNumber);
  final result = await http
      .get(Uri.parse("http://api.alquran.cloud/v1/surah/$surahNumber/en.asad"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data']['ayahs'];

    return jsonResponse.map((data) => new QuranEN.fromJson(data)).toList();
  } else {
    return <QuranEN>[];
  }
}

Future<List<QuranPicker>> getSurahTitles() async {
  final result = await http.get(Uri.parse("http://api.alquran.cloud/v1/surah"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data'];
    return jsonResponse.map((data) => new QuranPicker.fromJson(data)).toList();
  } else {
    print("error");
  }
  return <QuranPicker>[];
}

Future<List<HadithChapter>> getHadithChapter(int bookid, bool isArabic) async {
  final result = await http.get(isArabic
      ? Uri.parse("https://ahadith-api.herokuapp.com/api/chapter/$bookid/ar")
      : Uri.parse("https://ahadith-api.herokuapp.com/api/chapter/$bookid/en"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['Chapter'];
    return jsonResponse
        .map((data) => new HadithChapter.fromJson(data))
        .toList();
  } else {
    print("error");
  }
  return <HadithChapter>[];
}

Future<List<HadithListing>> getHadithList(bool isArabic) async {
  final result = await http.get(isArabic
      ? Uri.parse("https://ahadith-api.herokuapp.com/api/books/ar")
      : Uri.parse("https://ahadith-api.herokuapp.com/api/books/en"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['Books'];
    return jsonResponse
        .map((data) => new HadithListing.fromJson(data))
        .toList();
  } else {
    print("error");
  }
  return <HadithListing>[];
}
