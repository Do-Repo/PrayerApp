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
          AnimatedCrossFade(
            duration: Duration(seconds: 1),
            crossFadeState: (widget.tabcontroller?.index == 0)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Container(),
            secondChild: ListTile(
              title: Text(
                "Home",
                style: TextStyle(fontSize: 65.sp, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                customIcon.MyFlutterApp.mosque,
                size: 130.sp,
              ),
              onTap: () {
                widget.tabcontroller!.animateTo(0);
                Navigator.pop(context);
              },
              subtitle: Text(
                "Return to homepage",
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          CustomTile(
            icon: customIcon.MyFlutterApp.quran,
            title: "Quran",
            subtitle: "Read the holy Quran",
            children:
                getQuranlist(widget.tabcontroller, context) as List<Widget>,
          ),
          CustomTile(
              title: "Hadith",
              subtitle: "Collection of all books",
              icon: customIcon.MyFlutterApp.muslim,
              children:
                  getHadithList(widget.tabcontroller, context) as List<Widget>),
          ListTile(
            title: Text(
              "Qiblah",
              style: TextStyle(fontSize: 70.sp, fontWeight: FontWeight.w600),
            ),
            leading: Icon(
              customIcon.MyFlutterApp.kaaba,
              size: 130.sp,
            ),
            onTap: () {
              widget.tabcontroller!.animateTo(5);
              Navigator.pop(context);
            },
            subtitle: Text(
              "Qiblah direction",
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}

List getQuranlist(TabController? tabController, BuildContext context) {
  return <Widget>[
    ListTile(
      title: Text(
        "In Arabic",
        style: TextStyle(fontSize: 50.sp),
      ),
      onTap: () {
        tabController!.animateTo(1);
        Navigator.pop(context);
      },
      subtitle: Text("Original Quran"),
      trailing: Icon(Icons.arrow_forward_ios),
    ),
    ListTile(
      title: Text(
        "In English",
        style: TextStyle(fontSize: 50.sp),
      ),
      subtitle: Text("Translated Quran"),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        tabController!.animateTo(2);
        Navigator.pop(context);
      },
    )
  ];
}

List getHadithList(TabController? tabController, BuildContext context) {
  return <Widget>[
    ListTile(
      title: Text(
        "In Arabic",
        style: TextStyle(fontSize: 50.sp),
      ),
      subtitle: Text('Original Hadith'),
      onTap: () {
        tabController!.animateTo(4);
        Navigator.pop(context);
      },
      trailing: Icon(Icons.arrow_forward_ios),
    ),
    ListTile(
      title: Text(
        "In English",
        style: TextStyle(fontSize: 50.sp),
      ),
      subtitle: Text('Translated Hadith'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        tabController!.animateTo(3);
        Navigator.pop(context);
      },
    )
  ];
}
