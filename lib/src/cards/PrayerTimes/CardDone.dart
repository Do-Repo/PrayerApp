import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardDone extends StatefulWidget {
  const CardDone({
    Key key,
    @required String timeString,
    @required AsyncSnapshot snap,
  })  : _timeString = timeString,
        snapshot = snap,
        super(key: key);

  final String _timeString;
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
    if (isIsha)
      return true;
    else
      return false;
  } else if (corruptedTimenow.isAtSameMomentAs(corruptedCurrenttime)) {
    return true;
  } else if (corruptedTimenow.isAfter(corruptedCurrenttime)) {
    if ((corruptedTimenow.isBefore(corruptedUpcomingtime) || (isIsha))) {
      return true;
    } else
      return false;
  }
}

class _CardDoneState extends State<CardDone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(width: 2.sp, color: Colors.green)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        widget.snapshot.data.city,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 70.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      widget._timeString,
                      style: TextStyle(
                          fontSize: 70.sp, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        widget.snapshot.data.province +
                            " " +
                            widget.snapshot.data.country,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 35.sp),
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
                    Text('Fajr',
                        style: TextStyle(
                            color: _whotohighlight(
                                    false,
                                    widget._timeString,
                                    widget.snapshot.data.fajr,
                                    widget.snapshot.data.dhuhr)
                                ? Colors.green
                                : Colors.black,
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w800)),
                    Spacer(),
                    Text(
                      widget.snapshot.data.fajr,
                      style: TextStyle(
                          color: _whotohighlight(
                            false,
                            widget._timeString,
                            widget.snapshot.data.fajr,
                            widget.snapshot.data.dhuhr,
                          )
                              ? Colors.green
                              : Colors.black,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w800),
                    )
                  ],
                ),
                // SECOND SALET ROW
                Row(
                  children: [
                    SizedBox(
                      width: 400.w,
                    ),
                    Text('Dhuhr',
                        style: TextStyle(
                            color: _whotohighlight(
                                    false,
                                    widget._timeString,
                                    widget.snapshot.data.dhuhr,
                                    widget.snapshot.data.aasr)
                                ? Colors.green
                                : Colors.black,
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w800)),
                    Spacer(),
                    Text(
                      widget.snapshot.data.dhuhr,
                      style: TextStyle(
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w800,
                        color: _whotohighlight(
                                false,
                                widget._timeString,
                                widget.snapshot.data.dhuhr,
                                widget.snapshot.data.aasr)
                            ? Colors.green
                            : Colors.black,
                      ),
                    )
                  ],
                ),
                // THIRD SALET ROW
                Row(
                  children: [
                    SizedBox(
                      width: 400.w,
                    ),
                    Text('Aasr',
                        style: TextStyle(
                          color: _whotohighlight(
                                  false,
                                  widget._timeString,
                                  widget.snapshot.data.aasr,
                                  widget.snapshot.data.maghrib)
                              ? Colors.green
                              : Colors.black,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w800,
                        )),
                    Spacer(),
                    Text(
                      widget.snapshot.data.aasr,
                      style: TextStyle(
                        color: _whotohighlight(
                                false,
                                widget._timeString,
                                widget.snapshot.data.aasr,
                                widget.snapshot.data.maghrib)
                            ? Colors.green
                            : Colors.black,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
                // FOURTH SALET ROW
                Row(
                  children: [
                    SizedBox(
                      width: 400.w,
                    ),
                    Text('Maghrib',
                        style: TextStyle(
                            color: _whotohighlight(
                                    false,
                                    widget._timeString,
                                    widget.snapshot.data.maghrib,
                                    widget.snapshot.data.isha)
                                ? Colors.green
                                : Colors.black,
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w800)),
                    Spacer(),
                    Text(
                      widget.snapshot.data.maghrib,
                      style: TextStyle(
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w800,
                        color: _whotohighlight(
                                false,
                                widget._timeString,
                                widget.snapshot.data.maghrib,
                                widget.snapshot.data.isha)
                            ? Colors.green
                            : Colors.black,
                      ),
                    )
                  ],
                ),
                // FIFTH SALET ROW
                Row(
                  children: [
                    SizedBox(
                      width: 400.w,
                    ),
                    Text('Isha',
                        style: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w800,
                          color: _whotohighlight(
                                  true,
                                  widget._timeString,
                                  widget.snapshot.data.isha,
                                  widget.snapshot.data.fajr)
                              ? Colors.green
                              : Colors.black,
                        )),
                    Spacer(),
                    Text(
                      widget.snapshot.data.isha,
                      style: TextStyle(
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w800,
                        color: _whotohighlight(
                                true,
                                widget._timeString,
                                widget.snapshot.data.isha,
                                widget.snapshot.data.fajr)
                            ? Colors.green
                            : Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.snapshot.data.hijriDayNumber,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 55.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.snapshot.data.gregorianDayName +
                              " " +
                              widget.snapshot.data.gregorianDayNumber,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 45.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        children: [
                          Text(
                            widget.snapshot.data.hijriMonthEN,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 55.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.snapshot.data.gregorianMonth,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 45.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(widget.snapshot.data.hijriYear,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 55.sp,
                                fontWeight: FontWeight.bold)),
                        Text(
                          widget.snapshot.data.gregorianYear,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 45.sp,
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
    );
  }
}
