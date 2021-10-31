import 'package:application_1/main.dart';
import 'package:application_1/screens/VirtualImam/FirstPage.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VirtualImam extends StatefulWidget {
  const VirtualImam({Key? key}) : super(key: key);

  @override
  _VirtualImamState createState() => _VirtualImamState();
}

class _VirtualImamState extends State<VirtualImam>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PrayerSettings>(
      create: (context) => PrayerSettings(),
      child: Consumer<PrayerSettings>(
        builder: (context, settingsProvider, child) => Scaffold(
          appBar: customAppbar(context),
          body: Column(
            children: [
              ListTile(
                isThreeLine: true,
                leading: Icon(
                  Icons.warning_amber_outlined,
                  color: Theme.of(context).accentColor,
                  size: 200.sp,
                ),
                title: Text("Please check:"),
                subtitle: Text(
                    "That you're connected to a stable network, a unstable connection may cause interruption"),
              ),
              Divider(
                color: Theme.of(context).accentColor,
              ),
              Flexible(
                  child: TabBarView(
                      controller: tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                    FirstPart(
                      tabController: tabController,
                    ),
                    SecondPart(),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPart extends StatefulWidget {
  const SecondPart({
    Key? key,
  }) : super(key: key);

  @override
  _SecondPartState createState() => _SecondPartState();
}

class _SecondPartState extends State<SecondPart> {
  @override
  Widget build(BuildContext context) {
    PrayerSettings settingsProvider = Provider.of(context, listen: false);
    RecitationProvider rec = Provider.of<RecitationProvider>(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          children: [
            ListTile(
              title: Text("Set up ayah's"),
              subtitle: Text(
                  "Choose how many and which ayah's you want to recite during your prayers"),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    getInfo(settingsProvider.rakaat).rakaat!,
                    (i) => FutureBuilder(
                        future: getAyahAR(
                            settingsProvider.surah[i], rec.recitation),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LinearProgressIndicator(
                                    color: Colors.green,
                                  ),
                                  Text(
                                    "loading preview...",
                                    style: TextStyle(fontSize: 25.sp),
                                  ),
                                  Container(
                                    height: 200.h,
                                  )
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                                height: 300.h,
                                child: Text(
                                  "Error loading data",
                                  style: TextStyle(color: Colors.red),
                                ));
                          } else {
                            settingsProvider.changeSelectedAyahs(
                                i,
                                settingsProvider.ayahs[i]![0],
                                settingsProvider.ayahs[i]![1]);
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: ConfigureAyah(
                                index: i,
                                begin: settingsProvider.ayahs[i]![0].toDouble(),
                                end: settingsProvider.ayahs[i]![1].toDouble(),
                                snapshot: snapshot,
                              ),
                            );
                          }
                        })),
              ),
            )),
            Row(
              children: [
                Spacer(),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    print(
                        "${settingsProvider.selectedAyahs[0]![0].toString()}..${settingsProvider.selectedAyahs[0]![1].toString()}");
                    print(
                        "${settingsProvider.selectedAyahs[1]![0].toString()}..${settingsProvider.selectedAyahs[1]![1].toString()}");
                    print(
                        "${settingsProvider.selectedAyahs[2]![0].toString()}..${settingsProvider.selectedAyahs[2]![1].toString()}");
                    print(
                        "${settingsProvider.selectedAyahs[3]![0].toString()}..${settingsProvider.selectedAyahs[3]![1].toString()}");
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
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class ConfigureAyah extends StatefulWidget {
  const ConfigureAyah(
      {Key? key,
      required this.index,
      required this.begin,
      required this.end,
      required this.snapshot})
      : super(key: key);
  final double begin, end;
  final AsyncSnapshot snapshot;
  final int index;
  @override
  _ConfigureAyahState createState() => _ConfigureAyahState();
}

class _ConfigureAyahState extends State<ConfigureAyah> {
  late RangeValues _values;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _values = RangeValues(widget.begin, widget.end);
  }

  int height = 500;

  @override
  Widget build(BuildContext context) {
    PrayerSettings settingsProvider =
        Provider.of<PrayerSettings>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            title: Text(
          settingsProvider.name[widget.index],
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500,
              fontSize: 60.sp),
        )),
        Container(
          height: 500.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: RichText(
                    text: TextSpan(
                        children: writeSurah(widget.snapshot, context,
                            _values.start, _values.end)),
                  ),
                ),
              ),
              Divider(),
              Directionality(
                textDirection: TextDirection.ltr,
                child: SliderTheme(
                  data: SliderThemeData(
                      inactiveTickMarkColor: Theme.of(context).primaryColor,
                      activeTickMarkColor: Theme.of(context).accentColor,
                      showValueIndicator: ShowValueIndicator.always,
                      activeTrackColor: Theme.of(context).accentColor,
                      thumbColor: Theme.of(context).accentColor,
                      inactiveTrackColor:
                          Theme.of(context).accentColor.withOpacity(0.2)),
                  child: RangeSlider(
                    values: _values,
                    divisions: _values.end.toInt(),
                    min: widget.begin,
                    max: widget.end,
                    labels: RangeLabels(
                      _values.start.round().toString(),
                      _values.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        if (values.end - values.start >= 2)
                          _values = values;
                        else {
                          if (_values.start == values.start)
                            _values =
                                RangeValues(_values.start, _values.start + 2);
                          else
                            _values = RangeValues(_values.end - 2, _values.end);
                        }
                      });
                    },
                    onChangeEnd: (RangeValues val) {
                      settingsProvider.changeSelectedAyahs(
                          widget.index, val.start.round(), val.end.round());
                    },
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        ),
      ],
    );
  }
}

List<TextSpan> writeSurah(
    AsyncSnapshot snapshot, BuildContext context, double begin, double end) {
  List<TextSpan> reasonList = [];
  snapshot.data!.forEach((element) {
    reasonList.add(TextSpan(
        text: "${element.ayah} ۝ ",
        style: TextStyle(
            color:
                (reasonList.length < begin - 1 || reasonList.length > end - 1)
                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor)));
  });
  return reasonList;
}

class PrayerSettings extends ChangeNotifier {
  List<String> name = ["", "", "", ""];
  String rakaat = "";
  List<int> surah = [0, 0, 0, 0];
  Map<int, List<int>> ayahs = {
    0: [0, 0],
    1: [0, 0],
    2: [0, 0],
    3: [0, 0],
  };
  Map<int, List<int>> selectedAyahs = {
    0: [0, 0],
    1: [0, 0],
    2: [0, 0],
    3: [0, 0],
  };
  void changeRakaat(String sl) {
    rakaat = sl;
    notifyListeners();
  }

  void changeSelectedAyahs(int i, int begin, int end) {
    selectedAyahs.update(i, (value) => value = [begin, end]);
  }

  void changeIndex(int i, int index) {
    surah[i] = index;
    notifyListeners();
  }

  void changeName(int i, String nm) {
    name[i] = nm;
    notifyListeners();
  }

  void changeAyahs(int i, int begin, int end) {
    ayahs.update(i, (value) => value = [begin, end]);
    notifyListeners();
  }
}
