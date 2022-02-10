import 'dart:async';
import 'dart:ffi';
import 'package:application_1/screens/SettingsPage/AdsService.dart';
import 'package:application_1/screens/SettingsPage/AdvancedSettings.dart';
import 'package:flutter/material.dart';
import 'package:application_1/screens/AsmaHusna/Asma.dart';
import 'package:application_1/screens/HadithPage/HadithList.dart';
import 'package:application_1/screens/HomePage/HomePageLayout.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:application_1/screens/QuranPage/QuranList.dart';
import 'package:application_1/screens/SettingsPage/Settingspage.dart';
import 'package:application_1/screens/SibhahPage/Sibhah.dart';
import 'package:application_1/screens/SupportScreen/paymentService.dart';
import 'package:application_1/src/advancedSettings.dart';
import 'package:application_1/src/themeData.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String selectedNotificationPayload = "";
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/muslim');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.payload ?? "";
  }
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  bool ft = await getiffirsttime();
  await getCurrentAppTheme();
  await getCurrentRecitation();
  await getCurrentPrayerTimeSettings();
  await getLocationOption();
  await getSavedLat();
  await getSavedLong();
  await getSavedNotification();
  await initPlatformState();
  await FlutterLocalNotificationsPlugin().initialize(
    initializationSettings,
    onSelectNotification: (payload) {
      print(payload);
      selectedNotificationPayload = payload ?? "";
    },
  );
  runApp(Provider.value(
      value: adState,
      builder: (context, child) => MyApp(
            isfirsttime: ft,
            payload: selectedNotificationPayload,
          )));
}

DarkThemeProvider themeChanger = DarkThemeProvider();
AdvancedSettingsProvider settingChanger = AdvancedSettingsProvider();
SavedLocationProvider locationChanger = SavedLocationProvider();

Future<bool> getiffirsttime() async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  return pref.getBool("Firsttime") ?? true;
}

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.payload, required this.isfirsttime})
      : super(key: key);
  final String payload;
  final bool isfirsttime;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  home: (widget.payload.isEmpty)
                      ? (widget.isfirsttime)
                          ? Intro()
                          : Skeleton()
                      : AccessedByNotifPage(
                          payload: widget.payload,
                        ),
                ));
      }),
    );
  }
}

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    var option = Provider.of<AdvancedSettingsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "Welcome to IslamApp",
              style: TextStyle(
                  fontSize: 80.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              "Everything you need in one app",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 300.h,
          ),
          Icon(
            Icons.location_on_outlined,
            color: Colors.white,
            size: 200.sp,
          ),
          Center(
            child: Text(
              "Set your location",
              style: TextStyle(
                  fontSize: 80.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
          ListTile(
            title: Text(
              "Allow automatic location",
              style: TextStyle(color: Colors.white, fontSize: 40.sp),
            ),
            subtitle: Text(
              "Look up location on startup automatically",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            tileColor: Colors.white.withOpacity(0.4),
            onTap: () async {
              option.locationOption = 0;
              Permission.locationWhenInUse.request();
              await Permission.locationWhenInUse.status.then((status) async {
                if (status.isGranted) {
                  print("status granted");
                  await setFirsttimeoff();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Skeleton()));
                }
                if (status.isDenied) {
                  Permission.locationWhenInUse.request();
                }
                if (status.isRestricted || status.isPermanentlyDenied) {
                  Permission.locationWhenInUse.isRestricted;
                  await openAppSettings();
                }
                await setFirsttimeoff();
                Future.delayed(Duration(milliseconds: 200)).then((value) =>
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => Skeleton())));
              });
            },
          ),
          SizedBox(
            height: 50.h,
          ),
          ListTile(
            tileColor: Colors.white.withOpacity(0.4),
            title: Text(
              "Set location manually",
              style: TextStyle(color: Colors.white, fontSize: 40.sp),
            ),
            subtitle: Text(
              "Look up saved location on startup",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onTap: () async {
              option.locationOption = 2;
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MapInterface()));
            },
          ),
          Spacer(),
          InkWell(
            onTap: () async {
              await setFirsttimeoff();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Skeleton()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 60.sp),
                ),
                Center(
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 80.sp,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> setFirsttimeoff() async {
  SharedPreferences pref;
  pref = await SharedPreferences.getInstance();
  pref.setBool("Firsttime", false);
}

class AccessedByNotifPage extends StatefulWidget {
  const AccessedByNotifPage({Key? key, required this.payload})
      : super(key: key);
  final String payload;

  @override
  State<AccessedByNotifPage> createState() => _AccessedByNotifPageState();
}

class _AccessedByNotifPageState extends State<AccessedByNotifPage> {
  late BannerAd? banner;

  @override
  void initState() {
    super.initState();
    banner = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    if (!appData.isPro) {
      adState.initialization.then((value) {
        setState(() {
          banner = BannerAd(
              size: AdSize.banner,
              adUnitId: adState.homeBannerAd,
              listener: adState.bannerAdListener,
              request: AdRequest())
            ..load();
        });
      });
    }
  }

  @override
  void dispose() {
    banner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Column(children: [
        (widget.payload == "Test notification")
            ? Text(
                "This is a test notification",
                style: TextStyle(
                    fontSize: 80.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              )
            : Text(
                "It's time to pray ${widget.payload}",
                style: TextStyle(
                    fontSize: 80.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
        Divider(
          color: Colors.grey,
        ),
        (widget.payload == "Test notification")
            ? Text(
                "You can ignore this widget",
                style: TextStyle(color: Colors.white),
              )
            : Text(
                "Hayya 'ala-s-Salah - Hurry to the prayer",
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
        (widget.payload == "Fajr")
            ? Text(
                "Assalatu khairum-minan-naum - Prayer is better than sleep",
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              )
            : Container(),
        Spacer(),
        (banner != null && !appData.isPro)
            ? Container(
                child: AdWidget(
                  ad: banner!,
                ),
                height: banner!.size.height.toDouble(),
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              margin: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => Skeleton()));
                  },
                  child: Text(
                    "Homepage",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        )
      ]),
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
    return WillPopScope(
      onWillPop: () {
        setState(() {
          tabController.jumpToPage(0);
          currentIndex = 0;
        });

        return Future.value(false);
      },
      child: Scaffold(
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
      ),
    );
  }
}

Future<void> initPlatformState() async {
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.setup("goog_ZBoncTHoaOtuPxDhDsGEWjjQttq");
  PurchaserInfo purchaserInfo;
  try {
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
  } catch (err) {}

  print("User is pro: ${appData.isPro}");
}
