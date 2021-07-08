import 'package:application_1/src/cards/PrayerTimes/CardStructure.dart';
import 'package:application_1/src/cards/QuranCard/CardStructure.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    @required TabController tabcontroller,
  })  : tabs = tabcontroller,
        super(key: key);
  final TabController tabs;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        PrayertimesCard(),
        SizedBox(
          height: 40.sp,
        ),
        QuranCard(
          tabController: widget.tabs,
        )
      ]),
    );
  }
}
