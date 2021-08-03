import 'package:application_1/src/cards/PrayerTimes/CardStructure.dart';
import 'package:application_1/src/cards/QiblahCard/CardStructure.dart';
import 'package:application_1/src/cards/AyahCard/CardStructure.dart';
import 'package:application_1/src/cards/QuranCard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    TabController? tabcontroller,
  })  : tabs = tabcontroller,
        super(key: key);
  final TabController? tabs;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Loc?>? yeah;
  @override
  void initState() {
    super.initState();
    yeah = getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: FutureBuilder(
        future: yeah,
        builder: (context, AsyncSnapshot<Loc?> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Container();
          } else if (!snapshot.hasData)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.green,
                  color: Colors.green[100],
                ),
              ],
            );
          else
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                PrayertimesCard(
                  latitude: snapshot.data!.latitude!,
                  longitude: snapshot.data!.longitude!,
                  timestamp: snapshot.data!.timestamp!,
                ),
                SizedBox(
                  height: 40.sp,
                ),
                AyahCard(
                  tabController: widget.tabs,
                ),
                QiblahCard(
                  latitude: snapshot.data!.latitude!,
                  longitude: snapshot.data!.longitude!,
                ),
                QuranCard()
              ]),
            );
        },
      )),
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
  Location location = new Location();
  int time;
  LocationData? _locationdata;

  _locationdata = await location.getLocation();

  time = _locationdata.time!.toInt();

  if (_locationdata.latitude != null && _locationdata.longitude != null) {
    return Loc(
        latitude: _locationdata.latitude,
        longitude: _locationdata.longitude,
        timestamp: time);
  } else
    return null;
}
