import 'dart:async';

import 'package:application_1/main.dart';
import 'package:application_1/screens/HadithPage/HadithList.dart';
import 'package:application_1/screens/Quranpage/QuranList.dart';
import 'package:application_1/screens/Sibhah.dart';
import 'package:application_1/screens/VirtualImam/ScreenStructure.dart';
import 'package:application_1/src/cards/PrayerTimes/CardStructure.dart';
import 'package:application_1/src/cards/AyahCard/CardStructure.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:application_1/src/customWidgets/appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      body: Container(
          child: FutureBuilder(
        future: getLocation(),
        builder: (context, AsyncSnapshot<Loc?> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Container();
          } else if (snapshot.connectionState != ConnectionState.done)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  color: Colors.green,
                ),
              ],
            );
          else
            return (snapshot.data!.latitude == 0)
                // In case location timeout is triggered and previous location is unknown show this
                ? Container(
                    padding: EdgeInsets.all(20.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Couldn't find your location",
                          style: TextStyle(
                              fontSize: 60.sp, fontWeight: FontWeight.w500),
                        ),
                        Text(
                            "This usually happens when the gps is turned off or when the application is not allowed to know your location\n\n Before retrying make sure:"),
                        Text(
                          "- The app has permission to know your location",
                        ),
                        Text(
                          "- Gps is turned on",
                        ),
                        Text(
                          "- You're connected to the internet",
                        ),
                        Text(
                            "\n If this happens frequently, you can always report the issue"),
                        SizedBox(
                          width: 1.sw,
                          height: 30.sp,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    getLocation();
                                  });
                                },
                                child: Text(
                                  "Refresh",
                                  style: TextStyle(color: Colors.green),
                                ))
                          ],
                        )
                      ],
                    ),
                  )
                // When location is found show homescreen
                : Column(mainAxisSize: MainAxisSize.min, children: [
                    PrayertimesCard(
                      latitude: snapshot.data!.latitude!,
                      longitude: snapshot.data!.longitude!,
                      timestamp: snapshot.data!.timestamp!,
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    BelowCard(),
                  ]);
        },
      )),
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
  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rec = Provider.of<RecitationProvider>(context);

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
                        customIcon.MyFlutterApp.quran,
                        size: 200.sp,
                      ),
                      title: Text(
                        "The Holy Quran",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      onTap: () {
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
                        customIcon.MyFlutterApp.muslim,
                        size: 200.sp,
                      ),
                      title: Text(
                        "Hadith",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HadithList()));
                      },
                      subtitle: Text(
                          "A collection of traditions containing sayings of the prophet Muhammad which, with accounts of his daily practice"),
                    ),
                    SizedBox(height: 40.sp),
                    ListTile(
                      isThreeLine: true,
                      leading: Icon(
                        customIcon.MyFlutterApp.tasbih,
                        size: 200.sp,
                      ),
                      title: Text(
                        "Tasbeeh ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Sibhah()));
                      },
                      subtitle: Text(
                          'Assist in the glorification of Allah following prayers: 33 Tasbeeh, 33 Tahmeed, and 33 Takbeer.'),
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    ListTile(
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VirtualImam()));
                      },
                      leading: Icon(
                        customIcon.MyFlutterApp.islamic,
                        size: 200.sp,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Virtual Imam',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          beta()
                        ],
                      ),
                      subtitle: Text(
                          "A virtual assistant to help you with your prayers."),
                    ),
                    SizedBox(
                      height: 30.sp,
                    )
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

// I thought calling location once at the beginning of the app works better
class Loc {
  double? latitude;
  double? longitude;
  int? timestamp;
  Loc({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

Future<Loc?> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return null;
    }
  }
  Position location;
  try {
    location = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    ).timeout(Duration(seconds: 30));
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

  return Loc(
      latitude: location.latitude,
      longitude: location.longitude,
      timestamp: location.timestamp!.millisecondsSinceEpoch);
}

Widget beta() {
  return Container(
    padding: EdgeInsets.all(10.sp),
    decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(30))),
    child: Center(
      child: Text(
        'Beta',
        style: TextStyle(fontSize: 30.sp, color: Colors.white),
      ),
    ),
  );
}
