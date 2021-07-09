import 'package:application_1/models/QuranModel.dart';

import 'package:application_1/src/cards/ExpandedTile/TileStructure.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({Key key}) : super(key: key);

  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  Future<QuranPicker> cardmodel;
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
              title: "Quran", apiLink: "http://api.alquran.cloud/v1/surah"),
        ],
      ),
    );
  }
}
