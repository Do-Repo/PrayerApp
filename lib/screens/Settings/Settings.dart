import 'package:application_1/screens/Settings/AdsSettingsPage.dart';
import 'package:application_1/screens/Settings/AdvancedSettings.dart';
import 'package:application_1/screens/Settings/Recitation.dart';
import 'package:application_1/screens/Settings/Theme.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: customAppbar(
          context, false, AppLocalizations.of(context)!.settings, false),
      body: Container(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.color_lens_outlined,
                size: 100.sp,
              ),
              title: Text(
                AppLocalizations.of(context)!.theme,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.themesub,
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
                AppLocalizations.of(context)!.recitation,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.recitationsub,
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
                AppLocalizations.of(context)!.ads,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.adssub,
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
                AppLocalizations.of(context)!.advanced,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.advancedsub,
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.report_problem_outlined,
            //     size: 100.sp,
            //   ),
            //   title: Text(
            //     AppLocalizations.of(context)!.report,
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   subtitle: Text(
            //     AppLocalizations.of(context)!.reportsub,
            //   ),
            // ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
