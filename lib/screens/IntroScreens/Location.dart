import 'package:application_1/screens/Settings/AdvancedSettings.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var option = Provider.of<AdvancedSettingsProvider>(context, listen: false);
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
            Icon(
              Icons.location_on_outlined,
              size: 300.sp,
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.allowloc,
                style: TextStyle(fontSize: 55.sp, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(AppLocalizations.of(context)!.allowlocsub),
            ),
            SizedBox(
              height: 50.sp,
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  option.locationOption = 2;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MapInterface()));
                  Future.delayed(Duration(milliseconds: 300)).then((val) =>
                      widget.pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.sp),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        AppLocalizations.of(context)!.setmanually,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: Container(
                  height: 2.sp,
                  width: 300.w,
                  color: Theme.of(context).colorScheme.secondary,
                )),
                Text(
                  "  " + AppLocalizations.of(context)!.or + "  ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Flexible(
                    child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                  height: 2.sp,
                  width: 300.w,
                )),
              ],
            ),
            TextButton(
                onPressed: () async {
                  option.locationOption = 0;
                  Permission.locationWhenInUse.request();
                  await Permission.locationWhenInUse.status
                      .then((status) async {
                    if (status.isGranted) {
                      print("status granted");
                      widget.pageController.animateToPage(2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    }
                    if (status.isDenied) {
                      Permission.locationWhenInUse.request();
                    }
                    if (status.isRestricted || status.isPermanentlyDenied) {
                      Permission.locationWhenInUse.isRestricted;
                      await openAppSettings();
                    }
                    Future.delayed(Duration(milliseconds: 200)).then((value) =>
                        widget.pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut));
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.sp),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        AppLocalizations.of(context)!.allowloc,
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

  @override
  bool get wantKeepAlive => true;
}
