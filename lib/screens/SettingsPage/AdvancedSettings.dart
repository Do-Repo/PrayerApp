import 'package:flutter/material.dart';
import 'package:application_1/src/advancedSettings.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class AdvancedSettings extends StatefulWidget {
  const AdvancedSettings({
    Key? key,
  }) : super(key: key);

  @override
  _AdvancedSettingsState createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettings> {
  @override
  Widget build(BuildContext context) {
    var prayerTimeCalcul = Provider.of<AdvancedSettingsProvider>(context);
    return Consumer<SavedLocationProvider>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: Text("Advanced Settings"),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(
                        "Prayer Times",
                        style: TextStyle(fontSize: 50.sp),
                      ),
                      tileColor: Theme.of(context).backgroundColor,
                    ),
                    PickTimeMethod(index: prayerTimeCalcul.timeSettings),
                    ListTile(
                      dense: true,
                      title: Text(
                        "Location Settings",
                        style: TextStyle(fontSize: 50.sp),
                      ),
                      tileColor: Theme.of(context).backgroundColor,
                    ),
                    PickLocationMethod(),
                  ],
                ),
              ),
            ));
  }
}

// Location Settings Methods
class PickLocationMethod extends StatefulWidget {
  const PickLocationMethod({
    Key? key,
  }) : super(key: key);

  @override
  _PickLocationMethodState createState() => _PickLocationMethodState();
}

enum LocationMethodGroup {
  zero, // Use gps
  one, // Get latest known location
  two, // Pick manually
}

class _PickLocationMethodState extends State<PickLocationMethod> {
  LocationMethodGroup? _character = LocationMethodGroup.zero;
  String title = "Loading location...", subtitle = "";
  @override
  void initState() {
    var option = Provider.of<AdvancedSettingsProvider>(context, listen: false);
    _character = LocationMethodGroup.values[option.locationOption];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var option = Provider.of<AdvancedSettingsProvider>(context);
    var loc = Provider.of<SavedLocationProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile(
            title: Text("Automatically"),
            value: LocationMethodGroup.zero,
            groupValue: _character,
            onChanged: (LocationMethodGroup? value) {
              option.locationOption = value!.index;
              _character = value;
            }),
        RadioListTile(
            title: Text("Pick Manually"),
            tileColor: (_character == LocationMethodGroup.two)
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.05)
                : Theme.of(context).scaffoldBackgroundColor,
            value: LocationMethodGroup.two,
            groupValue: _character,
            onChanged: (LocationMethodGroup? value) {
              option.locationOption = value!.index;
              _character = value;
            }),
        AnimatedCrossFade(
            firstChild: Container(),
            secondChild: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapInterface()));
                },
                tileColor: (_character == LocationMethodGroup.two)
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.05)
                    : Colors.transparent,
                leading: SizedBox(),
                title: Text("Set Location"),
                subtitle: FutureBuilder(
                  future: placemarkFromCoordinates(loc.savedLat, loc.savedLong),
                  builder: (context, AsyncSnapshot<List<Placemark>> snapnap) {
                    if (snapnap.connectionState != ConnectionState.done) {
                      return Text(
                        "Loading location...",
                        overflow: TextOverflow.ellipsis,
                      );
                    } else if (snapnap.hasError) {
                      return Text(
                        "No location is set yet",
                        style: TextStyle(color: Colors.red[300]),
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return Text(
                        snapnap.data!.first.administrativeArea.toString() +
                            " " +
                            snapnap.data!.first.country.toString(),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  },
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 40.sp,
                )),
            crossFadeState: (_character == LocationMethodGroup.two)
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300)),
      ],
    );
  }
}

class MapInterface extends StatefulWidget {
  const MapInterface({
    Key? key,
  }) : super(key: key);
  @override
  _MapInterfaceState createState() => _MapInterfaceState();
}

