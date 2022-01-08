import 'package:application_1/screens/Settings/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// These settings work for pray assistant
class PrayerSettings extends ChangeNotifier {
  List<String> name = ["", "", "", ""];
  String rakaat = "";
  List<int> surah = [0, 0, 0, 0];
  Map<int, List<int>> ayahs = {
    0: [0, 0],
    1: [0, 0],
    2: [0, 0],
    3: [0, 0],
  };
  Map<int, List<int>> selectedAyahs = {
    0: [0, 0],
    1: [0, 0],
    2: [0, 0],
    3: [0, 0],
  };
  void changeRakaat(String sl) {
    rakaat = sl;
    notifyListeners();
  }

  void changeSelectedAyahs(int i, int begin, int end) {
    selectedAyahs.update(i, (value) => value = [begin, end]);
  }

  void changeIndex(int i, int index) {
    surah[i] = index;
    notifyListeners();
  }

  void changeName(int i, String nm) {
    name[i] = nm;
    notifyListeners();
  }

  void changeAyahs(int i, int begin, int end) {
    ayahs.update(i, (value) => value = [begin, end]);
    notifyListeners();
  }
}

//Quran ayah bookmark settings
class BookmarkPref {
  setBookmark(int index, int bookmark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("$index", bookmark);
  }

  Future<int> getBookmark(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("$index") ?? 0;
  }
}

//Theme settings
class DarkThemePref {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, val);
  }

  setColor(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("COLOR", index);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }

  Future<int> getColor() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("COLOR") ?? 0;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePref darkThemePref = DarkThemePref();
  bool _darkTheme = false;
  int _colorIndex = 0;
  bool get darkTheme => _darkTheme;
  int get color => _colorIndex;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePref.setDarkTheme(value);
    notifyListeners();
  }

  set color(int index) {
    _colorIndex = index;
    darkThemePref.setColor(index);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(
      bool isDarkTheme, BuildContext context, int colorIndex) {
    return ThemeData(
      appBarTheme: AppBarTheme(
          systemOverlayStyle: (isDarkTheme)
              ? SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark)
              : SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light),
          color: (isDarkTheme) ? Color(0xFF191716) : Color(0xFFFFFFFA)),
      backgroundColor: (isDarkTheme) ? Colors.grey[900] : Colors.grey[200],
      scaffoldBackgroundColor:
          (isDarkTheme) ? Color(0xFF191716) : Color(0xFFFFFFFA),
      primaryColor: (isDarkTheme) ? Colors.white : Colors.black,
      toggleableActiveColor: colorsList[colorIndex],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: colorsList[colorIndex],
        background: (isDarkTheme) ? Colors.grey[900] : Colors.grey[200],
        brightness: (isDarkTheme) ? Brightness.dark : Brightness.light,
        secondary: colorsList[colorIndex], //Color(0xFFE6AF2E)
      ),
      splashColor: Colors.transparent,
    );
  }
}

class SavedNotificationPref {
  static const SAVEDFAJR = "FAJR";
  static const SAVEDDHUHR = "DHUHR";
  static const SAVEDAASR = "AASR";
  static const SAVEDMAGHRIB = "MAGHRIB";
  static const SAVEDISHAA = "ISHAA";

  setFajrNotification(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SAVEDFAJR, value);
  }

  Future<bool> getFajr() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(SAVEDFAJR) ?? false;
  }

  setDhuhrNotification(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SAVEDDHUHR, value);
  }

  Future<bool> getDhuhr() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(SAVEDDHUHR) ?? true;
  }

  setAasrNotification(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SAVEDAASR, value);
  }

  Future<bool> getAasr() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(SAVEDAASR) ?? true;
  }

  setMaghribNotification(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SAVEDMAGHRIB, value);
  }

  Future<bool> getMaghrib() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(SAVEDMAGHRIB) ?? true;
  }

  setIshaaNotification(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SAVEDISHAA, value);
  }

  Future<bool> getIshaa() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(SAVEDISHAA) ?? true;
  }
}

