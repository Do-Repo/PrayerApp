import 'package:application_1/screens/Settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar customAppbar(BuildContext context) {
  return AppBar(
    centerTitle: false,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.green, size: 100.sp),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            ));
          },
          icon: Icon(
            Icons.settings_outlined,
            size: 90.sp,
          ))
    ],
  );
}
