import 'package:flutter/material.dart';
import 'package:application_1/models/prayerTimes.dart';
import 'package:application_1/screens/HomePage/HomePageWidgets.dart';
import 'package:application_1/src/advancedSettings.dart';
import 'package:application_1/src/apiCalls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var method =
        context.select((AdvancedSettingsProvider as) => as.timeSettings);
    var optionIndex =
        context.select((AdvancedSettingsProvider as) => as.locationOption);
    var pos = Provider.of<SavedLocationProvider>(context);
    return FutureBuilder(
        future: getPrayerTimes(pos, method, optionIndex),
        builder: (context, AsyncSnapshot<List<PrayerTimesModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.hasError) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title: homePageAppBarLoading(context),
              ),
              body: Column(
                children: [
                  homePageHeaderLoading(context),
                  Flexible(
                      child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        children: [
                          dateWidgetLoading(context),
                          Flexible(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Shimmer.fromColors(
                                baseColor: Colors.transparent,
                                highlightColor: Colors.white,
                                child: Column(
                                  children: [
                                    timingWidgetLoading(context),
                                    holidayWidgetLoading(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            );
          } else {
            initialIndex = snapshot.data!.indexWhere((element) =>
                DateFormat("DD-MM-yyyy").parse(element.fullgregoriandate!) ==
                DateFormat("yyyy-MM-DD").parse(DateTime.now().toString()));
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title: homePageAppBar(snapshot),
              ),
              body: Column(
                children: [
                  HomePageHeader(
                    snapshot: snapshot.data![initialIndex],
                  ),
                  Flexible(
                      child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                          ),
                          dateWidget(
                            context,
                            snapshot.data![initialIndex],
                          ),
                          Flexible(
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    TimingWidget(
                                      snapshot: snapshot.data![initialIndex],
                                    ),
                                    holidayWidget(snapshot),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
