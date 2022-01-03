import 'dart:async';
import 'dart:convert';
import 'package:application_1/models/AsmaModel.dart';
import 'package:application_1/models/DuasModel.dart';
import 'package:application_1/models/HadithModel.dart';
import 'package:application_1/models/PrayerTimeCard.dart';
import 'package:application_1/models/QuranModel.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:application_1/models/RandomVerse.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Gets one verse
Future<RandomVerse?> getVerse(String r, int x, AudioPlayer audioPlayer) async {
  final result = await http
      .get(Uri.parse("http://api.alquran.cloud/v1/ayah/${x.toString()}/$r"));

  var data = jsonDecode(result.body);
  if (result.statusCode == 200) {
    int results = await audioPlayer.setUrl(data['data']['audio']);

    if (results == 1) {
      return RandomVerse.fromJson(jsonDecode(result.body));
    }
  } else
    return RandomVerse();
}

// PrayerTimes card information
Future<CardModel?> getCardReady(
    int timeStamp, double latitude, double longitude, int index) async {
  List<Placemark> placemark =
      await placemarkFromCoordinates(latitude, longitude);
  final result = await http.get(Uri.parse(
      "http://api.aladhan.com/v1/timings/${timeStamp.toString().substring(0, 10)}?latitude=${latitude.toString()}&longitude=${longitude.toString()}&method=${index.toString()}"));
  if (result.statusCode == 200) {
    return CardModel.fromJson(jsonDecode(result.body), placemark.first.locality,
        placemark.first.administrativeArea, placemark.first.country);
  } else {
    return null;
  }
}

// Get saved Location
Future<Position> getSavedLocation() async {
  print("Getting saved location");
  // Test if location services are enabled.
  var serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
    }
  }
  Position location = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true) ??
      Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
  return location;
}

Future<Position> getChosenLocation(BuildContext context) async {
  print("Getting chosen location");
  var pos = Provider.of<SavedLocationProvider>(context, listen: true);
  return Position(
      longitude: pos.savedLong,
      latitude: pos.savedLat,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
}

// Get live Location
Future<Position> getLiveLocation() async {
  print('Get live location');
  // Test if location services are enabled.
  var serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
    }
  }
  Position location;
  try {
    location = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    ).timeout(Duration(seconds: 20));
  } on TimeoutException {
    location = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true,
        ) ??
        Position(
            longitude: 0,
            latitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0);
  }

  return Position(
      longitude: location.longitude,
      latitude: location.latitude,
      timestamp: location.timestamp,
      accuracy: location.accuracy,
      altitude: location.altitude,
      heading: location.heading,
      speed: location.speed,
      speedAccuracy: location.speedAccuracy);
}

Future<List<Asma>> getNames() async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  String cachedResult = pref.getString("AsmaHusna") ?? "";
  try {
    final result =
        await http.get(Uri.parse("https://api.aladhan.com/asmaAlHusna"));
    if (result.statusCode == 200) {
      pref.setString("AsmaHusna", result.body);
      List jsonResponse = json.decode(result.body)['data'];
      return jsonResponse.map((data) => Asma.fromJson(data)).toList();
    } else
      throw Exception();
  } catch (err) {
    print("Error in Asma $err");
    if (cachedResult.isNotEmpty) {
      List cachedResponse = json.decode(cachedResult)['data'];
      return cachedResponse.map((e) => Asma.fromJson(e)).toList();
    } else
      throw Exception();
  }
}

// Get ayahs
Future<List<QuranAR>> getAyahAR(int surahNumber, String str) async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  String cachedResult = pref.getString("getAyahAR$surahNumber") ?? "";
  try {
    final result = await http
        .get(Uri.parse("http://api.alquran.cloud/v1/surah/$surahNumber/$str"));
    if (result.statusCode == 200) {
      pref.setString("getAyahAR$surahNumber", result.body);
      List jsonResponse = json.decode(result.body)['data']['ayahs'];
      return jsonResponse.map((data) => new QuranAR.fromJson(data)).toList();
    } else
      throw Exception();
  } catch (err) {
    print("Error in getAyahAR$surahNumber: $err");
    if (cachedResult.isNotEmpty) {
      List cachedResponse = json.decode(cachedResult)['data']['ayahs'];
      return cachedResponse.map((data) => QuranAR.fromJson(data)).toList();
    } else {
      throw Exception("failed to connect");
    }
  }
}

