import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  ValueNotifier<bool> showbutton = ValueNotifier(false);
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    showbutton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: showbutton,
        builder: (context, value, child) {
          return AnimatedCrossFade(
              firstChild: InkWell(
                onTap: () {
                  setState(() {
                    focusedDay = DateTime.now();
                  });
                },
                child: BackButton(),
              ),
              secondChild: SizedBox(),
              crossFadeState: (value)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 200));
        },
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text("Calendar "),
      ),
      body: TableCalendar(
        pageJumpingEnabled: true,
        onDaySelected: (selectedDay, focusedDay) {},
        onPageChanged: (focusedDay) {
          (DateFormat("yyyy-MM-dd").format(focusedDay) !=
                  DateFormat("yyyy-MM-dd").format(DateTime.now()))
              ? showbutton.value = true
              : showbutton.value = false;
        },
        calendarBuilders: calendarBuilder(),
        headerStyle: headerStyle(context),
        calendarStyle: CalendarStyle(
            cellMargin: EdgeInsets.all(0),
            todayDecoration:
                BoxDecoration(color: Theme.of(context).colorScheme.secondary)),
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.sp),
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.secondary,
          boxShadow: const [
            BoxShadow(
                blurRadius: 4, color: Colors.black, blurStyle: BlurStyle.outer)
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 80.sp,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Today",
              style: TextStyle(
                  fontSize: 50.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

HeaderStyle headerStyle(BuildContext context) {
  return HeaderStyle(
      headerPadding: EdgeInsets.zero,
      headerMargin: EdgeInsets.only(bottom: 30.sp),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      leftChevronIcon: Icon(
        Icons.chevron_left_sharp,
        color: Colors.white,
      ),
      rightChevronIcon: Icon(
        Icons.chevron_right_sharp,
        color: Colors.white,
      ),
      formatButtonDecoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, color: Colors.white)),
      formatButtonTextStyle: TextStyle(color: Colors.white),
      formatButtonShowsNext: false,
      titleTextStyle: TextStyle(color: Colors.white));
}

CalendarBuilders calendarBuilder() {
  return CalendarBuilders(
    headerTitleBuilder: (context, day) {
      // Header showing Gregorian month/year and Hijri month/year under eachother
      return RichText(
          text: TextSpan(
              children: [
            TextSpan(
                text: '\n${HijriCalendar.fromDate(day).toFormat("MMMM yyyy")}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 45.sp))
          ],
              text: DateFormat.yMMMM().format(day).toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 40.sp)));
    },
    defaultBuilder: (context, day, focusedDay) {
      return Center(
        child: RichText(
            text: TextSpan(
                children: [
              TextSpan(
                  text: '\n${HijriCalendar.fromDate(day).toFormat("d")}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 45.sp))
            ],
                text: DateFormat.d().format(day).toString(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 40.sp))),
      );
    },
    outsideBuilder: (context, day, focusedDay) {
      return Center(
        child: RichText(
            text: TextSpan(
                children: [
              TextSpan(
                  text: '\n${HijriCalendar.fromDate(day).toFormat("d")}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      fontWeight: FontWeight.w500,
                      fontSize: 45.sp))
            ],
                text: DateFormat.d().format(day).toString(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    fontWeight: FontWeight.w300,
                    fontSize: 40.sp))),
      );
    },
    todayBuilder: (context, day, focusedDay) {
      return Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Center(
          child: RichText(
              text: TextSpan(
                  children: [
                TextSpan(
                    text: '\n${HijriCalendar.fromDate(day).toFormat("d")}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 45.sp))
              ],
                  text: DateFormat.d().format(day).toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 40.sp))),
        ),
      );
    },
  );
}
