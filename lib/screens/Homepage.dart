import 'dart:ffi';

import 'package:application_1/screens/AsmaHosna.dart';
import 'package:application_1/screens/DuasAndAzkar/Duas.dart';
import 'package:application_1/screens/HadithPage/HadithList.dart';
import 'package:application_1/screens/Quranpage/QuranList.dart';
import 'package:application_1/screens/Sibhah.dart';
import 'package:application_1/src/cards/PrayerTimes/CardLoading.dart' as pt;
import 'package:application_1/src/cards/PrayerTimes/CardStructure.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/animator.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:application_1/src/customWidgets/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:application_1/src/cards/AyahCard/CardStructure.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:application_1/src/customWidgets/ad_helper.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageEffects effects = HomePageEffects();
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var calculMethod = Provider.of<PrayertimesProvider>(context);
    var timeSettings =
        context.select((AdvancedSettingsProvider asp) => asp.locationOption);
    return ChangeNotifierProvider(
      create: (_) {
        return effects;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: Container(
                margin: EdgeInsets.all(20.sp),
                width: 1.sw,
                color: Colors.black,
                child: Consumer<HomePageEffects>(
                  builder: (context, value, child) => AnimatedCrossFade(
                    crossFadeState: (!value.onCollapsed)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 300),
                    sizeCurve: Curves.easeInOut,
                    secondChild: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      child: Container(),
                    ),
                    firstChild: Test(
                      timeSettings: timeSettings,
                      calculMethod: calculMethod.timeSettings,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.sw,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [
                        BelowCard(
                          pageController: pageController,
                        ),
                        QuranList(
                          pageController: pageController,
                        ),
                        HadithList(
                          pageController: pageController,
                        ),
                        DuasPage(pageController: pageController),
                        AsmaHosna(pageController: pageController)
                      ],
                    ),
                  )),
            )
          ]),
        ),
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key, required this.timeSettings, required this.calculMethod})
      : super(key: key);
  final int timeSettings;
  final int calculMethod;
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLocation(widget.timeSettings, context),
        builder: (context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Container();
          } else if (snapshot.connectionState != ConnectionState.done) {
            return Center(
                child: pt.CardLoading(
                    message: AppLocalizations.of(context)!.loadingloc));
          } else {
            return (snapshot.data!.latitude == 0 &&
                    snapshot.data!.longitude == 0)
                ? Container()
                : Center(
                    child: PrayertimesCard(
                        timeSettings: widget.calculMethod,
                        latitude: snapshot.data!.latitude,
                        timestamp: DateTime.now().millisecondsSinceEpoch,
                        longitude: snapshot.data!.longitude),
                  );
          }
        });
  }
}

class BelowCard extends StatefulWidget {
  const BelowCard({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;
  @override
  _BelowCardState createState() => _BelowCardState();
}

class _BelowCardState extends State<BelowCard>
    with AutomaticKeepAliveClientMixin {
  var _scrollController = ScrollController();
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  late Timer _timer;
  var _valueKey;

  loadInterstitialAd() {
    final adState = Provider.of<AdState>(context, listen: false);
    InterstitialAd.load(
      adUnitId: adState.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print("ad closed");
              _isInterstitialAdReady = false;
            },
          );
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!appData.isPro) {
      Future.delayed(Duration(seconds: 10))
          .then((value) => loadInterstitialAd());
      _timer = Timer.periodic(
          Duration(minutes: 5),
          (Timer t) => (_isInterstitialAdReady)
              ? print("Ad is ready")
              : loadInterstitialAd());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var rec = Provider.of<RecitationProvider>(context, listen: true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        customHomeAppbar(context, widget.pageController,
            AppLocalizations.of(context)!.home, false, () {}),
        Flexible(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(Duration(seconds: 1)).then((value) {
                  setState(() {
                    _valueKey = Object();
                  });
                });
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      WidgetAnimator(
                        child: AyahCard(
                          key: ValueKey(_valueKey),
                          recitation: rec.recitation,
                        ),
                      ),
                      SizedBox(
                        height: 40.sp,
                      ),
                      WidgetAnimator(
                        child: ListTile(
                          isThreeLine: true,
                          leading: Icon(
                            customIcon.MyFlutterApp.quran_1,
                            size: 200.sp,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.theHolyQuran,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          onTap: () {
                            if (_isInterstitialAdReady && !appData.isPro) {
                              _interstitialAd!.show().then((value) =>
                                  widget.pageController.animateToPage(1,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOutQuart));
                            } else
                              widget.pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuart);
                          },
                          subtitle:
                              Text(AppLocalizations.of(context)!.quranSubtitle),
                        ),
                      ),
                      WidgetAnimator(
                        child: ListTile(
                          isThreeLine: true,
                          leading: Icon(
                            customIcon.MyFlutterApp.prophet,
                            size: 200.sp,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.hadith,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          onTap: () {
                            if (_isInterstitialAdReady && !appData.isPro) {
                              _interstitialAd!.show().then((value) =>
                                  widget.pageController.animateToPage(2,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOutQuart));
                            } else
                              widget.pageController.animateToPage(2,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuart);
                          },
                          subtitle: Text(
                              AppLocalizations.of(context)!.hadithSubtitle),
                        ),
                      ),
                      SizedBox(height: 40.sp),
                      WidgetAnimator(
                        child: ListTile(
                          isThreeLine: true,
                          leading: Icon(
                            customIcon.MyFlutterApp.beads_1,
                            size: 200.sp,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.tasbeeh,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          onTap: () {
                            if (_isInterstitialAdReady && !appData.isPro) {
                              _interstitialAd!.show().then((value) =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Sibhah())));
                            } else
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Sibhah()));
                          },
                          subtitle: Text(
                              AppLocalizations.of(context)!.tasbeehSubtitle),
                        ),
                      ),
                      SizedBox(
                        height: 40.sp,
                      ),
                      WidgetAnimator(
                        child: ListTile(
                          isThreeLine: true,
                          leading: Icon(
                            customIcon.MyFlutterApp.allah,
                            size: 200.sp,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.asmaAlHusnatitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          onTap: () {
                            if (_isInterstitialAdReady && !appData.isPro) {
                              _interstitialAd!.show().then((value) =>
                                  widget.pageController.animateToPage(4,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOutQuart));
                            } else
                              widget.pageController.animateToPage(4,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuart);
                          },
                          subtitle:
                              Text(AppLocalizations.of(context)!.asmaAlHusna),
                        ),
                      ),
                      SizedBox(
                        height: 40.sp,
                      ),
                      WidgetAnimator(
                        child: ListTile(
                          isThreeLine: true,
                          leading: Icon(
                            customIcon.MyFlutterApp.open_hands,
                            size: 200.sp,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.duas,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          onTap: () {
                            if (_isInterstitialAdReady && !appData.isPro) {
                              _interstitialAd!.show().then((value) =>
                                  widget.pageController.animateToPage(3,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOutQuart));
                            } else
                              widget.pageController.animateToPage(3,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuart);
                          },
                          subtitle:
                              Text(AppLocalizations.of(context)!.duasSubtitle),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Future<Position> getLocation(int optionIndex, BuildContext context) {
  var getLocation;
  (optionIndex == 0)
      ? getLocation = getLiveLocation()
      : (optionIndex == 1)
          ? getLocation = getSavedLocation()
          : getLocation = getChosenLocation(context);
  return getLocation;
}
