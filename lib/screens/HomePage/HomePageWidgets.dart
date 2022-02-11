import 'dart:async';

import 'package:application_1/src/advancedSettings.dart';
import 'package:application_1/src/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:application_1/models/prayerTimes.dart';
import 'package:application_1/screens/HomePage/CalendarLayout.dart';

Padding holidayWidget(AsyncSnapshot<List<PrayerTimesModel>> snapshot) {
  List<String> holidayList = [];
  List<String> holidayDate = [];
  for (var element in snapshot.data!) {
    if (element.holidays!.isNotEmpty) {
      holidayList.add(element.holidays.toString());
      holidayDate.add(element.readabledate.toString());
    }
  }
  return Padding(
    padding: EdgeInsets.all(20.sp),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        color: Color(0xFF3A2E39).withOpacity(0.2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 24 + 48.sp,
                ),
                Text(
                  "Upcoming Holidays",
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w500),
                ),
                IconButton(onPressed: () {}, icon: SizedBox())
              ],
            ),
            Divider(),
            (holidayList.isNotEmpty)
                ? SizedBox(
                    height: 300.h,
                    child: ListView.builder(
                        itemCount: holidayList.length,
                        itemBuilder: (contex, index) {
                          return Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.sp),
                                  child: Text(
                                    holidayList[index].substring(
                                        1, holidayList[index].length - 1),
                                    style: TextStyle(
                                        fontSize: 50.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 50.w,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  holidayDate[index],
                                  style: TextStyle(
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.notifications_active_outlined,
                                    size: (65.sp),
                                  ))
                            ],
                          );
                        }),
                  )
                : Column(
                    children: [
                      SizedBox(
                          height: 200.sp,
                          width: 200.sp,
                          child: Image.asset("assets/images/box.png")),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Text(
                          "No Holidays This Month",
                          style: TextStyle(
                              fontSize: 50.sp, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    ),
  );
}

Widget holidayWidgetLoading() {
  return Padding(
    padding: EdgeInsets.all(20.sp),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        color: Color(0xFF3A2E39).withOpacity(0.2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 24 + 48.sp,
                ),
                Text(
                  "Upcoming Holidays",
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.more_horiz_outlined))
              ],
            ),
            Divider(),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Text(
                      "First day of ramadan",
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.w,
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "01 Apr 2021",
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: (65.sp),
                    ))
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

fajrNotification(BuildContext context, PrayerTimesModel snapshot) {
  NotificationService().setNotification(
      0,
      "It's time for" + " Fajr",
      "May Allah accept your prayers",
      DateFormat('HH:mm').parse(snapshot.fajr!).hour,
      DateFormat('HH:mm').parse(snapshot.fajr!).minute,
      'Fajr',
      context);
}

dhuhrNotification(BuildContext context, PrayerTimesModel snapshot) {
  NotificationService().setNotification(
      1,
      "It's time for" + " Dhuhr",
      "May Allah accept your prayers",
      DateFormat('HH:mm').parse(snapshot.dhuhr!).hour,
      DateFormat('HH:mm').parse(snapshot.dhuhr!).minute,
      "Dhuhr",
      context);
}

aasrNotification(BuildContext context, PrayerTimesModel snapshot) {
  NotificationService().setNotification(
      2,
      "It's time for" + " Aasr",
      "May Allah accept your prayers",
      DateFormat('HH:mm').parse(snapshot.aasr!).hour,
      DateFormat('HH:mm').parse(snapshot.aasr!).minute,
      "Aasr",
      context);
}

maghribNotification(BuildContext context, PrayerTimesModel snapshot) {
  NotificationService().setNotification(
      3,
      "It's time for" + " Maghrib",
      "May Allah accept your prayers",
      DateFormat('HH:mm').parse(snapshot.maghrib!).hour,
      DateFormat('HH:mm').parse(snapshot.maghrib!).minute,
      "Maghrib",
      context);
}