class SavedNotificationProvider with ChangeNotifier {
  SavedNotificationPref savedNotificationPref = SavedNotificationPref();
  bool _fajr = false,
      _dhuhr = true,
      _aasr = true,
      _maghrib = true,
      _ishaa = true;
  bool get savedFajr => _fajr;
  bool get savedDhuhr => _dhuhr;
  bool get savedAasr => _aasr;
  bool get savedIshaa => _ishaa;
  bool get savedMaghrib => _maghrib;

  set savedFajr(bool value) {
    _fajr = value;
    savedNotificationPref.setFajrNotification(value);
    notifyListeners();
  }

  set savedDhuhr(bool value) {
    _dhuhr = value;
    savedNotificationPref.setDhuhrNotification(value);
    notifyListeners();
  }

  set savedAasr(bool value) {
    _aasr = value;
    savedNotificationPref.setAasrNotification(value);
    notifyListeners();
  }

  set savedMaghrib(bool value) {
    _maghrib = value;
    savedNotificationPref.setMaghribNotification(value);
    notifyListeners();
  }

  set savedIshaa(bool value) {
    _ishaa = value;
    savedNotificationPref.setIshaaNotification(value);
    notifyListeners();
  }
}

//Saved Location
class SavedLocationPref {
  static const SAVEDLAT = "SAVEDLAT";
  static const SAVEDLONG = "SAVEDLONG";

  setSavedLat(double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(SAVEDLAT, value);
  }

  setSavedLong(double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(SAVEDLONG, value);
  }

  Future<double> getSavedLat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(SAVEDLAT) ?? 31.857703797032215;
  }

  Future<double> getSavedLong() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(SAVEDLONG) ?? 10.190065624135018;
  }
}

class SavedLocationProvider with ChangeNotifier {
  SavedLocationPref savedLocationPref = SavedLocationPref();
  double _lat = 10.857703797032215;
  double _long = 10.190065624135018;
  double get savedLat => _lat;
  double get savedLong => _long;

  set savedLat(double value) {
    _lat = value;
    savedLocationPref.setSavedLat(value);
    notifyListeners();
  }

  set savedLong(double value) {
    _long = value;
    savedLocationPref.setSavedLong(value);
    notifyListeners();
  }
}

//Prayertimes calculation settings
class PrayertimesPref {
  static const PRAYERTIMESSETTINGS = "PRAYERTIMESSETTINGS";

  setPrayertimesSettings(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(PRAYERTIMESSETTINGS, value);
  }

  Future<int> getPrayertimeSettings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(PRAYERTIMESSETTINGS) ?? 3;
  }
}

class PrayertimesProvider with ChangeNotifier {
  PrayertimesPref prayertimesPref = PrayertimesPref();
  int _index = 3;
  int get timeSettings => _index;

  set timeSettings(int value) {
    _index = value;
    prayertimesPref.setPrayertimesSettings(value);
    notifyListeners();
  }
}

class AdvancedSettingsPref {
  static const ADVANCEDSETTINGS = "ADVANCEDSETTINGS";
  static const LANGUAGE = "LANGUAGE";
  setLanguage(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(LANGUAGE, value);
  }

  Future<int> getLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(LANGUAGE) ?? 0;
  }

  setLocationOption(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(ADVANCEDSETTINGS, value);
  }

  Future<int> getLocationOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(ADVANCEDSETTINGS) ?? 0;
  }
}

class AdvancedSettingsProvider extends ChangeNotifier {
  AdvancedSettingsPref advancedSettingsPref = AdvancedSettingsPref();
  int _locOption = 0;
  int _language = 0;
  int get locationOption => _locOption;
  int get languageOption => _language;

  set languageOption(int value) {
    _language = value;
    advancedSettingsPref.setLanguage(value);
    notifyListeners();
  }

  set locationOption(int value) {
    _locOption = value;
    advancedSettingsPref.setLocationOption(value);
    notifyListeners();
  }
}

// Recitation Settings
class RecitationPref {
  static const RECITATION = "RECITATION";

  setRecitation(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(RECITATION, value);
  }

  Future<String> getRecitation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(RECITATION) ?? "ar.alafasy";
  }
}

class RecitationProvider with ChangeNotifier {
  RecitationPref recitationPref = RecitationPref();
  String _recs = "ar.alafasy";
  String get recitation => _recs;

  set recitation(String str) {
    _recs = str;
    recitationPref.setRecitation(str);
    notifyListeners();
  }
}