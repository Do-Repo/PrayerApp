import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: customAppbar(
          context, false, AppLocalizations.of(context)!.theme, false),
      body: Column(
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
              AppLocalizations.of(context)!.darkMode,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
