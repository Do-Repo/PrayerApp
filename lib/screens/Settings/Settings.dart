import 'package:application_1/screens/Settings/AdsSettingsPage.dart';
import 'package:application_1/screens/Settings/AdvancedSettings.dart';
import 'package:application_1/screens/Settings/Recitation.dart';
import 'package:application_1/screens/Settings/Theme.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
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
      appBar: customAppbar(context, false, "Settings", false),
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
                Icons.ad_units_outlined,
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
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdsSettingsPage())),
            ),
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                size: 100.sp,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdvancedSettings()));
              },
              title: Text(
                "Advanced",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Advanced application settings",
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
          ],
        ),
      ),
    );
  }
}
