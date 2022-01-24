import 'package:flutter/material.dart';
import 'package:application_1/models/hadithModel.dart';
import 'package:application_1/screens/HadithPage/HadithPage.dart';
import 'package:application_1/screens/QuranPage/QuranPage.dart';
import 'package:application_1/src/apiCalls.dart';
import 'package:application_1/src/widgetAnimator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HadithList extends StatefulWidget {
  const HadithList({Key? key}) : super(key: key);
  @override
  _HadithListState createState() => _HadithListState();
}

class _HadithListState extends State<HadithList>
    with AutomaticKeepAliveClientMixin {
  bool iA = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Hadith"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  iA = !iA;
                });
              },
              icon: Icon(Icons.translate_outlined))
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
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
                      for (var element in snapshot.data!) {
                        reasonList.add(WidgetAnimator(
                          child: ExpansionTile(
                            collapsedBackgroundColor:
                                (snapshot.data!.indexOf(element).isOdd)
                                    ? Colors.transparent
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.1),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.05),
                            children: <Widget>[
                              FutureBuilder(
                                  future: getHadithChapter(element.bookid, iA),
                                  builder: (context,
                                      AsyncSnapshot<List<HadithChapter>>
                                          snapshotII) {
                                    if (snapshotII.connectionState !=
                                        ConnectionState.done) {
                                      return Center(
                                        child: Text("Loading..."),
                                      );
                                    } else if (snapshotII.hasError) {
                                      return Text("Connection lost...");
                                    } else {
                                      List<Widget> reasonlistII = [];
                                      for (var elementII in snapshotII.data!) {
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
                                                        bookid: element.bookid,
                                                        chapterid:
                                                            elementII.chapterid,
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
                                      }

                                      return Column(children: reasonlistII);
                                    }
                                  })
                            ],
                            textColor: Theme.of(context).colorScheme.secondary,
                            iconColor: Theme.of(context).colorScheme.secondary,
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
                      }
                      return Column(children: reasonList);
                    }
                  })
            ]),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
