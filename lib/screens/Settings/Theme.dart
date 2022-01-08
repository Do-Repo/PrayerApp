import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:application_1/src/customWidgets/payment_service.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      appBar: customAppbar(
          context, false, AppLocalizations.of(context)!.theme, false),
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
              AppLocalizations.of(context)!.darkMode,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Stack(
              children: [
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.color_lens_outlined,
                          size: 100.sp,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.darkMode,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20.sp),
                        child: Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(
                                colorsList.length,
                                (int index) => InkWell(
                                      onTap: () {
                                        themeChange.color = index;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: colorsList[index],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    ))),
                      )
                    ],
                  ),
                ),
                if (!appData.isPro) ReqSubscription()
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}

List<Color> colorsList = [
  Colors.green,
  Colors.purple,
  Colors.blue[900]!,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.red,
];