Future<List<QuranEN>> getAyahEN(int surahNumber) async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  String cachedResult = pref.getString("getAyahEN$surahNumber") ?? "";
  try {
    final result = await http.get(
        Uri.parse("http://api.alquran.cloud/v1/surah/$surahNumber/en.asad"));
    if (result.statusCode == 200) {
      pref.setString("getAyahEN$surahNumber", result.body);
      List jsonResponse = json.decode(result.body)['data']['ayahs'];
      return jsonResponse.map((data) => new QuranEN.fromJson(data)).toList();
    } else
      throw Exception();
  } catch (err) {
    print("Error in getAyahEN$surahNumber: $err");
    if (cachedResult.isNotEmpty) {
      List cachedResponse = json.decode(cachedResult)['data']['ayahs'];
      return cachedResponse.map((data) => QuranEN.fromJson(data)).toList();
    } else {
      throw Exception("failed to connect");
    }
  }
}

Future<List<QuranPicker>> getSurahTitles() async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  String cachedResult = pref.getString("getSurahTitles") ?? "";
  try {
    final result =
        await http.get(Uri.parse("http://api.alquran.cloud/v1/surah"));
    if (result.statusCode == 200) {
      pref.setString("getSurahTitles", result.body);
      List jsonResponse = json.decode(result.body)['data'];
      return jsonResponse
          .map((data) => new QuranPicker.fromJson(data))
          .toList();
    } else
      throw Exception();
  } catch (err) {
    print("Error in getSurahTitles: $err");
    if (cachedResult.isNotEmpty) {
      List cachedResponse = json.decode(cachedResult)['data'];
      return cachedResponse.map((data) => QuranPicker.fromJson(data)).toList();
    } else
      throw Exception("failed to connect");
  }
}

Future<List<Hadiths>> getHadith(
    int bookid, int chapterid, bool isArabic) async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  String cachedResultAR = pref.getString("getHadithAR$bookid.$chapterid") ?? "";
  String cachedResultEN = pref.getString("getHadithEN$bookid.$chapterid") ?? "";
  try {
    final result = await http.get(Uri.parse((isArabic)
        ? "https://ahadith-api.herokuapp.com/api/ahadith/$bookid/$chapterid/ar-tashkeel"
        : "https://ahadith-api.herokuapp.com/api/ahadith/$bookid/$chapterid/en"));
    if (result.statusCode == 200) {
      (isArabic)
          ? pref.setString("getHadithAR$bookid.$chapterid", result.body)
          : pref.setString("getHadithEN$bookid.$chapterid", result.body);
      List jsonResponse = json.decode(result.body)['Chapter'];
      return jsonResponse
          .map((data) => new Hadiths.fromJson(data, isArabic))
          .toList();
    } else
      throw Exception();
  } catch (err) {
    print("Error in getHadith: $err");
    if ((isArabic && cachedResultAR.isNotEmpty) ||
        (!isArabic && cachedResultEN.isNotEmpty)) {
      List cachedResponse =
          json.decode((isArabic) ? cachedResultAR : cachedResultEN)['Chapter'];
      return cachedResponse
          .map((data) => Hadiths.fromJson(data, isArabic))
          .toList();
    } else
      throw Exception(err);
  }
}

Future<List<HadithChapter>> getHadithChapter(int bookid, bool isArabic) async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  String cachedResultAR = pref.getString("getHadithChapterAR$bookid") ?? "";
  String cachedResultEN = pref.getString("getHadithChapterEN$bookid") ?? "";
  try {
    final result = await http.get(isArabic
        ? Uri.parse("https://ahadith-api.herokuapp.com/api/chapter/$bookid/ar")
        : Uri.parse(
            "https://ahadith-api.herokuapp.com/api/chapter/$bookid/en"));
    if (result.statusCode == 200) {
      (isArabic)
          ? pref.setString('getHadithChapterAR$bookid', result.body)
          : pref.setString('getHadithChapterEN$bookid', result.body);
      List jsonResponse = json.decode(result.body)['Chapter'];
      return jsonResponse
          .map((data) => new HadithChapter.fromJson(data))
          .toList();
    } else
      throw Exception();
  } catch (err) {
    if ((isArabic && cachedResultAR.isNotEmpty) ||
        (!isArabic && cachedResultEN.isNotEmpty)) {
      List cachedResponse =
          json.decode((isArabic) ? cachedResultAR : cachedResultEN)['Chapter'];
      return cachedResponse
          .map((data) => HadithChapter.fromJson(data))
          .toList();
    } else
      throw Exception(err);
  }
}

