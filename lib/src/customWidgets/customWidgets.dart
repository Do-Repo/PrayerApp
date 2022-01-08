import 'package:application_1/screens/Settings/AdsSettingsPage.dart';
import 'package:application_1/screens/Settings/NotificationSettings.dart';
import 'package:application_1/screens/Settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Widget customHomeAppbar(BuildContext context, PageController pageController,
    String title, bool hasButton, VoidCallback function) {
  var st = Provider.of<HomePageEffects>(context, listen: true);
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    padding: EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            (title != AppLocalizations.of(context)!.home)
                ? InkWell(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOutQuart);
                    },
                  )
                : InkWell(
                    onTap: () {
                      st.onCollapsed = !st._collapsed;
                    },
                    child: SizedBox(
                      child: (st._collapsed)
                          ? Icon(Icons.arrow_circle_down_outlined)
                          : Icon(Icons.arrow_circle_up_outlined),
                      width: 48 + 30.sp,
                    ),
                  ),
            if (hasButton)
              SizedBox(
                width: 24,
              ),
          ],
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title == AppLocalizations.of(context)!.home)
              InkWell(
                child: Icon(Icons.notifications_outlined),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationSettings()));
                },
              ),
            if (title == AppLocalizations.of(context)!.home)
              SizedBox(
                width: 30.sp,
              ),
            if (hasButton)
              InkWell(
                child: Icon(Icons.translate_outlined),
                onTap: function,
              ),
            if (hasButton)
              SizedBox(
                width: 30.sp,
              ),
            InkWell(
              child: Icon(Icons.settings_outlined),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
              },
            ),
          ],
        ),
      ],
    ),
  );
}

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

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key, required this.function})
      : super(key: key);
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: function,
      title: Text(
        AppLocalizations.of(context)!.errortitlecon,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50.sp),
      ),
      subtitle: Text(AppLocalizations.of(context)!.errorsubcon),
      leading: Icon(
        customIcon.MyFlutterApp.no_wifi,
        size: 200.sp,
      ),
    );
  }
}

class ReqSubscription extends StatelessWidget {
  const ReqSubscription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  AppLocalizations.of(context)!.requiressubtitle,
                  style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(AppLocalizations.of(context)!.requiressub),
                leading: Icon(
                  Icons.app_blocking_outlined,
                  size: 150.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AdsSettingsPage()));
                },
                child: Text(
                  AppLocalizations.of(context)!.subscribe,
                  style: TextStyle(fontSize: 50.sp),
                ))
          ],
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      height: double.infinity,
      width: double.infinity,
    );
  }
}

class SomethingWrong extends StatelessWidget {
  const SomethingWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(
        AppLocalizations.of(context)!.somethingwrong,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50.sp),
      ),
      subtitle: Text(AppLocalizations.of(context)!.sometingwrongsub),
      leading: Icon(
        Icons.error_outline_outlined,
        size: 200.sp,
      ),
    );
  }
}

class HomePageEffects with ChangeNotifier {
  bool _error = false;
  bool _collapsed = false;

  bool get onError => _error;
  bool get onCollapsed => _collapsed;

  set onError(bool value) {
    _error = value;
    notifyListeners();
  }

  set onCollapsed(bool value) {
    _collapsed = value;
    notifyListeners();
  }
}
