//Theme settings
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DarkThemePref {
  // ignore: constant_identifier_names
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, val);
  }

  setColor(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("COLOR", index);
  }

  Future<int> getColor() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("COLOR") ?? 0;
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
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
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 60.sp),
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: (isDarkTheme)
              ? SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark)
              : SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light),
          color: Color(0xFF1E555C)),
      backgroundColor: (isDarkTheme) ? Colors.grey : Color(0xFFF6F6F6),
      scaffoldBackgroundColor:
          (isDarkTheme) ? Color(0xFF191716) : Color(0xFFF6F6F6),
      primaryColor: (isDarkTheme) ? Colors.white : Colors.black,
      toggleableActiveColor: Color(0xFF1E555C),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFF1E555C),
        background: (isDarkTheme) ? Colors.grey[900] : Colors.grey[200],
        brightness: (isDarkTheme) ? Brightness.dark : Brightness.light,
        secondary: Color(0xFF1E555C),
        secondaryVariant: Color(0xFF389BA8),
      ),
      splashColor: Colors.transparent,
    );
  }
}
