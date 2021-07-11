import 'package:application_1/models/QuranModel.dart';

import 'package:application_1/src/cards/ExpandedTile/TileStructure.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({Key? key, required TabController? tabController})
      : tabcontroller = tabController,
        super(key: key);
  final TabController? tabcontroller;
  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  Future<QuranPicker>? cardmodel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool open = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800.w,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text('Drawer Header'),
          ),
          CustomTile(
            icon: customIcon.MyFlutterApp.quran,
            title: "Quran",
            subtitle: "Read the holy Quran",
            children:
                getQuranlist(widget.tabcontroller, context) as List<Widget>,
          ),
        ],
      ),
    );
  }
}

List getQuranlist(TabController? tabController, BuildContext context) {
  return <Widget>[
    ListTile(
      leading: Icon(
        customIcon.MyFlutterApp.rub_el_hizb,
        size: 100.sp,
      ),
      title: Text(
        "In Arabic",
        style: TextStyle(fontSize: 50.sp),
      ),
      onTap: () {
        tabController!.animateTo(3);
        Navigator.pop(context);
      },
      subtitle: Text("Original Quran"),
      trailing: Icon(Icons.arrow_forward_ios),
    ),
    ListTile(
      leading: Icon(
        customIcon.MyFlutterApp.rub_el_hizb,
        size: 100.sp,
      ),
      title: Text(
        "In English",
        style: TextStyle(fontSize: 50.sp),
      ),
      subtitle: Text("Translated Quran"),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        tabController!.animateTo(4);
        Navigator.pop(context);
      },
    )
  ];
}
