import 'package:application_1/main.dart';
import 'package:application_1/screens/Homepage.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;
  @override
  _DarkModePageState createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            widget.pageController.previousPage(
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          children: [
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.godarkmode,
                style: TextStyle(fontSize: 55.sp, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(AppLocalizations.of(context)!.godarkmodesub),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: (themeChange.darkTheme)
                    ? Image.asset(
                        "assets/images/lampOff.png",
                      )
                    : Image.asset(
                        "assets/images/lampOn.png",
                      ),
                onTap: () {
                  setState(() {
                    if (themeChange.darkTheme) {
                      themeChange.darkTheme = false;
                    } else {
                      themeChange.darkTheme = true;
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 50.sp,
            ),
            TextButton(
                onPressed: () async {
                  await checkIfFirstTime(true);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        AppLocalizations.of(context)!.continuee,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }
}
