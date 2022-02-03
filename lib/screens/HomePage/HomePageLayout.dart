import 'package:application_1/screens/SettingsPage/AdvancedSettings.dart';
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
            // Showing cached timings while loading
            // Needs error handling since this is calling fresh data
            if (snapshot.hasError) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Oops.. Something went wrong"),
                        content: Text(
                            "Make sure you're connected to the internet and allow the app to know your location. If you want you can set your location manually in the settings"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AdvancedSettings()));
                              },
                              child: Text("Location settings")),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  getPrayerTimes(pos, method, optionIndex);
                                });
                              },
                              child: Text("Retry"))
                        ],
                      );
                    });
              });
            }
            return FutureBuilder(
                future: getCachedPrayertimes(),
                builder: (context,
                    AsyncSnapshot<List<PrayerTimesModel>> snapshotII) {
                  if (snapshotII.connectionState != ConnectionState.done ||
                      snapshotII.hasError) {
                    // No need for error handling since it's only cached data
                    return LoadingPage();
                  } else {
                    initialIndex = snapshotII.data!.indexWhere((element) =>
                        DateFormat("DD-MM-yyyy")
                            .parse(element.fullgregoriandate!) ==
                        DateFormat("yyyy-MM-DD")
                            .parse(DateTime.now().toString()));
                    return ShowHomepage(
                      initialIndex: initialIndex,
                      snapshot: snapshotII,
                      cachedData: true,
                    );
                  }
                });
          } else {
            initialIndex = snapshot.data!.indexWhere((element) =>
                DateFormat("DD-MM-yyyy").parse(element.fullgregoriandate!) ==
                DateFormat("yyyy-MM-DD").parse(DateTime.now().toString()));
            return ShowHomepage(
              initialIndex: initialIndex,
              snapshot: snapshot,
              cachedData: false,
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class ShowHomepage extends StatefulWidget {
  const ShowHomepage({
    Key? key,
    required this.initialIndex,
    required this.snapshot,
    required this.cachedData,
  }) : super(key: key);

  final int initialIndex;
  final AsyncSnapshot<List<PrayerTimesModel>> snapshot;
  final bool cachedData;

  @override
  State<ShowHomepage> createState() => _ShowHomepageState();
}

class _ShowHomepageState extends State<ShowHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: (widget.cachedData)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  homePageAppBar(widget.snapshot),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 5.sp,
                    ),
                  )
                ],
              )
            : homePageAppBar(widget.snapshot),
      ),
      body: Column(
        children: [
          HomePageHeader(
            snapshot: widget.snapshot.data![widget.initialIndex],
          ),
          Flexible(
              child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                    widget.snapshot.data![widget.initialIndex],
                  ),
                  Flexible(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            TimingWidget(
                              snapshot:
                                  widget.snapshot.data![widget.initialIndex],
                            ),
                            holidayWidget(widget.snapshot),
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
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
  }
}