ishaaNotification(BuildContext context, PrayerTimesModel snapshot) {
  NotificationService().setNotification(
      4,
      "It's time for" + " Ishaa",
      "May Allah accept your prayers",
      DateFormat('HH:mm').parse(snapshot.isha!).hour,
      DateFormat('HH:mm').parse(snapshot.isha!).minute,
      "Ishaa",
      context);
}

setPrayerNotifications(PrayerTimesModel snapshot, BuildContext context) {
  var notif = Provider.of<AdvancedSettingsProvider>(context, listen: false);
  if (notif.savedFajr) {
    fajrNotification(context, snapshot);
  }
  if (notif.savedDhuhr) {
    dhuhrNotification(context, snapshot);
  }
  if (notif.savedAasr) {
    aasrNotification(context, snapshot);
  }
  if (notif.savedMaghrib) {
    maghribNotification(context, snapshot);
  }
  if (notif.savedIshaa) {
    ishaaNotification(context, snapshot);
  }
}

class TimingWidget extends StatefulWidget {
  const TimingWidget({Key? key, required this.snapshot}) : super(key: key);
  final PrayerTimesModel snapshot;

  @override
  _TimingWidgetState createState() => _TimingWidgetState();
}

class _TimingWidgetState extends State<TimingWidget> {
  late String timeString;
  late Timer t;
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTimeSeconds(now);

