import 'package:application_1/screens/Homepage.dart';
import 'package:application_1/screens/IntroScreens/DarkMode.dart';
import 'package:application_1/screens/IntroScreens/Language.dart';
import 'package:application_1/screens/IntroScreens/Location.dart';
import 'package:application_1/screens/Settings/AdvancedSettings.dart';
import 'package:application_1/src/customWidgets/ad_helper.dart';
import 'package:application_1/src/customWidgets/notificationService.dart';
import 'package:application_1/src/customWidgets/payment_service.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  NotificationService().initNotification();
  await getCurrentAppTheme();
  await getCurrentRecitation();
  await getCurrentPrayerTimeSettings();
  await getLocationOption();
  await getSavedLat();
  await getSavedLong();
  await getSavedNotification();
  await initPlatformState();
  await getLanguageOption();
  runApp(Provider.value(value: adState, builder: (context, child) => MyApp()));
}

DarkThemeProvider themeChanger = DarkThemeProvider();
RecitationProvider recitationChanger = RecitationProvider();
PrayertimesProvider prayertimesChanger = PrayertimesProvider();
SavedLocationProvider savedLocationChanger = SavedLocationProvider();
AdvancedSettingsProvider advancedSettingsChanger = AdvancedSettingsProvider();
SavedNotificationProvider savedNotificationChanger =
    SavedNotificationProvider();

Future<void> getSavedNotification() async {
  savedNotificationChanger.savedFajr =
      await savedNotificationChanger.savedNotificationPref.getFajr();
  savedNotificationChanger.savedDhuhr =
      await savedNotificationChanger.savedNotificationPref.getDhuhr();
  savedNotificationChanger.savedAasr =
      await savedNotificationChanger.savedNotificationPref.getAasr();
  savedNotificationChanger.savedMaghrib =
      await savedNotificationChanger.savedNotificationPref.getMaghrib();
  savedNotificationChanger.savedIshaa =
      await savedNotificationChanger.savedNotificationPref.getIshaa();
}

Future<void> getLanguageOption() async {
  advancedSettingsChanger.languageOption =
      await advancedSettingsChanger.advancedSettingsPref.getLanguage();
}

Future<void> getLocationOption() async {
  advancedSettingsChanger.locationOption =
      await advancedSettingsChanger.advancedSettingsPref.getLocationOption();
}

Future<void> getCurrentRecitation() async {
  recitationChanger.recitation =
      await recitationChanger.recitationPref.getRecitation();
}

Future<void> getSavedLat() async {
  savedLocationChanger.savedLat =
      await savedLocationChanger.savedLocationPref.getSavedLat();
}

Future<void> getSavedLong() async {
  savedLocationChanger.savedLong =
      await savedLocationChanger.savedLocationPref.getSavedLong();
}

Future<void> getCurrentPrayerTimeSettings() async {
  prayertimesChanger.timeSettings =
      await prayertimesChanger.prayertimesPref.getPrayertimeSettings();
}

Future<void> getCurrentAppTheme() async {
  themeChanger.darkTheme = await themeChanger.darkThemePref.getTheme();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChanger;
          },
        ),
        ChangeNotifierProvider(create: (_) {
          return savedNotificationChanger;
        }),
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
      child: Consumer5<
          DarkThemeProvider,
          RecitationProvider,
          PrayertimesProvider,
          AdvancedSettingsProvider,
          SavedNotificationProvider>(
        builder: (BuildContext context, value, value2, value3, value4, value5,
            child) {
          return ScreenUtilInit(
            designSize: Size(1080, 2160),
            builder: () => Column(
              children: [
                Expanded(
                  child: MaterialApp(
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      theme: Styles.themeData(themeChanger.darkTheme, context),
                      debugShowCheckedModeBanner: false,
                      locale: Locale.fromSubtags(
                          languageCode: languageList[value4.languageOption]),
                      home: Wrapper(
                        optionIndex: value4.locationOption,
                      )),
                ),
                (banner != null && !appData.isPro)
                    ? Container(
                        color: Colors.white,
                        child: AdWidget(
                          ad: banner!,
                        ),
                        height: banner!.size.height.toDouble(),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key, required this.optionIndex}) : super(key: key);
  final int optionIndex;
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    var advancedSettingsProvider =
        Provider.of<AdvancedSettingsProvider>(context, listen: false);
    return FutureBuilder(
      future: checkIfFirstTime(false),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return Container();
        if (snapshot.hasError)
          return Container();
        else {
          if (snapshot.data!) {
            return Intro(
              advancedSettingsProvider: advancedSettingsProvider,
              optionIndex: widget.optionIndex,
            );
          } else {
            return HomePage(optionIndex: widget.optionIndex);
          }
        }
      },
    );
  }
}

class Intro extends StatefulWidget {
  const Intro(
      {Key? key,
      required this.optionIndex,
      required this.advancedSettingsProvider})
      : super(key: key);
  final int optionIndex;
  final AdvancedSettingsProvider advancedSettingsProvider;

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    var pageController = PageController(initialPage: 0, keepPage: true);
    return WillPopScope(
      onWillPop: () {
        pageController.previousPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              LanguagePage(pageController: pageController),
              LocationPage(pageController: pageController),
              DarkModePage(
                pageController: pageController,
                optionIndex: widget.optionIndex,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkIfFirstTime(bool end) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (!end) {
    return pref.getBool("Firsttime") ?? true;
  } else {
    pref.setBool("Firsttime", false);
    return false;
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
