import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AdvancedSettingsPref {
  // ignore: constant_identifier_names
  static const ADVANCEDSETTINGS = "ADVANCEDSETTINGS";
  static const PRAYERTIMESSETTINGS = "PRAYERTIMESSETTINGS";
  static const RECITATION = "RECITATION";
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

  setRecitation(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(RECITATION, value);
  }

  Future<String> getRecitation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(RECITATION) ?? "ar.alafasy";
  }

  setPrayertimesSettings(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(PRAYERTIMESSETTINGS, value);
  }

  Future<int> getPrayertimeSettings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(PRAYERTIMESSETTINGS) ?? 3;
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

  String _recs = "ar.alafasy";
  String get recitation => _recs;
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
    advancedSettingsPref.setFajrNotification(value);
    notifyListeners();
  }

  set savedDhuhr(bool value) {
    _dhuhr = value;
    advancedSettingsPref.setDhuhrNotification(value);
    notifyListeners();
  }

  set savedAasr(bool value) {
    _aasr = value;
    advancedSettingsPref.setAasrNotification(value);
    notifyListeners();
  }

  set savedMaghrib(bool value) {
    _maghrib = value;
    advancedSettingsPref.setMaghribNotification(value);
    notifyListeners();
  }

  set savedIshaa(bool value) {
    _ishaa = value;
    advancedSettingsPref.setIshaaNotification(value);
    notifyListeners();
  }

  set recitation(String str) {
    _recs = str;
    advancedSettingsPref.setRecitation(str);
    notifyListeners();
  }

  int _index = 3;
  int get timeSettings => _index;

  set timeSettings(int value) {
    _index = value;
    advancedSettingsPref.setPrayertimesSettings(value);
    notifyListeners();
  }

  int _locOption = 0;
  int get locationOption => _locOption;

  set locationOption(int value) {
    _locOption = value;
    advancedSettingsPref.setLocationOption(value);
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

Future<Position> getLocation(int optionIndex, SavedLocationProvider pos) {
  if (optionIndex == 0) {
    return getLiveLocation();
  } else {
    return getChosenLocation(pos);
  }
}

Future<Position> getChosenLocation(SavedLocationProvider pos) async {
  print("Getting chosen location");
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
