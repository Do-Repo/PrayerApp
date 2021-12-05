import 'package:application_1/screens/Homepage.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChanger = DarkThemeProvider();
  RecitationProvider recitationChanger = RecitationProvider();
  PrayertimesProvider prayertimesChanger = PrayertimesProvider();
  SavedLocationProvider savedLocationChanger = SavedLocationProvider();
  AdvancedSettingsProvider advancedSettingsChanger = AdvancedSettingsProvider();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getCurrentRecitation();
    getCurrentPrayerTimeSettings();
    getAdvancedSettings();
    getSavedLat();
    getSavedLong();
  }

  void getAdvancedSettings() async {
    advancedSettingsChanger.locationOption =
        await advancedSettingsChanger.savedLocationPref.getLocationOption();
  }

  void getCurrentRecitation() async {
    recitationChanger.recitation =
        await recitationChanger.recitationPref.getRecitation();
  }

  void getSavedLat() async {
    savedLocationChanger.savedLat =
        await savedLocationChanger.savedLocationPref.getSavedLat();
  }

  void getSavedLong() async {
    savedLocationChanger.savedLong =
        await savedLocationChanger.savedLocationPref.getSavedLong();
  }

  void getCurrentPrayerTimeSettings() async {
    prayertimesChanger.timeSettings =
        await prayertimesChanger.prayertimesPref.getPrayertimeSettings();
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
          return prayertimesChanger;
        }),
        ChangeNotifierProvider(create: (_) {
          return recitationChanger;
        }),
        ChangeNotifierProvider(create: (_) {
          return advancedSettingsChanger;
        }),
        ChangeNotifierProvider(create: (_) {
          return savedLocationChanger;
        })
      ],
      child: Consumer4<DarkThemeProvider, RecitationProvider,
          PrayertimesProvider, AdvancedSettingsProvider>(
        builder: (BuildContext context, value, value2, value3, value4, child) {
          return ScreenUtilInit(
            designSize: Size(1080, 2160),
            builder: () => MaterialApp(
                theme: Styles.themeData(themeChanger.darkTheme, context),
                debugShowCheckedModeBanner: false,
                home: HomePage(
                  optionIndex: value4.locationOption,
                )),
          );
        },
      ),
    );
  }
}
