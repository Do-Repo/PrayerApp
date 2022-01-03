import 'package:application_1/models/HadithModel.dart';
import 'package:application_1/screens/HadithPage/HadithPage.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/animator.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HadithList extends StatefulWidget {
  const HadithList({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;
  @override
  _HadithListState createState() => _HadithListState();
}

class _HadithListState extends State<HadithList>
    with AutomaticKeepAliveClientMixin {
  bool iA = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () {
        widget.pageController.animateToPage(0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutQuart);
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          children: [
            customHomeAppbar(context, widget.pageController,
                AppLocalizations.of(context)!.hadith, true, () {
              setState(() {
                iA = !iA;
              });
            }),
            Flexible(
              child: ListView(children: <Widget>[
                FutureBuilder(
                    future: getHadithList(iA),
                    builder:
                        (context, AsyncSnapshot<List<HadithListing>> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      } else if (snapshot.hasError) {
                        return NoConnectionWidget(
                          function: () {
                            setState(() {
                              getHadithList(iA);
                            });
                          },
                        );
                      } else {
                        List<Widget> reasonList = [];
                        snapshot.data!.forEach((element) {
                          reasonList.add(WidgetAnimator(
                            child: ExpansionTile(
                              collapsedBackgroundColor: (snapshot.data!
                                      .indexOf(element)
                                      .isOdd)
                                  ? Theme.of(context).backgroundColor
                                  : Theme.of(context).scaffoldBackgroundColor,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.05),
                              children: <Widget>[
                                FutureBuilder(
                                    future:
                                        getHadithChapter(element.bookid, iA),
                                    builder: (context,
                                        AsyncSnapshot<List<HadithChapter>>
                                            snapshotII) {
                                      if (snapshotII.connectionState !=
                                          ConnectionState.done) {
                                        return Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                      .loading +
                                                  "..."),
                                        );
                                      } else if (snapshotII.hasError) {
                                        return Text(
                                            AppLocalizations.of(context)!
                                                    .conlost +
                                                "...");
                                      } else {
                                        List<Widget> reasonlistII = [];
                                        snapshotII.data!.forEach((elementII) {
                                          reasonlistII.add(ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HadithPage(
                                                          booktitle:
                                                              element.bookname,
                                                          chaptertitle:
                                                              elementII.chapter,
                                                          bookid:
                                                              element.bookid,
                                                          chapterid: elementII
                                                              .chapterid,
                                                          isArabic: iA,
                                                        )),
                                              );
                                            },
                                            title: Directionality(
                                                textDirection: iA
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                child: Text(elementII.chapter)),
                                          ));
                                        });

                                        return Column(children: reasonlistII);
                                      }
                                    })
                              ],
                              textColor:
                                  Theme.of(context).colorScheme.secondary,
                              iconColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Directionality(
                                textDirection:
                                    iA ? TextDirection.rtl : TextDirection.ltr,
                                child: Text(
                                  element.bookname,
                                  style: TextStyle(fontSize: 60.sp),
                                ),
                              ),
                            ),
                          ));
                        });
                        return Column(children: reasonList);
                      }
                    })
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
