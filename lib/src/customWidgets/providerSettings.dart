import 'package:flutter/material.dart';
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

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePref darkThemePref = DarkThemePref();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePref.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
          brightness: (isDarkTheme) ? Brightness.dark : Brightness.light,
          color: (isDarkTheme) ? Color(0xFF121212) : Colors.white),
      backgroundColor: (isDarkTheme) ? Colors.grey[900] : Colors.grey[200],
      scaffoldBackgroundColor: (isDarkTheme) ? Color(0xFF121212) : Colors.white,
      primaryColor: (isDarkTheme) ? Colors.white : Colors.black,
      accentColor: (isDarkTheme) ? Colors.greenAccent[400] : Colors.green,
      brightness: (isDarkTheme) ? Brightness.dark : Brightness.light,
      splashColor: Colors.transparent,
    );
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
  AdvancedSettingsPref savedLocationPref = AdvancedSettingsPref();
  int _locOption = 0;
  int get locationOption => _locOption;

  set locationOption(int value) {
    _locOption = value;
    savedLocationPref.setLocationOption(value);
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
