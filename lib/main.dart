import 'package:application_1/screens/Homepage.dart';
import 'package:application_1/src/customWidgets/ad_helper.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:application_1/src/customWidgets/notificationService.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  NotificationService().initNotification();
  await getCurrentAppTheme();
  await getCurrentRecitation();
  await getCurrentPrayerTimeSettings();
  await getAdvancedSettings();
  await getSavedLat();
  await getSavedLong();
  runApp(Provider.value(value: adState, builder: (context, child) => MyApp()));
}

DarkThemeProvider themeChanger = DarkThemeProvider();
RecitationProvider recitationChanger = RecitationProvider();
PrayertimesProvider prayertimesChanger = PrayertimesProvider();
SavedLocationProvider savedLocationChanger = SavedLocationProvider();
AdvancedSettingsProvider advancedSettingsChanger = AdvancedSettingsProvider();

Future<void> getAdvancedSettings() async {
  advancedSettingsChanger.locationOption =
      await advancedSettingsChanger.savedLocationPref.getLocationOption();
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
            builder: () => Column(
              children: [
                Expanded(
                  child: MaterialApp(
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      theme: Styles.themeData(themeChanger.darkTheme, context),
                      debugShowCheckedModeBanner: false,
                      home: HomePage(
                        optionIndex: value4.locationOption,
                      )),
                ),
                (banner != null)
                    ? Container(
                        color: Color(0xFFFFFFFA),
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
  const Wrapper({Key? key, required this.advancedSettingsProvider})
      : super(key: key);
  final AdvancedSettingsProvider advancedSettingsProvider;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with TickerProviderStateMixin {
  var _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: customAppbar(context, false, '', false),
      body: Container(
        child: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            LanguagePage(tabController: tabController),
            Container(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 300.sp,
                  ),
                  ListTile(
                    title: Text(
                      "Allow Location Access",
                      style: TextStyle(
                          fontSize: 55.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                        "We need to access your location or set it manually"),
                  ),
                  SizedBox(
                    height: 50.sp,
                  ),
                  SizedBox(
                    height: 200.h,
                  ),
                  TextButton(
                      onPressed: () {
                        tabController.animateTo(1);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 20.sp,
                            bottom: 20.sp,
                            left: 100.sp,
                            right: 100.sp),
                        child: Text(
                          "Allow Location Access",
                          style:
                              TextStyle(color: Colors.white, fontSize: 50.sp),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )),
                  SizedBox(
                    height: 100.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        children: [
          Icon(
            Icons.translate_outlined,
            size: 300.sp,
          ),
          ListTile(
            title: Text(
              "Choose Your Preffered Lanugage",
              style: TextStyle(fontSize: 55.sp, fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Please select your language"),
          ),
          SizedBox(
            height: 50.sp,
          ),
          Flexible(
            child: Container(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("English"),
                    subtitle: Text("English US"),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/usa.png"),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Nederlands"),
                    subtitle: Text("Nederlands NL"),
                    leading: RotatedBox(
                      quarterTurns: 3,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/france.png"),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Français "),
                    subtitle: Text("Français FR"),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/france.png"),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Deutsch "),
                    subtitle: Text("Deutsch DE"),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/germany.png"),
                    ),
                  ),
                ],
              ),
            )),
          ),
          SizedBox(
            height: 200.h,
          ),
          TextButton(
              onPressed: () {
                tabController.animateTo(1);
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: 20.sp, bottom: 20.sp, left: 300.sp, right: 300.sp),
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 50.sp),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
          SizedBox(
            height: 100.h,
          ),
        ],
      ),
    );
  }
}
