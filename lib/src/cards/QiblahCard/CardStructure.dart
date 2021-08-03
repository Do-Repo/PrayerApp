import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart';
import 'package:vector_math/vector_math.dart' as maths;

class QiblahCard extends StatefulWidget {
  const QiblahCard(
      {Key? key, required double latitude, required double longitude})
      : lt = latitude,
        lot = longitude,
        super(key: key);
  final double lt;
  final double lot;
  @override
  _QiblahCardState createState() => _QiblahCardState();
}

class _QiblahCardState extends State<QiblahCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var customIcon;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.green,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Qiblah Direction',
                    style: TextStyle(
                      fontSize: 70.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Distance from Kaaba: ${getDistanceFromLatLonInKm(widget.lt, widget.lot).toStringAsFixed(2)} KM',
                    style: TextStyle(fontSize: 35.sp),
                    softWrap: true,
                  ),
                  Text(
                    'Point your phone North to get accurate results',
                    style: TextStyle(fontSize: 35.sp),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(25.sp),
              width: 300.w,
              height: 300.w,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Center(
                  child: Stack(
                    children: [
                      Center(
                          child: Icon(
                        MyFlutterApp.compass,
                        size: 250.sp,
                        color: Colors.green[200],
                      )),
                      Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation(
                              getOffsetFromNorth(widget.lt, widget.lot) / 360,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.green,
                              size: 200.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.green,
        )
      ],
    );
  }
}

double getOffsetFromNorth(double? currentLatitude, double? currentLongitude) {
  double targetLatitude = 21.422487;
  double targetLongitude = 39.826206;

  var la_rad = maths.radians(currentLatitude!);
  var lo_rad = maths.radians(currentLongitude!);

  var de_la = maths.radians(targetLatitude);
  var de_lo = maths.radians(targetLongitude);

  var toDegrees = maths.degrees(atan(sin(de_lo - lo_rad) /
      ((cos(la_rad) * tan(de_la)) - (sin(la_rad) * cos(de_lo - lo_rad)))));
  if (la_rad > de_la) {
    if ((lo_rad > de_lo || lo_rad < maths.radians(-180.0) + de_lo) &&
        toDegrees > 0.0 &&
        toDegrees <= 90.0) {
      toDegrees += 180.0;
    } else if (lo_rad <= de_lo &&
        lo_rad >= maths.radians(-180.0) + de_lo &&
        toDegrees > -90.0 &&
        toDegrees < 0.0) {
      toDegrees += 180.0;
    }
  }
  if (la_rad < de_la) {
    if ((lo_rad > de_lo || lo_rad < maths.radians(-180.0) + de_lo) &&
        toDegrees > 0.0 &&
        toDegrees < 90.0) {
      toDegrees += 180.0;
    }
    if (lo_rad <= de_lo &&
        lo_rad >= maths.radians(-180.0) + de_lo &&
        toDegrees > -90.0 &&
        toDegrees <= 0.0) {
      toDegrees += 180.0;
    }
  }
  print(toDegrees);
  return toDegrees;
}

double getDistanceFromLatLonInKm(lat1, lon1) {
  double lon2 = 39.826206;
  double lat2 = 21.422487;
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a = sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

double deg2rad(deg) {
  return deg * (pi / 180);
}
