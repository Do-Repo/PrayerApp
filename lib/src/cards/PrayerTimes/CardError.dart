import 'package:application_1/screens/Settings/AdvancedSettings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CardError extends StatelessWidget {
  const CardError({
    Key? key,
    required VoidCallback onPressed,
    required AsyncSnapshot snap,
  })  : snapshot = snap,
        func = onPressed,
        super(key: key);

  final AsyncSnapshot snapshot;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              isThreeLine: true,
              title: Text(
                "Failed to look up your location",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50.sp),
              ),
              subtitle: RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.grey),
                    text:
                        "Make sure you're connected to the Internet and press retry.",
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                        padding: EdgeInsets.all(20.sp),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Why do I have to be connected to the internet?",
                                              style: TextStyle(
                                                  fontSize: 50.sp,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "\nAll the data in the app like Quran, Hadith, Audio files and Country names are stored online in order to keep the application size reasonable. \n \nThere's nothing to worry about since none of your data is being stored online.",
                                              style: TextStyle(fontSize: 40.sp),
                                            )
                                          ],
                                        ),
                                      ));
                            },
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400),
                          text:
                              "\nWhy do I need to be connected to the internet?")
                    ]),
              ),
              leading: Icon(
                customIcon.MyFlutterApp.no_wifi,
                size: 200.sp,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvancedSettings()));
                    },
                    child: Text(
                      "Location Settings",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )),
                TextButton(
                    onPressed: func,
                    child: Text(
                      "Retry",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
