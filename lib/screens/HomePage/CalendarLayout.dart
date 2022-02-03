import 'package:application_1/models/eventModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key? key,
  }) : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> events = ({});
  ValueNotifier<bool> showbutton = ValueNotifier(false);
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    tabController = TabController(length: 2, vsync: this);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    showbutton.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
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
                    _focusedDay = DateTime.now();
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
      body: Column(
        children: [
          TableCalendar<Event>(
            pageJumpingEnabled: true,
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onPageChanged: (focusedDay) {
              (DateFormat("yyyy-MM-dd").format(focusedDay) !=
                      DateFormat("yyyy-MM-dd").format(DateTime.now()))
                  ? showbutton.value = true
                  : showbutton.value = false;
            },
            calendarBuilders: calendarBuilder(),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            headerStyle: headerStyle(context),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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

CalendarBuilders<Event> calendarBuilder() {
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
    selectedBuilder: (context, day, focusedDay) {
      return Container(
        color: Color(0xFFF4D8CD).withOpacity(0.5),
        child: Center(
          child: RichText(
              text: TextSpan(
                  children: [
                TextSpan(
                    text: '\n${HijriCalendar.fromDate(day).toFormat("d")}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 45.sp))
              ],
                  text: DateFormat.d().format(day).toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 40.sp))),
        ),
      );
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
