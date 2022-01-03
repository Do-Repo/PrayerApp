import 'package:application_1/screens/Settings/AdvancedSettings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                AppLocalizations.of(context)!.errortitleloc,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 45.sp,
                    color: Colors.white),
              ),
              subtitle: RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.white),
                    text: AppLocalizations.of(context)!.errorsubloc,
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
                                              AppLocalizations.of(context)!
                                                  .errorsubloctwo,
                                              style: TextStyle(
                                                  fontSize: 50.sp,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "\n" +
                                                  AppLocalizations.of(context)!
                                                      .errorsublocthree,
                                              style: TextStyle(fontSize: 45.sp),
                                            )
                                          ],
                                        ),
                                      ));
                            },
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                          text: "\n" +
                              AppLocalizations.of(context)!.errorsubloctwo)
                    ]),
              ),
              leading: Icon(
                customIcon.MyFlutterApp.no_wifi,
                color: Colors.white,
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
                      AppLocalizations.of(context)!.locset,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    )),
                TextButton(
                    onPressed: func,
                    child: Text(
                      AppLocalizations.of(context)!.retry,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
