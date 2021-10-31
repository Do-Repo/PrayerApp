import 'dart:math';
import 'package:application_1/models/QuranModel.dart';
import 'package:application_1/screens/VirtualImam/ScreenStructure.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FirstPart extends StatefulWidget {
  const FirstPart({Key? key, required this.tabController}) : super(key: key);
  final TabController tabController;
  @override
  _FirstPartState createState() => _FirstPartState();
}

class _FirstPartState extends State<FirstPart> {
  String _currentValue = prayers.first;

  Future<List<QuranPicker>>? _future;
  late PrayerSettings settingsProvider;
  @override
  void initState() {
    super.initState();
    _future = getSurahTitles();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      settingsProvider = Provider.of(context, listen: false);
      settingsProvider.changeRakaat(_currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1.sw,
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                value: _currentValue,
                items: prayers.map(
                  (String value) {
                    return DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 55.sp),
                      ),
                      value: value,
                    );
                  },
                ).toList(),
                onChanged: (String? newVal) {
                  setState(() {
                    _currentValue = newVal!;
                    settingsProvider.changeRakaat(_currentValue);
                  });
                },
              ),
            ),
          ),
        ),
        Flexible(
          child: FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot<List<QuranPicker>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Row(
                  children: [
                    Flexible(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: LinearProgressIndicator(
                          color: Colors.green,
                          value: null,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Text(
                        getInfo(_currentValue).rakaat.toString(),
                        style: TextStyle(
                          fontSize: 150.sp,
                        ),
                      ),
                    ),
                    Flexible(
                      child: LinearProgressIndicator(
                        color: Colors.green,
                        value: null,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Container(
                    height: 500.h,
                    width: 1.sw,
                    child: Center(
                      child: Text('Error loading data',
                          style: TextStyle(color: Colors.red, fontSize: 60.sp)),
                    ));
              } else
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: LinearProgressIndicator(
                              color: Colors.green,
                              value: 100,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Text(
                            getInfo(_currentValue).rakaat.toString(),
                            style: TextStyle(
                              fontSize: 150.sp,
                            ),
                          ),
                        ),
                        Flexible(
                          child: LinearProgressIndicator(
                            color: Colors.green,
                            value: 100,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          return SettingsCard(
                            index: i,
                            snapList: snapshot.data!.toList(),
                          );
                        },
                        itemCount: getInfo(_currentValue).rakaat,
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        InkWell(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            widget.tabController.animateTo(1);
                          },
                          child: Container(
                            margin: EdgeInsets.all(30.sp),
                            width: 300.w,
                            height: 100.h,
                            child: Center(child: Text("Next")),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                          ),
                        ),
                      ],
                    )
                  ],
                );
            },
          ),
        ),
      ],
    );
  }
}

class SettingsCard extends StatefulWidget {
  const SettingsCard({Key? key, required this.snapList, required this.index})
      : super(key: key);
  final int index;
  final List<QuranPicker> snapList;
  // SnapList was required as a bug fix, since the widgets rebuild many times
  // the list fills up again at the end of the list, causing multiple lists in one list

  @override
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  Random rng = Random();
  String? title;
  late int i;
  late PrayerSettings settingsProvider;

  @override
  void initState() {
    super.initState();
    i = rng.nextInt(100) + 10;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      settingsProvider = Provider.of(context, listen: false);
      settingsProvider.changeIndex(widget.index, i + 1);
      settingsProvider.changeName(
          widget.index, widget.snapList[i].name.toString());
      settingsProvider.changeAyahs(
          widget.index, 1, widget.snapList[i].numberOfAyahs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(((widget.index + 1) == 1)
                  ? "First rak'ah"
                  : (widget.index + 1) == 2
                      ? "Second rak'ah"
                      : (widget.index + 1) == 3
                          ? "Third rak'ah"
                          : "Fourth rak'ah"),
              Text(((widget.index + 1) == 1)
                  ? "الركعة الأولى"
                  : (widget.index + 1) == 2
                      ? "الركعة الثانية"
                      : (widget.index + 1) == 3
                          ? "الركعة الثالثة"
                          : "الركعة الرابعة"),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(widget.snapList.first.name),
              trailing: Icon(Icons.done),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ExpansionTile(
              title: Text(title ?? widget.snapList[i].name),
              children: [
                Container(
                  width: 1.sw,
                  height: 600.h,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, x) {
                        return ListTile(
                          title: Text(
                              "${x + 1}- ${widget.snapList[x].name.toString()}"),
                          onTap: () {
                            setState(() {
                              title = widget.snapList[x].name.toString();
                              settingsProvider.changeName(widget.index,
                                  widget.snapList[x].name.toString());
                              settingsProvider.changeIndex(
                                  widget.index,
                                  widget.snapList.indexWhere(
                                          (element) => element.name == title) +
                                      1);
                              settingsProvider.changeAyahs(
                                  widget.index,
                                  1,
                                  widget
                                      .snapList[widget.snapList.indexWhere(
                                          (element) => element.name == title)]
                                      .numberOfAyahs);
                            });
                          },
                        );
                      },
                      itemCount: widget.snapList.length,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(20.sp),
                  color: Theme.of(context).accentColor,
                  height: 3.sp,
                ),
              ),
              SizedBox(
                width: 100.sp,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(20.sp),
                  color: Theme.of(context).accentColor,
                  height: 3.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<String> prayers = ["Fajr", "Dhuhr", "Aasr", "Maghrib", "Ishaa"];

class PrayerInfo {
  int? rakaat = 0;
  bool? optional = false;
  String? optionalName = "";
  int? optionalRakaat = 0;

  PrayerInfo(
      {this.rakaat, this.optional, this.optionalName, this.optionalRakaat});
}

PrayerInfo getInfo(String name) {
  switch (name) {
    case 'Fajr':
      return PrayerInfo(rakaat: 2);
    case 'Dhuhr':
      return PrayerInfo(rakaat: 4);
    case 'Aasr':
      return PrayerInfo(rakaat: 4);
    case 'Maghrib':
      return PrayerInfo(rakaat: 3);
    case 'Ishaa':
      return PrayerInfo(rakaat: 4);
    default:
      return PrayerInfo();
  }
}
