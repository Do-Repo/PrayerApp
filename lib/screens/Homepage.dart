import 'dart:async';
import 'package:application_1/screens/DuasAndAzkar/Duas.dart';
import 'package:application_1/screens/HadithPage/HadithList.dart';
import 'package:application_1/screens/Quranpage/QuranList.dart';
import 'package:application_1/screens/Settings/AdvancedSettings.dart';
import 'package:application_1/screens/Sibhah.dart';
import 'package:application_1/src/cards/PrayerTimes/CardStructure.dart';
import 'package:application_1/src/cards/AyahCard/CardStructure.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/ad_helper.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:application_1/src/customWidgets/notificationService.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.optionIndex}) : super(key: key);
  final int optionIndex;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Position> getLocation;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.optionIndex) {
      case 0:
        getLocation = getLiveLocation();
        break;
      case 1:
        getLocation = getSavedLocation();
        break;
      case 2:
        getLocation = getChosenLocation(context);
        break;
    }
    return Scaffold(
      appBar: customAppbar(context, true, "assets/images/muslim.png", true),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: FutureBuilder(
            future: getLocation,
            builder: (context, AsyncSnapshot<Position> snapshot) {
              if (snapshot.hasError) {
                return LocationFailed(
                  onPressed: () {
                    setState(() {
                      getLocation = getLocation;
                    });
                  },
                );
              } else {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Expanded(child: Container())
                    ],
                  );
                } else {
                  return (snapshot.data!.latitude == 0 &&
                          snapshot.data!.longitude == 0)
                      ? LocationFailed(
                          onPressed: () {
                            setState(() {
                              getLocation = getLocation;
                            });
                          },
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PrayertimesCard(
                                latitude: snapshot.data!.latitude,
                                timestamp: snapshot
                                    .data!.timestamp!.millisecondsSinceEpoch,
                                longitude: snapshot.data!.longitude),
                            SizedBox(
                              height: 40.sp,
                            ),
                            BelowCard(),
                          ],
                        );
                }
              }
            },
          )),
        ],
      ),
    );
  }
}

class LocationFailed extends StatelessWidget {
  const LocationFailed({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            isThreeLine: true,
            leading: Icon(
              customIcon.MyFlutterApp.warning,
              color: Theme.of(context).colorScheme.secondary,
              size: 200.sp,
            ),
            title: Text(
              "Couldn't find your location",
              style: TextStyle(
                  fontSize: 60.sp,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "This usually happens when the gps is turned off or when the application is not allowed to know your location\n\nBefore retrying make sure:",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 50.sp),
            ),
          ),
          Text(
            "\n- The app has permission to know your location\n",
          ),
          Text(
            "- Gps is turned on\n",
          ),
          Text(
            "- You are connected to the internet\n",
          ),
          SizedBox(
            width: 1.sw,
            height: 30.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvancedSettings()));
                  },
                  child: Text(
                    "Location Settings",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
              TextButton(
                  onPressed: onPressed,
                  child: Text(
                    "Retry",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

// Because the shadow scrolling animation is triggered by setState() everytime
// the user scrolls, getLocation gets called so I divided them in seperate stateful widgets
class BelowCard extends StatefulWidget {
  const BelowCard({
    Key? key,
  }) : super(key: key);

  @override
  _BelowCardState createState() => _BelowCardState();
}

class _BelowCardState extends State<BelowCard> {
  int shadowsize = 0;
  var _scrollController = ScrollController();
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  late Timer _timer;

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
    Future.delayed(Duration(seconds: 10)).then((value) => loadInterstitialAd());
    _timer = Timer.periodic(
        Duration(minutes: 5),
        (Timer t) => (_isInterstitialAdReady)
            ? print("Ad is ready")
            : loadInterstitialAd());
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > 10) {
          setState(() {
            shadowsize = 40;
          });
        } else
          setState(() {
            shadowsize = 0;
          });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rec = Provider.of<RecitationProvider>(context, listen: true);
    return Expanded(
      child: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
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
                    AyahCard(
                      recitation: rec.recitation,
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    ListTile(
                      isThreeLine: true,
                      leading: Icon(
                        customIcon.MyFlutterApp.quran_1,
                        size: 200.sp,
                      ),
                      title: Text(
                        "The Holy Quran",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        if (_isInterstitialAdReady) {
                          _interstitialAd!.show().then((value) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuranList())));
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuranList()));
                      },
                      subtitle: Text(
                          "Read and listen every verse of the holy Quran in Arabic and English"),
                    ),
                    ListTile(
                      isThreeLine: true,
                      leading: Icon(
                        customIcon.MyFlutterApp.prophet,
                        size: 200.sp,
                      ),
                      title: Text(
                        "Hadith",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        if (_isInterstitialAdReady) {
                          _interstitialAd!.show().then((value) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HadithList())));
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HadithList()));
                      },
                      subtitle: Text(
                          "A collection of traditions containing sayings of the prophet Muhammad, with accounts of his daily practice"),
                    ),
                    SizedBox(height: 40.sp),
                    ListTile(
                      isThreeLine: true,
                      leading: Icon(
                        customIcon.MyFlutterApp.beads_1,
                        size: 200.sp,
                      ),
                      title: Text(
                        "Tasbeeh ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        if (_isInterstitialAdReady) {
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
                          'Assist in the glorification of Allah following prayers: Tasbeeh, Tahmeed, and Takbeer'),
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    ListTile(
                      isThreeLine: true,
                      leading: Icon(
                        customIcon.MyFlutterApp.open_hands,
                        size: 200.sp,
                      ),
                      title: Text(
                        "Duas & Azkar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        if (_isInterstitialAdReady) {
                          _interstitialAd!.show().then((value) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DuasPage())));
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DuasPage()));
                      },
                      subtitle: Text(
                          "A collection of duas and azkar for every situation"),
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    ListTile(
                      isThreeLine: true,
                      leading: Icon(
                        customIcon.MyFlutterApp.zakat,
                        size: 200.sp,
                      ),
                      title: Text(
                        "Zakat calculator",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () {
                        NotificationService()
                            .showNotification(1, "title", "body", 5);
                      },
                      subtitle: Text(
                          "Zakat is based on income and the value of possessions, calculate how much your zakat is worth"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            height: shadowsize.sp,
            width: 1.sw,
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.black
                      : Colors.grey,
                  Colors.transparent
                ])),
          ),
        ],
      ),
    );
  }
}

Widget beta(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(10.sp),
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.all(Radius.circular(30))),
    child: Center(
      child: Text(
        'Beta',
        style: TextStyle(fontSize: 30.sp, color: Colors.white),
      ),
    ),
  );
}
