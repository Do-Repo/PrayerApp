import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  bool loading = true;
  bool error = false;
  late Offerings offerings;
  @override
  void initState() {
    super.initState();
    getOffers();
  }

  getOffers() async {
    try {
      offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        setState(() {
          loading = false;
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  purchase(Package package, String id) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo.entitlements.all[id]!.isActive) {
        Dialogs.bottomMaterialDialog(
          color: Theme.of(context).backgroundColor,
          context: context,
          lottieBuilder: LottieBuilder.asset(
            "assets/images/50465-done.json",
            repeat: false,
          ),
          msg: "Thank you for your support!",
          title: "Payment received!",
        );
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print("error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Support"),
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.all(20.sp),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Tank you for supporting us!",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 70.sp),
                    ),
                    Text(
                        "Thank you for your trust and faith in our app, because of your support this app will only get better and bigger insha'Allah"),
                    SizedBox(
                      height: 100.h,
                    ),
                    Container(
                      width: 1.sw,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3),
                      padding: EdgeInsets.all(20.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upcoming Features:",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 60.sp),
                          ),
                          Text(
                            "New features we are working on for the near future",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('Multi-Language'),
                            subtitle: Text("Translating the app "),
                          ),
                          ListTile(
                            title: Text('Widgets'),
                            subtitle:
                                Text("Homescreen widgets for prayertimes "),
                          ),
                          ListTile(
                            title: Text('Duas and Azkar'),
                            subtitle:
                                Text("Duas and Azkar will be back very soon"),
                          ),
                          ListTile(
                            title: Text('App customization'),
                            subtitle:
                                Text("Customize the app the way you like it"),
                          ),
                          ListTile(
                            subtitle: Text(
                                "If you have any ideas you want to see in our app let us know by mailing: dev.dorepo@gmail.com"),
                          ),
                        ],
                      ),
                    ),
                    (loading)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : (error)
                            ? Container(
                                child: SomethingWrong(),
                              )
                            : Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.sp),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      (offerings.current!.monthly != null &&
                                              offerings.current!.monthly!
                                                      .product.identifier ==
                                                  "1monthnoads")
                                          ? PriceCard(
                                              number: 1,
                                              offer: "Supporter",
                                              price: offerings.current!.monthly!
                                                  .product.priceString,
                                              onClicked: () {
                                                purchase(
                                                    offerings.current!.monthly!,
                                                    "1mNoAds");
                                              },
                                            )
                                          : Container(),
                                      (offerings.current!.threeMonth != null &&
                                              offerings.current!.threeMonth!
                                                      .product.identifier ==
                                                  "3monthsnoads")
                                          ? PriceCard(
                                              number: 3,
                                              offer: "Supporter",
                                              price: offerings
                                                  .current!
                                                  .threeMonth!
                                                  .product
                                                  .priceString,
                                              onClicked: () {
                                                purchase(
                                                    offerings
                                                        .current!.threeMonth!,
                                                    "3mNoAds");
                                              },
                                            )
                                          : Container(),
                                      (offerings.current!.annual != null &&
                                              offerings.current!.annual!.product
                                                      .identifier ==
                                                  "12monthsnoads")
                                          ? PriceCard(
                                              number: 12,
                                              offer: "Supporter",
                                              price: offerings.current!.annual!
                                                  .product.priceString,
                                              onClicked: () {
                                                purchase(
                                                    offerings.current!.annual!,
                                                    "12mNoAds");
                                              },
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              )
                  ]),
            )));
  }
}

class SomethingWrong extends StatelessWidget {
  const SomethingWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(
        "Oops.. something went wrong",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50.sp),
      ),
      subtitle: Text("Failed to connect.. try again later"),
      leading: Icon(
        Icons.error_outline_outlined,
        size: 200.sp,
      ),
    );
  }
}

class PriceCard extends StatefulWidget {
  const PriceCard(
      {Key? key,
      required this.number,
      required this.price,
      required this.onClicked,
      required this.offer})
      : super(key: key);
  final int number;
  final String price;
  final VoidCallback onClicked;
  final String offer;

  @override
  State<PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClicked,
      child: Container(
        color: Theme.of(context).backgroundColor,
        margin: EdgeInsets.symmetric(vertical: 20.sp),
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "${widget.number}",
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
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    (widget.number > 1) ? "Months" : "Month",
                    style: TextStyle(
                        fontSize: 90.sp,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Text(
                  "${widget.offer}",
                  style: TextStyle(
                    fontSize: 60.sp,
                  ),
                )
              ],
            )),
            Spacer(),
            Container(
                child: Text(
              "${widget.price}",
              style: TextStyle(
                fontSize: 80.sp,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
