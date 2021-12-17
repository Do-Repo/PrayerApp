import 'package:application_1/screens/Settings/Settings.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar customAppbar(
    BuildContext context, bool isImage, String title, bool showSettings) {
  return AppBar(
    centerTitle: false,
    title: (isImage)
        ? Image.asset(
            title,
            scale: 13,
          )
        : Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
    elevation: 0,
    iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.secondary, size: 100.sp),
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

Widget customErrorWidget() {
  return ListTile(
      leading: Icon(
        customIcon.MyFlutterApp.miscellaneous,
        size: 150.sp,
      ),
      title: Text("API request failed..."),
      subtitle: Text(
          "No result received from the API, this is not our fault but we're reaching out to the API owners"));
}
