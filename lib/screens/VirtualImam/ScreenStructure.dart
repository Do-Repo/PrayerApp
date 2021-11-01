import 'package:application_1/screens/VirtualImam/FirstPage.dart';
import 'package:application_1/screens/VirtualImam/SecondPage.dart';
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
                    SecondPart(
                      tabController: tabController,
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}

class ThirdPart extends StatefulWidget {
  const ThirdPart({Key? key}) : super(key: key);

  @override
  _ThirdPartState createState() => _ThirdPartState();
}

class _ThirdPartState extends State<ThirdPart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
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
