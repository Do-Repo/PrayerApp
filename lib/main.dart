import 'dart:async';
import 'package:flutter/material.dart';
import 'package:application_1/screens/AsmaHusna/Asma.dart';
import 'package:application_1/screens/HadithPage/HadithList.dart';
import 'package:application_1/screens/HomePage/HomePageLayout.dart';
import 'package:application_1/screens/QuranPage/QuranList.dart';
import 'package:application_1/screens/SettingsPage/Settingspage.dart';
import 'package:application_1/screens/SibhahPage/Sibhah.dart';
import 'package:application_1/screens/SupportScreen/paymentService.dart';
import 'package:application_1/src/advancedSettings.dart';
import 'package:application_1/src/themeData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await getCurrentAppTheme();
  await getCurrentRecitation();
  await getCurrentPrayerTimeSettings();
  await getLocationOption();
  await getSavedLat();
  await getSavedLong();
  await getSavedNotification();
  await initPlatformState();
  runApp(MyApp());
}

DarkThemeProvider themeChanger = DarkThemeProvider();
AdvancedSettingsProvider settingChanger = AdvancedSettingsProvider();
SavedLocationProvider locationChanger = SavedLocationProvider();

Future<void> getSavedNotification() async {
  settingChanger.savedFajr =
      await settingChanger.advancedSettingsPref.getFajr();
  settingChanger.savedDhuhr =
      await settingChanger.advancedSettingsPref.getDhuhr();
  settingChanger.savedAasr =
      await settingChanger.advancedSettingsPref.getAasr();
  settingChanger.savedMaghrib =
      await settingChanger.advancedSettingsPref.getMaghrib();
  settingChanger.savedIshaa =
      await settingChanger.advancedSettingsPref.getIshaa();
}

Future<void> getLocationOption() async {
  settingChanger.locationOption =
      await settingChanger.advancedSettingsPref.getLocationOption();
}

Future<void> getCurrentRecitation() async {
  settingChanger.recitation =
      await settingChanger.advancedSettingsPref.getRecitation();
}

Future<void> getSavedLat() async {
  locationChanger.savedLat =
      await locationChanger.savedLocationPref.getSavedLat();
}

Future<void> getSavedLong() async {
  locationChanger.savedLong =
      await locationChanger.savedLocationPref.getSavedLong();
}

Future<void> getCurrentPrayerTimeSettings() async {
  settingChanger.timeSettings =
      await settingChanger.advancedSettingsPref.getPrayertimeSettings();
}

Future<void> getCurrentAppTheme() async {
  themeChanger.darkTheme = await themeChanger.darkThemePref.getTheme();
  themeChanger.color = await themeChanger.darkThemePref.getColor();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChanger;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return settingChanger;
          },
        ),
        ChangeNotifierProvider(create: (_) {
          return locationChanger;
        })
      ],
      child: Consumer2<DarkThemeProvider, AdvancedSettingsProvider>(
          builder: (context, value1, value2, child) {
        return ScreenUtilInit(
            designSize: Size(1080, 2160),
            builder: () => MaterialApp(
                  builder: (context, widget) {
                    ScreenUtil.setContext(context);
                    return MediaQuery(
                        data:
                            MediaQuery.of(context).copyWith(textScaleFactor: 1),
                        child: widget!);
                  },
                  theme: Styles.themeData(
                      themeChanger.darkTheme, context, themeChanger.color),
                  debugShowCheckedModeBanner: false,
                  home: Skeleton(),
                ));
      }),
    );
  }
}

class Skeleton extends StatefulWidget {
  const Skeleton({Key? key}) : super(key: key);

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  late PageController tabController;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: const [
                Homepage(),
                QuranList(),
                HadithList(),
                Sibhah(),
                AsmaHosna(),
                SettingsScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          tabController.jumpToPage(value);
          currentIndex = value;
        }),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            label: "Timings",
            icon: Icon(Icons.timer_sharp),
          ),
          BottomNavigationBarItem(
            label: "Qur'an",
            icon: Icon(
              customIcon.MyFlutterApp.quran_1,
              size: 70.sp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Hadith",
            icon: Icon(
              customIcon.MyFlutterApp.prophet,
              size: 70.sp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Tasbeeh",
            icon: Icon(
              customIcon.MyFlutterApp.beads_1,
              size: 70.sp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Asma Husna",
            icon: Icon(
              customIcon.MyFlutterApp.allah,
              size: 70.sp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(
              Icons.settings_outlined,
              size: 70.sp,
            ),
          )
        ],
      ),
    );
  }
}

Future<void> initPlatformState() async {
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.setup("goog_ZBoncTHoaOtuPxDhDsGEWjjQttq");
  PurchaserInfo purchaserInfo;
  purchaserInfo = await Purchases.getPurchaserInfo();

  print("Purchaser info : ${purchaserInfo.toString()}");

  if (purchaserInfo.entitlements.all['1mNoAds'] != null) if (purchaserInfo
      .entitlements.all['1mNoAds']!.isActive) {
    appData.isPro = true;
    print("true 1");
  }
  if (purchaserInfo.entitlements.all['3mNoAds'] != null) if (purchaserInfo
      .entitlements.all["3mNoAds"]!.isActive) {
    appData.isPro = true;
    print("true 2");
  }
  if (purchaserInfo.entitlements.all["12mNoAds"] != null) if (purchaserInfo
      .entitlements.all["12mNoAds"]!.isActive) {
    appData.isPro = true;
    print("true 3");
  }

  print("User is pro: ${appData.isPro}");
}
