import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    var option = Provider.of<AdvancedSettingsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          children: [
            Icon(
              Icons.translate_outlined,
              size: 300.sp,
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.language,
                style: TextStyle(fontSize: 55.sp, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(AppLocalizations.of(context)!.languagesub),
            ),
            SizedBox(
              height: 50.sp,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        option.languageOption = 0;
                      },
                      trailing: (option.languageOption == 0)
                          ? Icon(Icons.done)
                          : SizedBox(),
                      title: Text("English"),
                      subtitle: Text("English US"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/usa.png"),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        option.languageOption = 1;
                      },
                      trailing: (option.languageOption == 1)
                          ? Icon(Icons.done)
                          : SizedBox(),
                      title: Text("Nederlands"),
                      subtitle: Text("Nederlands NL"),
                      leading: RotatedBox(
                        quarterTurns: 3,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/france.png"),
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        option.languageOption = 2;
                      },
                      trailing: (option.languageOption == 2)
                          ? Icon(Icons.done)
                          : SizedBox(),
                      title: Text("Français "),
                      subtitle: Text("Français FR"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/france.png"),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        option.languageOption = 3;
                      },
                      trailing: (option.languageOption == 3)
                          ? Icon(Icons.done)
                          : SizedBox(),
                      title: Text("Deutsch "),
                      subtitle: Text("Deutsch DE"),
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/germany.png"),
                      ),
                    ),
                  ],
                ),
              )),
            ),
            TextButton(
                onPressed: () {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.sp),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        AppLocalizations.of(context)!.continuee,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
