import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AdsSettingsPage extends StatefulWidget {
  const AdsSettingsPage({Key? key}) : super(key: key);

  @override
  _AdsSettingsPageState createState() => _AdsSettingsPageState();
}

class _AdsSettingsPageState extends State<AdsSettingsPage> {
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
        print(offerings.current);
        setState(() {
          loading = false;
        });
      }
    } on PlatformException catch (e) {
      print(e);
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
          msg: AppLocalizations.of(context)!.thankyou,
          title: AppLocalizations.of(context)!.subscribed,
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
    return Container(
      child: Scaffold(
        appBar: customAppbar(
            context, false, AppLocalizations.of(context)!.adssub, false),
        body: (loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (error)
                ? Container(
                    child: SomethingWrong(),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          (offerings.current!.monthly != null &&
                                  offerings.current!.monthly!.product
                                          .identifier ==
                                      "1monthnoads")
                              ? PriceCard(
                                  number: 1,
                                  offer: AppLocalizations.of(context)!.noAds,
                                  price: offerings
                                      .current!.monthly!.product.priceString,
                                  onClicked: () {
                                    purchase(
                                        offerings.current!.monthly!, "1mNoAds");
                                  },
                                )
                              : Container(),
                          (offerings.current!.threeMonth != null &&
                                  offerings.current!.threeMonth!.product
                                          .identifier ==
                                      "3monthsnoads")
                              ? PriceCard(
                                  number: 3,
                                  offer: AppLocalizations.of(context)!.noAds,
                                  price: offerings
                                      .current!.threeMonth!.product.priceString,
                                  onClicked: () {
                                    purchase(offerings.current!.threeMonth!,
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
                                  offer: AppLocalizations.of(context)!.noAds,
                                  price: offerings
                                      .current!.annual!.product.priceString,
                                  onClicked: () {
                                    purchase(
                                        offerings.current!.annual!, "12mNoAds");
                                  },
                                )
                              : Container(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 2.sp,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  "  " +
                                      AppLocalizations.of(context)!
                                          .upcomingOffers +
                                      "  ",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.4)),
                                ),
                                Flexible(
                                  child: Container(
                                    height: 2.sp,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                )
                              ]),
                          ListTile(
                            subtitle:
                                Text(AppLocalizations.of(context)!.additional),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                    (widget.number > 1)
                        ? AppLocalizations.of(context)!.months
                        : AppLocalizations.of(context)!.month,
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
