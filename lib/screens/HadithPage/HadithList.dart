import 'package:application_1/models/HadithModel.dart';
import 'package:application_1/screens/HadithPage/HadithPage.dart';
import 'package:application_1/screens/Settings/Settings.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
          style: (TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        elevation: 0,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
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
                      color: Theme.of(context).colorScheme.secondary,
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
            builder: (context, AsyncSnapshot<List<HadithListing>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                );
              } else if (snapshot.hasError) {
                return Container(
                    height: 500.h,
                    width: 1.sw,
                    child: Center(
                      child: ListTile(
                        isThreeLine: true,
                        title: Text(
                          "Failed to connect to the internet",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 50.sp),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.grey),
                              text:
                                  "Make sure you're connected to the Internet and try again.",
                              children: <TextSpan>[
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            builder: (context) => Container(
                                                  padding:
                                                      EdgeInsets.all(20.sp),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Why do I have to be connected to the internet?",
                                                        style: TextStyle(
                                                            fontSize: 50.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        "\nAll the data in the app like Quran, Hadith, Audio files and Country names are stored online in order to keep the application size reasonable. \n \nThere's nothing to worry about since none of your data is being stored online.",
                                                        style: TextStyle(
                                                            fontSize: 40.sp),
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
                    ));
              } else {
                if (snapshot.data!.first.onError) {
                  return Center(child: customErrorWidget());
                } else {
                  List<Widget> reasonList = [];
                  snapshot.data!.forEach((element) {
                    reasonList.add(ExpansionTile(
                      collapsedBackgroundColor:
                          (snapshot.data!.indexOf(element).isOdd)
                              ? Theme.of(context).backgroundColor
                              : Theme.of(context).scaffoldBackgroundColor,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.05),
                      children: <Widget>[
                        FutureBuilder(
                            future: getHadithChapter(element.bookid, iA),
                            builder: (context,
                                AsyncSnapshot<List<HadithChapter>> snapshotII) {
                              if (!snapshotII.hasData) {
                                return const Center(
                                  child: const Text('Loading...'),
                                );
                              } else if (snapshotII.hasError) {
                                return Text('Error loading data',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ));
                              } else {
                                if (snapshotII.data!.first.onError) {
                                  return Center(child: customErrorWidget());
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
                                  });
                                  return Column(children: reasonlistII);
                                }
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
                    ));
                  });
                  return Column(children: reasonList);
                }
              }
            })
      ]),
    );
  }
}