class _MapInterfaceState extends State<MapInterface> {
  String city = "", country = "";
  final mapController = MapController();
  @override
  Widget build(BuildContext context) {
    var loc = Provider.of<SavedLocationProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Set location",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        actions: [
          IconButton(
              onPressed: () {
                mapController.move(LatLng(loc.savedLat, loc.savedLong), 5.0);
              },
              icon: Icon(Icons.filter_center_focus_outlined))
        ],
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondary, size: 100.sp),
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.7),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 1.sh,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                controller: mapController,
                center: LatLng(loc.savedLat, loc.savedLong),
                zoom: 5.0,
                maxZoom: 13.0,
                onTap: (pos, val) {
                  loc.savedLat = val.latitude;
                  loc.savedLong = val.longitude;
                },
                minZoom: 4.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  attributionBuilder: (_) {
                    return Text("© OpenStreetMap contributors");
                  },
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 100.0,
                      rotate: true,
                      height: 100.0,
                      point: LatLng(loc.savedLat, loc.savedLong),
                      builder: (ctx) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 150.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: placemarkFromCoordinates(loc.savedLat, loc.savedLong),
            builder: (context, AsyncSnapshot<List<Placemark>> snap) {
              if (snap.hasError) {
                return Container(
                  margin: EdgeInsets.only(bottom: 80.sp),
                  height: 200.h,
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.7),
                  child: InkWell(
                    onTap: () {
                      placemarkFromCoordinates(loc.savedLat, loc.savedLong);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Something went wrong",
                              style: TextStyle(
                                  fontSize: 60.sp, color: Colors.red[300]),
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Something went wrong, please try again",
                            style: TextStyle(fontSize: 50.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else if (snap.connectionState != ConnectionState.done) {
                return Container(
                  margin: EdgeInsets.only(bottom: 80.sp),
                  height: 200.h,
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        city,
                        style: TextStyle(
                            fontSize: 60.sp,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        country,
                        style: TextStyle(fontSize: 50.sp),
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(bottom: 80.sp),
                  height: 200.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: Theme.of(context).colorScheme.secondary,
                        value: 0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Text(
                          city = snap.data!.first.locality.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 60.sp,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Text(
                          country =
                              snap.data!.first.administrativeArea.toString() +
                                  " " +
                                  snap.data!.first.country.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 50.sp),
                        ),
                      )
                    ],
                  ),
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.7),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// Prayertimes Calculation Methods
class PickTimeMethod extends StatefulWidget {
  const PickTimeMethod({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  _PickTimeMethodState createState() => _PickTimeMethodState();
}

enum TimeMethodGroup {
  zero, // Shia Ithna-Ashari, Leva Institute, Qum
  one, // University of Islamic Sciences, Karachi
  two, // Islamic Society of North America (ISNA)
  three, // Muslim World League
  four, // Umm Al-Qura University, Makkah
  five, // Egyptian General Authority of Survey
  six, // Doesn't exist something wrong with api
  seven, // Institute of Geophysics, University of Tehran
  eight, // Gulf Region
  nine, // Kuwait
  ten, // Qatar
  eleven, // Majlis Ugama Islam Singapura, Singapore
  twelve, // Union Organization islamic de France
  thirteen, // Diyanet İşleri Başkanlığı, Turkey
  fourteen // Spiritual Administration of Muslims of Russia
}

class _PickTimeMethodState extends State<PickTimeMethod> {
  TimeMethodGroup? _character;
  final _scrollController = ScrollController();
  @override
  void initState() {
    _character = TimeMethodGroup.values[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var timeSettings = Provider.of<AdvancedSettingsProvider>(context);
    return ExpansionTile(
      title: Text("Calculation method"),
      backgroundColor:
          Theme.of(context).colorScheme.secondary.withOpacity(0.05),
      children: [
        SizedBox(
          height: 600.h,
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  RadioListTile(
                      title: Text("Shia Ithna-Ashari, Leva Institute, Qum"),
                      subtitle: Text("Fajr: 16    Maghrib: 4    Isha: 14"),
                      value: TimeMethodGroup.zero,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("University of Islamic Sciences, Karachi"),
                      subtitle: Text("Fajr: 18    Isha: 18"),
                      value: TimeMethodGroup.one,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Islamic Society of North America (INSA)"),
                      subtitle: Text("Fajr: 15    Isha: 15"),
                      value: TimeMethodGroup.two,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Muslim World League"),
                      subtitle: Text("Fajr: 18    Isha: 17"),
                      value: TimeMethodGroup.three,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Umm Al-Qura University, Makkah"),
                      subtitle: Text("Fajr: 18.5    Isha: +90 min"),
                      value: TimeMethodGroup.four,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Egyptian General Authority of Survey"),
                      subtitle: Text("Fajr: 19.5    Isha: 17.5"),
                      value: TimeMethodGroup.five,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title:
                          Text("Institute of Geophysics, University of Tehran"),
                      subtitle: Text("Fajr: 17.7    Maghrib: 4.5    Isha: 14"),
                      value: TimeMethodGroup.seven,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Gulf Region"),
                      subtitle: Text("Fajr: 19.5    Isha: +90 min"),
                      value: TimeMethodGroup.eight,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Kuwait"),
                      subtitle: Text("Fajr: 18    Isha: 17.5"),
                      value: TimeMethodGroup.nine,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Qatar"),
                      subtitle: Text("Fajr: 18    Isha: +90 min"),
                      value: TimeMethodGroup.ten,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Majlis Ugama Islam Singapura, Singapore"),
                      subtitle: Text("Fajr: 20    Isha: 18"),
                      value: TimeMethodGroup.eleven,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Union Organization Islamic de France"),
                      subtitle: Text("Fajr: 12    Isha: 12"),
                      value: TimeMethodGroup.twelve,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title: Text("Diyanet İşleri Başkanlığı, Turkey"),
                      subtitle: Text("Fajr: 18    Isha: 17"),
                      value: TimeMethodGroup.thirteen,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                  RadioListTile(
                      title:
                          Text("Spiritual Administration of Muslims of Russia"),
                      subtitle: Text("Fajr: 16    Isha: 15"),
                      value: TimeMethodGroup.fourteen,
                      groupValue: _character,
                      onChanged: (TimeMethodGroup? value) {
                        setState(() {
                          _character = value;
                          timeSettings.timeSettings = _character!.index;
                        });
                      }),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
