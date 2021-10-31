import 'package:application_1/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChanger = DarkThemeProvider();
  RecitationProvider recitationChanger = RecitationProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getCurrentRecitation();
  }

  void getCurrentRecitation() async {
    recitationChanger.recitation =
        await recitationChanger.recitationPref.getRecitation();
  }

  void getCurrentAppTheme() async {
    themeChanger.darkTheme = await themeChanger.darkThemePref.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChanger;
          },
        ),
        ChangeNotifierProvider(create: (_) {
          return recitationChanger;
        })
      ],
      child: Consumer2<DarkThemeProvider, RecitationProvider>(
        builder: (BuildContext context, value, value2, child) {
          return ScreenUtilInit(
            designSize: Size(1080, 2160),
            builder: () => MaterialApp(
                theme: Styles.themeData(themeChanger.darkTheme, context),
                debugShowCheckedModeBanner: false,
                home: HomePage()),
          );
        },
      ),
    );
  }
}

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
  String _recitation = "ar.alafasy";
  String get recitation => _recitation;

  set recitation(String str) {
    _recitation = str;
    recitationPref.setRecitation(str);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
          brightness: (isDarkTheme) ? Brightness.dark : Brightness.light,
          color: (isDarkTheme) ? Colors.black : Colors.white),
      backgroundColor: (isDarkTheme) ? Colors.grey[850] : Colors.grey[200],
      scaffoldBackgroundColor: (isDarkTheme) ? Colors.black : Colors.white,
      primaryColor: (isDarkTheme) ? Colors.white : Colors.black,
      accentColor: Colors.green,
      brightness: (isDarkTheme) ? Brightness.dark : Brightness.light,
    );
  }
}
