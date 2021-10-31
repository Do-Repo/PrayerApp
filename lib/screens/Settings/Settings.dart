import 'package:application_1/main.dart';
import 'package:application_1/screens/Settings/Recitation.dart';
import 'package:application_1/screens/Settings/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final rec = Provider.of<RecitationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 60.sp),
        ),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 100.sp,
                ));
          },
        ),
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Container(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.color_lens_outlined,
                size: 100.sp,
              ),
              title: Text(
                "Theme",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Customize app appearance",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThemeScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.record_voice_over_outlined,
                size: 100.sp,
              ),
              title: Text(
                "Recitation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Change recitation voice for audio Quran",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecitationScreen(
                        recitation: rec.recitation,
                      ),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.highlight_off,
                size: 100.sp,
              ),
              title: Text(
                "Ads",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Ads settings",
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.monetization_on_outlined,
                size: 100.sp,
              ),
              title: Text(
                "Donate",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Buy me a coffee :)",
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                size: 100.sp,
              ),
              title: Text(
                "About",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Learn more about us",
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.report_problem_outlined,
                size: 100.sp,
              ),
              title: Text(
                "Report a problem",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Report a problem, bug or feedback",
              ),
            ),
            Spacer(),
            Text("Yasine Romdhane"),
            Text("All rights reserved 2021 - 2022"),
          ],
        ),
      ),
    );
  }
}