    setState(() {
      timeString = formattedDateTime;
    });
  }

  String _formatDateTimeSeconds(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    timeString = _formatDateTimeSeconds(DateTime.now());
    setPrayerNotifications(widget.snapshot, context);
    t = Timer.periodic(Duration(seconds: 1), (Timer timer) => _getTime());
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var set = Provider.of<AdvancedSettingsProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarPage()));
                      },
                      icon: Icon(Icons.calendar_today_outlined)),
                  Text(
                    "Today's timings",
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w500),
                  ),
                  IconButton(onPressed: () {}, icon: SizedBox())
                ],
              ),
              Divider(),
              Container(
                color: Color(0xFFF4D8CD).withOpacity(0.5),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.sp),
                      child: Text(
                        "Imsak",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.snapshot.imsak!.substring(0, 5),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SizedBox(),
                    )
                  ],
                ),
              ),
              Container(
                color: (whotohighlight(false, timeString, widget.snapshot.fajr!,
                        widget.snapshot.dhuhr!))
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        "Fajr",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.snapshot.fajr!.substring(0, 5),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                        onPressed: () {
                          if (set.savedFajr) {
                            setState(() {
                              set.savedFajr = !set.savedFajr;
                              NotificationService().deleteNotification(0);
                            });
                          } else {
                            setState(() {
                              set.savedFajr = !set.savedFajr;
                              fajrNotification(context, widget.snapshot);
                            });
                          }
                        },
                        icon: (set.savedFajr)
                            ? Icon(
                                Icons.notifications_active_outlined,
                                size: (65.sp),
                              )
                            : Icon(
                                Icons.notifications_off_outlined,
                                color: Colors.grey,
                              ))
                  ],
                ),
              ),
              Container(
                color: Color(0xFFF4D8CD).withOpacity(0.5),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        "Shuruq",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.snapshot.sunrise!.substring(0, 5),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: IconButton(
                          onPressed: () {},
                          icon: IconButton(
                            onPressed: () {},
                            icon: SizedBox(),
                          )),
                    )
                  ],
                ),
              ),
              Container(
                color: (whotohighlight(false, timeString,
                        widget.snapshot.dhuhr!, widget.snapshot.aasr!))
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        "Dhuhr",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.snapshot.dhuhr!.substring(0, 5),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                        onPressed: () {
                          if (set.savedDhuhr) {
                            setState(() {
                              set.savedDhuhr = !set.savedDhuhr;
                              NotificationService().deleteNotification(1);
                            });
                          } else {
                            setState(() {
                              set.savedDhuhr = !set.savedDhuhr;
                              dhuhrNotification(context, widget.snapshot);
                            });
                          }
                        },
                        icon: (set.savedDhuhr)
                            ? Icon(
                                Icons.notifications_active_outlined,
                                size: (65.sp),
                              )
                            : Icon(
                                Icons.notifications_off_outlined,
                                color: Colors.grey,
                              ))
                  ],
                ),
              ),
              Container(
                color: (whotohighlight(false, timeString, widget.snapshot.aasr!,
                        widget.snapshot.maghrib!))
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        "Aasr",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.snapshot.aasr!.substring(0, 5),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: IconButton(
                            onPressed: () {
                              if (set.savedAasr) {
                                setState(() {
                                  set.savedAasr = !set.savedAasr;
                                  NotificationService().deleteNotification(2);
                                });
                              } else {
                                setState(() {
                                  set.savedAasr = !set.savedAasr;
                                  aasrNotification(context, widget.snapshot);
                                });
                              }
                            },
                            icon: (set.savedAasr)
                                ? Icon(
                                    Icons.notifications_active_outlined,
                                    size: (65.sp),
                                  )
                                : Icon(
                                    Icons.notifications_off_outlined,
                                    color: Colors.grey,
                                  )))
                  ],
                ),
              ),
              Container(
                color: (whotohighlight(false, timeString,
                        widget.snapshot.maghrib!, widget.snapshot.isha!))
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        "Maghrib",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.snapshot.maghrib!.substring(0, 5),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: IconButton(
                            onPressed: () {
                              if (set.savedMaghrib) {
                                setState(() {
                                  set.savedMaghrib = !set.savedMaghrib;
                                  NotificationService().deleteNotification(3);
                                });
                              } else {
                                setState(() {
                                  set.savedMaghrib = !set.savedMaghrib;
                                  maghribNotification(context, widget.snapshot);
                                });
                              }
                            },
                            icon: (set.savedMaghrib)
                                ? Icon(
                                    Icons.notifications_active_outlined,
                                    size: (65.sp),
                                  )
                                : Icon(
                                    Icons.notifications_off_outlined,
                                    color: Colors.grey,
                                  )))
                  ],
                ),
              ),
              Container(
                color: (whotohighlight(true, timeString, widget.snapshot.isha!,
                        widget.snapshot.fajr!))
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        "Ishaa",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.snapshot.isha!.substring(0, 5),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: IconButton(
                            onPressed: () {
                              if (set.savedIshaa) {
                                setState(() {
                                  set.savedIshaa = !set.savedIshaa;
                                  NotificationService().deleteNotification(4);
                                });
                              } else {
                                setState(() {
                                  set.savedIshaa = !set.savedIshaa;
                                  ishaaNotification(context, widget.snapshot);
                                });
                              }
                            },
                            icon: (set.savedIshaa)
                                ? Icon(
                                    Icons.notifications_active_outlined,
                                    size: (65.sp),
                                  )
                                : Icon(
                                    Icons.notifications_off_outlined,
                                    color: Colors.grey,
                                  )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget timingWidgetLoading(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.sp),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_today_outlined)),
                Text(
                  "Timings",
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.more_horiz_outlined))
              ],
            ),
            Divider(),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Text(
                    "Fajr",
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                  ),
                ),
                Spacer(),
                Text(
                  "04:59",
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: (65.sp),
                    ))
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Text(
                    "Fajr",
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                  ),
                ),
                Spacer(),
                Text(
                  "04:59",
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: (65.sp),
                    ))
              ],
            ),
            Container(
              color: Color(0xFFF4D8CD).withOpacity(0.5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Text(
                      "Fajr",
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "04:59",
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_active_outlined,
                        size: (65.sp),
                      ))
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Text(
                    "Fajr",
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                  ),
                ),
                Spacer(),
                Text(
                  "04:59",
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: (65.sp),
                    ))
              ],
            ),
            Container(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Text(
                      "Fajr",
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "04:59",
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w300),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_active_outlined,
                        size: (65.sp),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget dateWidget(
  BuildContext context,
  PrayerTimesModel snapshot,
) {
  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40))),
    child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: SizedBox()),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    snapshot.hijriDayNumber.toString(),
                    style:
                        TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    snapshot.gregorianDayNumber.toString() +
                        " " +
                        snapshot.gregorianDayName.toString(),
                    style: TextStyle(
                        fontSize: 40.sp, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      snapshot.hijriMonthEN.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      snapshot.gregorianMonth.toString(),
                      style: TextStyle(
                          fontSize: 40.sp, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(snapshot.hijriYear.toString(),
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.bold)),
                  Text(
                    snapshot.gregorianYear.toString(),
                    style: TextStyle(
                        fontSize: 40.sp, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              IconButton(onPressed: () {}, icon: SizedBox())
            ],
          ),
        ]),
  );
}