Future<List<DuasModel>> getDuas(BuildContext context) async {
  String data =
      await DefaultAssetBundle.of(context).loadString("assets/duas.json");
  List jsonResponse = json.decode(data)["Daily"];
  return jsonResponse.map((data) => new DuasModel.fromJson(data)).toList();
}

Future<List<HadithListing>> getHadithList(bool isArabic) async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  String cachedResultAR = pref.getString("getHadithListAR") ?? "";
  String cachedResultEN = pref.getString("getHadithListEN") ?? "";
  try {
    final result = await http.get(isArabic
        ? Uri.parse("https://ahadith-api.herokuapp.com/api/books/ar")
        : Uri.parse("https://ahadith-api.herokuapp.com/api/books/en"));
    if (result.statusCode == 200) {
      (isArabic)
          ? pref.setString('getHadithListAR', result.body)
          : pref.setString('getHadithListEN', result.body);
      List jsonResponse = json.decode(result.body)['Books'];
      return jsonResponse
          .map((data) => new HadithListing.fromJson(data))
          .toList();
    } else
      throw Exception();
  } catch (err) {
    if ((isArabic && cachedResultAR.isNotEmpty) ||
        (!isArabic && cachedResultEN.isNotEmpty)) {
      List cachedResponse =
          json.decode((isArabic) ? cachedResultAR : cachedResultEN)['Books'];
      return cachedResponse
          .map((data) => HadithListing.fromJson(data))
          .toList();
    } else
      throw Exception(err);
  }
}

List<String> nameEn = [
  "Abdul Basit",
  "Abdullah Basfar",
  "Abdurrahmaan As-Sudais",
  "Abu Bakr Ash-Shaatree",
  "Ahmed ibn Ali al-Ajamy",
  "Alafasy",
  "Hani Rifai",
  "Husary",
  "Hudhaify",
  "Ibrahim Akhdar",
  "Maher Al Muaiqly",
  "Minshawi",
  "Muhammad Ayyoub",
  "Muhammad Jibreel",
  "Saood bin Ibraaheem Ash-Shuraym",
];
List<String> imageUrls = [
  "assets/images/abdulbasit.jpg",
  "assets/images/abdullah-basfar.jpg",
  "assets/images/soudaisi.jpg",
  "assets/images/shtari.jpg",
  "assets/images/ajmi.jpg",
  "assets/images/Mishary.jpg",
  "assets/images/hani.jpg",
  "assets/images/mahmoudkhalil.jpg",
  "assets/images/Alhuzaify.jpg",
  "assets/images/akhdar.jpg",
  "assets/images/maher.jpg",
  "assets/images/mnshawi.jpg",
  "assets/images/medayoub.jpg",
  "assets/images/jibril.jpg",
  "assets/images/saoudsharim.jpg",
];
List<String> identifiers = [
  "ar.abdulbasitmurattal",
  "ar.abdullahbasfar",
  "ar.abdurrahmaansudais",
  "ar.shaatree",
  "ar.ahmedajamy",
  "ar.alafasy",
  "ar.hanirifai",
  "ar.husary",
  "ar.hudhaify",
  "ar.ibrahimakhbar",
  "ar.mahermuaiqly",
  "ar.minshawi",
  "ar.muhammadayyoub",
  "ar.muhammadjibreel",
  "ar.saoodshuraym",
];
List<String> nameAr = [
  "عبد الباسط عبد الصمد المرتل",
  "عبد الله بصفر",
  "عبدالرحمن السديس",
  "أبو بكر الشاطري",
  "أحمد بن علي العجمي",
  "مشاري العفاسي",
  "هاني الرفاعي",
  "محمود خليل الحصري",
  "علي بن عبدالرحمن الحذيفي",
  "إبراهيم الأخضر",
  "ماهر المعيقلي",
  "محمد صديق المنشاوي",
  "محمد أيوب",
  "محمد جبريل",
  "سعود بن ابراهيم الشريم",
];
