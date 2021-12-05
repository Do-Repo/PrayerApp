import 'package:application_1/screens/HadithPage/HadithPage.dart';
import 'package:application_1/screens/Settings/Settings.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HadithList extends StatefulWidget {
  const HadithList({Key? key}) : super(key: key);

  @override
  _HadithListState createState() => _HadithListState();
}

class _HadithListState extends State<HadithList> {
  bool iA = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Hadith",
          style: (TextStyle(color: Theme.of(context).accentColor)),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        actions: [
          Container(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      (iA) ? iA = false : iA = true;
                    });
                  },
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Text(
                    (iA) ? 'AR' : 'EN',
                    style: TextStyle(
                      fontSize: 70.sp,
                      color: Theme.of(context).accentColor,
                    ),
                  ))),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
              },
              icon: Icon(
                Icons.settings_outlined,
                size: 90.sp,
              )),
        ],
      ),
      body: ListView(children: <Widget>[
        FutureBuilder(
            future: getHadithList(iA),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return LinearProgressIndicator(
                  color: Theme.of(context).accentColor,
                );
              } else if (snapshot.hasError) {
                return Container(
                    height: 500.h,
                    width: 1.sw,
                    child: Center(
                      child: Text('Error loading data',
                          style: TextStyle(color: Colors.red, fontSize: 60.sp)),
                    ));
              } else {
                List<Widget> reasonList = [];
                snapshot.data!.forEach((element) {
                  reasonList.add(ExpansionTile(
                    collapsedBackgroundColor:
                        (snapshot.data!.indexOf(element).isOdd)
                            ? Theme.of(context).backgroundColor
                            : Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.05),
                    children: <Widget>[
                      FutureBuilder(
                          future: getHadithChapter(element.bookid, iA),
                          builder: (context, AsyncSnapshot<List> snapshotII) {
                            if (!snapshotII.hasData) {
                              return const Center(
                                child: const Text('Loading...'),
                              );
                            } else if (snapshotII.hasError) {
                              return const Center(
                                child: const Text('Error loading data'),
                              );
                            } else {
                              List<Widget> reasonlistII = [];
                              snapshotII.data!.forEach((elementII) {
                                reasonlistII.add(ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HadithPage(
                                                booktitle: element.bookname,
                                                chaptertitle: elementII.chapter,
                                                bookid: element.bookid,
                                                chapterid: elementII.chapterid,
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
                    textColor: Theme.of(context).accentColor,
                    iconColor: Theme.of(context).accentColor,
                    title: Directionality(
                      textDirection: iA ? TextDirection.rtl : TextDirection.ltr,
                      child: Text(
                        element.bookname,
                        style: TextStyle(fontSize: 60.sp),
                      ),
                    ),
                  ));
                });
                return Column(children: reasonList);
              }
            })
      ]),
    );
  }
}
