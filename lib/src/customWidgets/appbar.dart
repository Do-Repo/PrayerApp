import 'package:application_1/screens/Settings/Settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar customAppbar(
    BuildContext context, bool isImage, String title, bool showSettings) {
  return AppBar(
    centerTitle: false,
    title: (isImage)
        ? Image.asset(title)
        : Text(
            title,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
    elevation: 0,
    iconTheme:
        IconThemeData(color: Theme.of(context).accentColor, size: 100.sp),
    actions: [
      (showSettings)
          ? IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
              },
              icon: Icon(
                Icons.settings_outlined,
                size: 90.sp,
              ))
          : Container()
    ],
  );
}
