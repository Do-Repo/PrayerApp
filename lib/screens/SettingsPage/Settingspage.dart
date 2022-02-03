import 'package:application_1/screens/SettingsPage/NotificationSettings.dart';
import 'package:application_1/screens/SupportScreen/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:application_1/screens/SettingsPage/AdvancedSettings.dart';
import 'package:application_1/screens/SettingsPage/Recitation.dart';
import 'package:application_1/screens/SettingsPage/Theme.dart';
import 'package:application_1/screens/SupportScreen/SupportPage.dart';
import 'package:application_1/src/advancedSettings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  late RewardedAd rewardedAd;
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    RewardedAd.load(
        adUnitId: 'ca-app-pub-1433006549087304/9256191306',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            setState(() {
              loaded = true;
            });
            this.rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final rec = context.select((AdvancedSettingsProvider a) => a.recitation);
    return Scaffold(
        appBar: AppBar(title: Text("Settings"), elevation: 0),
        body: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.color_lens_outlined,
                size: 80.sp,
              ),
              title: Text(
                "Theme",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
                size: 80.sp,
              ),
              title: Text(
                "Recitation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecitationScreen(
                        recitation: rec,
                      ),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.notification_important_outlined,
                size: 80.sp,
              ),
              title: Text(
                "Notification Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationSettings(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                size: 80.sp,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdvancedSettings()));
              },
              title: Text(
                "Advanced Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Spacer(),
            Container(
              width: 1.sw,
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
              child: Column(
                children: [
                  (appData.isPro)
                      ? Container(
                          child: Column(
                            children: [
                              SizedBox(
                                  width: 300.sp,
                                  height: 300.sp,
                                  child:
                                      Image.asset('assets/images/crown.png')),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Our app is still under development",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 60.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Text("And we want to thank you for joining in early!"),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "You can support the developers financially! The money will go straight into app improvements and together we can make the best app ever Insha' Allah",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 50.sp),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Spacer(),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SupportPage())),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 5.sp),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Support financially"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.sp,
                        ),
                        InkWell(
                          onTap: (loaded)
                              ? () {
                                  rewardedAd.show(onUserEarnedReward:
                                      (rewardedAd, RewardItem points) {
                                    points = RewardItem(299, "Support points");
                                  });
                                }
                              : () {},
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: (loaded)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.grey,
                                    width: 5.sp),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Theme.of(context).backgroundColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Watch ad"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    "جَزاكَ اللهُ خَـيْراً",
                    style:
                        TextStyle(fontSize: 80.sp, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