Widget dateWidgetLoading(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[400]!,
    highlightColor: Colors.white.withOpacity(0.3),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(onPressed: () {}, icon: SizedBox()),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10.sp),
                  width: 100.w,
                  height: 50.sp,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.sp),
                  width: 200.w,
                  height: 40.sp,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.all(10.sp),
                    width: 400.w,
                    height: 50.sp,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.sp),
                    width: 200.w,
                    height: 45.sp,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10.sp),
                  width: 100.w,
                  height: 50.sp,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.sp),
                  width: 200.w,
                  height: 40.sp,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ],
            ),
            IconButton(onPressed: () {}, icon: SizedBox()),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    ),
  );
}

class HomePageHeader extends StatefulWidget {
  const HomePageHeader({Key? key, required this.snapshot}) : super(key: key);
  final PrayerTimesModel snapshot;
  @override
  _HomePageHeaderState createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  late Timer t;
  late String timeString;

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTimeSeconds(now);

    setState(() {
      timeString = formattedDateTime;
    });
  }

  String _formatDateTimeSeconds(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    timeString = _formatDateTimeSeconds(DateTime.now());
    t = Timer.periodic(Duration(seconds: 1), (Timer timer) => _getTime());
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                          getHeaderInfo(widget.snapshot, timeString).name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 70.sp)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                          getHeaderInfo(widget.snapshot, timeString).timeLeft,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
                SizedBox(
                    width: 300.sp,
                    height: 300.sp,
                    child: Image.asset(
                        getHeaderInfo(widget.snapshot, timeString).image))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Container homePageHeaderLoading(BuildContext context) {
  return Container(
    color: Theme.of(context).colorScheme.secondary,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.3),
            highlightColor: Theme.of(context).colorScheme.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        margin: EdgeInsets.all(10.sp),
                        width: 300.w,
                        height: 70.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.sp),
                        width: 600.w,
                        height: 16,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.sp),
                  width: 300.sp,
                  height: 300.sp,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget homePageAppBar(AsyncSnapshot<List<PrayerTimesModel>> snapshot) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text((snapshot.data!.first.city!.isEmpty)
          ? snapshot.data!.first.province.toString()
          : snapshot.data!.first.city.toString()),
      Text(
        (snapshot.data!.first.city!.isEmpty)
            ? snapshot.data!.first.country.toString()
            : snapshot.data!.first.province.toString() +
                " " +
                snapshot.data!.first.country.toString(),
        style: TextStyle(fontSize: 40.sp),
      )
    ],
  );
}

Widget homePageAppBarLoading(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.white.withOpacity(0.3),
    highlightColor: Theme.of(context).colorScheme.secondary,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.sp),
          width: 300.w,
          height: 16,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        Container(
          width: 500.w,
          height: 40.sp,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ],
    ),
  );
}

class HeaderInfo {
  String name;
  String image;
  String timeLeft;
  HeaderInfo({
    required this.name,
    required this.image,
    required this.timeLeft,
  });
}

