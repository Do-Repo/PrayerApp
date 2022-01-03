import 'package:application_1/src/customWidgets/notificationService.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardDone extends StatefulWidget {
  const CardDone({
    Key? key,
    required String? timeString,
    required AsyncSnapshot snap,
  })  : _timeString = timeString,
        snapshot = snap,
        super(key: key);

  final String? _timeString;
  final AsyncSnapshot snapshot;
  @override
  _CardDoneState createState() => _CardDoneState();
}

bool _whotohighlight(
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
    } else
      return false;
  } else if (corruptedTimenow.isAtSameMomentAs(corruptedCurrenttime)) {
    return true;
  } else if (corruptedTimenow.isAfter(corruptedCurrenttime)) {
    if ((corruptedTimenow.isBefore(corruptedUpcomingtime) || (isIsha))) {
      return true;
    } else
      return false;
  }
  return false;
}

class _CardDoneState extends State<CardDone> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setPrayerNotifications(widget.snapshot, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      (widget.snapshot.data.city.toString().isEmpty)
                          ? (widget.snapshot.data.province.toString().isEmpty)
                              ? widget.snapshot.data.country
                              : widget.snapshot.data.province
                          : widget.snapshot.data.city,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 60.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    widget._timeString!,
                    style: TextStyle(
                        fontSize: 60.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      (widget.snapshot.data.city.toString().isEmpty)
                          ? widget.snapshot.data.country
                          : widget.snapshot.data.province +
                              " " +
                              widget.snapshot.data.country,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 35.sp),
                    ),
                  ),
                  Container(
                    width: 100.sp,
                  ),
                ],
              ),
              // FIRST SALET ROW
              Row(
                children: [
                  SizedBox(
                    width: 400.w,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text('Subah',
                                style: TextStyle(
                                    color: _whotohighlight(
                                            false,
                                            widget._timeString!,
                                            widget.snapshot.data.fajr,
                                            widget.snapshot.data.dhuhr)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.w800)),
                            Spacer(),
                            Text(
                              widget.snapshot.data.fajr,
                              style: TextStyle(
                                  color: _whotohighlight(
                                    false,
                                    widget._timeString!,
                                    widget.snapshot.data.fajr,
                                    widget.snapshot.data.dhuhr,
                                  )
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),

                        // SECOND SALET ROW
                        Row(
                          children: [
                            Text('Dhuhr',
                                style: TextStyle(
                                    color: _whotohighlight(
                                            false,
                                            widget._timeString!,
                                            widget.snapshot.data.dhuhr,
                                            widget.snapshot.data.aasr)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.w800)),
                            Spacer(),
                            Text(
                              widget.snapshot.data.dhuhr,
                              style: TextStyle(
                                fontSize: 45.sp,
                                fontWeight: FontWeight.w800,
                                color: _whotohighlight(
                                        false,
                                        widget._timeString!,
                                        widget.snapshot.data.dhuhr,
                                        widget.snapshot.data.aasr)
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                        // THIRD SALET ROW
                        Row(
                          children: [
                            Text('Aasr',
                                style: TextStyle(
                                  color: _whotohighlight(
                                          false,
                                          widget._timeString!,
                                          widget.snapshot.data.aasr,
                                          widget.snapshot.data.maghrib)
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w800,
                                )),
                            Spacer(),
                            Text(
                              widget.snapshot.data.aasr,
                              style: TextStyle(
                                color: _whotohighlight(
                                        false,
                                        widget._timeString!,
                                        widget.snapshot.data.aasr,
                                        widget.snapshot.data.maghrib)
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white,
                                fontSize: 45.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ],
                        ),
                        // FOURTH SALET ROW
                        Row(
                          children: [
                            Text('Maghrib',
                                style: TextStyle(
                                    color: _whotohighlight(
                                            false,
                                            widget._timeString!,
                                            widget.snapshot.data.maghrib,
                                            widget.snapshot.data.isha)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.w800)),
                            Spacer(),
                            Text(
                              widget.snapshot.data.maghrib,
                              style: TextStyle(
                                fontSize: 45.sp,
                                fontWeight: FontWeight.w800,
                                color: _whotohighlight(
                                        false,
                                        widget._timeString!,
                                        widget.snapshot.data.maghrib,
                                        widget.snapshot.data.isha)
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                        // FIFTH SALET ROW
                        Row(
                          children: [
                            Text('Isha',
                                style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w800,
                                  color: _whotohighlight(
                                          true,
                                          widget._timeString!,
                                          widget.snapshot.data.isha,
                                          widget.snapshot.data.fajr)
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                )),
                            Spacer(),
                            Text(
                              widget.snapshot.data.isha,
                              style: TextStyle(
                                fontSize: 45.sp,
                                fontWeight: FontWeight.w800,
                                color: _whotohighlight(
                                        true,
                                        widget._timeString!,
                                        widget.snapshot.data.isha,
                                        widget.snapshot.data.fajr)
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.snapshot.data.hijriDayNumber,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.snapshot.data.gregorianDayName +
                              " " +
                              widget.snapshot.data.gregorianDayNumber,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.snapshot.data.hijriMonthEN,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.snapshot.data.gregorianMonth,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.snapshot.data.hijriYear,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50.sp,
                                fontWeight: FontWeight.bold)),
                        Text(
                          widget.snapshot.data.gregorianYear,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      color: Colors.transparent,
    );
  }
}

setPrayerNotifications(AsyncSnapshot snapshot, BuildContext context) {
  var notif = Provider.of<SavedNotificationProvider>(context, listen: false);
  if (notif.savedFajr) {
    NotificationService().setNotification(
        0,
        AppLocalizations.of(context)!.notiftitle + " Fajr",
        AppLocalizations.of(context)!.notifbodyone +
            " Fajr.\n" +
            AppLocalizations.of(context)!.notifbodytwo,
        DateFormat('HH:mm').parse(snapshot.data!.fajr).hour,
        DateFormat('HH:mm').parse(snapshot.data!.fajr).minute,
        context);
  }
  if (notif.savedDhuhr) {
    NotificationService().setNotification(
        1,
        AppLocalizations.of(context)!.notiftitle + " Dhuhr",
        AppLocalizations.of(context)!.notifbodyone +
            " Dhuhr.\n" +
            AppLocalizations.of(context)!.notifbodytwo,
        DateFormat('HH:mm').parse(snapshot.data!.dhuhr).hour,
        DateFormat('HH:mm').parse(snapshot.data!.dhuhr).minute,
        context);
  }
  if (notif.savedAasr) {
    NotificationService().setNotification(
        2,
        AppLocalizations.of(context)!.notiftitle + " Aasr",
        AppLocalizations.of(context)!.notifbodyone +
            " Aasr.\n" +
            AppLocalizations.of(context)!.notifbodytwo,
        DateFormat('HH:mm').parse(snapshot.data!.aasr).hour,
        DateFormat('HH:mm').parse(snapshot.data!.aasr).minute,
        context);
  }
  if (notif.savedMaghrib) {
    NotificationService().setNotification(
        3,
        AppLocalizations.of(context)!.notiftitle + " Maghrib",
        AppLocalizations.of(context)!.notifbodyone +
            " Maghrib.\n" +
            AppLocalizations.of(context)!.notifbodytwo,
        DateFormat('HH:mm').parse(snapshot.data!.maghrib).hour,
        DateFormat('HH:mm').parse(snapshot.data!.maghrib).minute,
        context);
  }
  if (notif.savedIshaa) {
    NotificationService().setNotification(
        4,
        AppLocalizations.of(context)!.notiftitle + " Ishaa",
        AppLocalizations.of(context)!.notifbodyone +
            " Ishaa.\n" +
            AppLocalizations.of(context)!.notifbodytwo,
        DateFormat('HH:mm').parse(snapshot.data!.isha).hour,
        DateFormat('HH:mm').parse(snapshot.data!.isha).minute,
        context);
  }
}
