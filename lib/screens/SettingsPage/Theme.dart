import 'package:flutter/material.dart';
import 'package:application_1/src/themeData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Theme"),
          elevation: 0,
        ),
        body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.dark_mode_outlined,
                  size: 100.sp,
                ),
                trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: themeChange.darkTheme,
                  onChanged: (val) {
                    themeChange.darkTheme = val;
                  },
                ),
                title: Text(
                  "DarkMode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]));
  }
}