HeaderInfo getHeaderInfo(PrayerTimesModel snapshot, String timeString) {
  if (whotohighlight(false, timeString, snapshot.fajr!, snapshot.dhuhr!)) {
    return HeaderInfo(
        name: 'Fajr',
        image: 'assets/images/fajr.png',
        timeLeft: getTimeLeft(timeString, snapshot.dhuhr!));
  } else if (whotohighlight(
      false, timeString, snapshot.dhuhr!, snapshot.aasr!)) {
    return HeaderInfo(
        name: 'Dhuhr',
        image: 'assets/images/dhuhr.png',
        timeLeft: getTimeLeft(timeString, snapshot.aasr!));
  } else if (whotohighlight(
      false, timeString, snapshot.aasr!, snapshot.maghrib!)) {
    return HeaderInfo(
        name: 'Aasr',
        image: 'assets/images/dhuhr.png',
        timeLeft: getTimeLeft(timeString, snapshot.maghrib!));
  } else if (whotohighlight(
      false, timeString, snapshot.maghrib!, snapshot.isha!)) {
    return HeaderInfo(
        name: 'Maghrib',
        image: 'assets/images/maghrib.png',
        timeLeft: getTimeLeft(timeString, snapshot.isha!));
  } else {
    return HeaderInfo(
        name: 'Isha', image: 'assets/images/ishaa.png', timeLeft: "");
  }
}

String getTimeLeft(String time1, String time2) {
  var t1 = DateFormat("HH:mm").parse(time1);
  var t2 = DateFormat("HH:mm").parse(time2);
  Duration diff = t2.difference(t1);
  String hour = (diff.inHours > 1) ? "Hours" : "Hour";
  String minute = (diff.inMinutes > 1) ? "Minutes" : "Minute";
  return (diff.inHours != 0)
      ? "${diff.inHours} $hour and ${diff.inMinutes - (diff.inHours * 60)} $minute left"
      : (diff.inMinutes != 0)
          ? "${diff.inMinutes - (diff.inHours * 60)} $minute left"
          : "${diff.inSeconds} Seconds left";
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.warning_amber_outlined),
        title: Text("Permission required"),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              Theme.of(context).scaffoldBackgroundColor,
            ])),
        padding: EdgeInsets.all(20.sp),
        child: Column(
          children: [
            Image.asset(
              "assets/images/wrong-way.png",
              height: 200.sp,
              width: 200.sp,
            ),
            Text(
              "Location required",
              style: TextStyle(fontSize: 60.sp, fontWeight: FontWeight.w700),
            ),
            Text(
              "Please check if you granted permission for the app to know your location. Location is required to show accurate prayertimes. If location is granted, make sure it's activated in your device settings. If you don't want to turn on the gps, you can set your location manually in location settings",
              style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.w300),
            ),
            Divider(),
            Image.asset(
              "assets/images/world.png",
              height: 200.sp,
              width: 200.sp,
            ),
            Text(
              "Internet access required",
              style: TextStyle(fontSize: 60.sp, fontWeight: FontWeight.w700),
            ),
            Text(
              "Make sure you're connected to the internet, especially for the first time. All the app data like Quran, Hadith and Asma are stored online to keep the size reasonable. After the first time this data will be cached and can be shown offline",
              style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}

bool whotohighlight(
  bool isIsha,
  String timenow,
  String currenttime,
  String upcomingtime,
) {
  var corruptedTimenow = DateFormat('HH:mm').parse(timenow);
  var corruptedCurrenttime = DateFormat('HH:mm').parse(currenttime);
  var corruptedUpcomingtime = DateFormat('HH:mm').parse(upcomingtime);

  if (corruptedTimenow.isBefore(corruptedCurrenttime)) {
    if (corruptedUpcomingtime.isAfter(corruptedTimenow) && (isIsha)) {
      return true;
    } else {
      return false;
    }
  } else if (corruptedTimenow.isAtSameMomentAs(corruptedCurrenttime)) {
    return true;
  } else if (corruptedTimenow.isAfter(corruptedCurrenttime)) {
    if ((corruptedTimenow.isBefore(corruptedUpcomingtime) || (isIsha))) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}
