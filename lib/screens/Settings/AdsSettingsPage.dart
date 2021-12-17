import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdsSettingsPage extends StatefulWidget {
  const AdsSettingsPage({Key? key}) : super(key: key);

  @override
  _AdsSettingsPageState createState() => _AdsSettingsPageState();
}

class _AdsSettingsPageState extends State<AdsSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, false, "Ads settings", false),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PriceCard(
                number: 1,
                offer: "No ads",
                price: "3.99",
              ),
              PriceCard(
                number: 3,
                offer: "No ads",
                price: "6.99",
              ),
              PriceCard(
                number: 12,
                offer: "No ads",
                price: "14.99",
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                  child: Container(
                    height: 2.sp,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "  UPCOMING OFFERS  ",
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4)),
                ),
                Flexible(
                  child: Container(
                    height: 2.sp,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
              ]),
              ListTile(
                subtitle: Text(
                    "If you have an active 3 or 12 months subscription the upcoming features will be added to your subscription for free on release."),
              ),
              ListTile(
                leading: Icon(Icons.star),
                tileColor: Theme.of(context).backgroundColor,
                title: Text(
                  "Offline Access",
                  style: TextStyle(fontSize: 50.sp),
                ),
                subtitle: Text(
                    "Full access to all features that require an Internet connection offline"),
              ),
              SizedBox(
                height: 20.sp,
              ),
              ListTile(
                leading: Icon(Icons.star),
                tileColor: Theme.of(context).backgroundColor,
                title: Text(
                  "More Recitations",
                  style: TextStyle(fontSize: 50.sp),
                ),
                subtitle: Text("More voices to choose from for audio Quran"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  const PriceCard(
      {Key? key,
      required this.number,
      required this.price,
      required this.offer})
      : super(key: key);
  final int number;
  final String price;
  final String offer;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 20.sp),
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: Text(
            "$number",
            style: TextStyle(
                fontSize: 200.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary),
          )),
          SizedBox(
            width: 10.sp,
          ),
          Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (number > 1) ? "Months" : "Month",
                style: TextStyle(
                    fontSize: 90.sp,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Text(
                "$offer",
                style: TextStyle(
                  fontSize: 60.sp,
                ),
              )
            ],
          )),
          Spacer(),
          Container(
              child: Text(
            r"$" + "$price",
            style: TextStyle(
              fontSize: 80.sp,
            ),
          ))
        ],
      ),
    );
  }
}
