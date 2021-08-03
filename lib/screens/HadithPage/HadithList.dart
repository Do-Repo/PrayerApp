import 'dart:convert';
import 'package:application_1/models/HadithModel.dart';
import 'package:application_1/screens/HadithPage/HadithPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HadithList extends StatefulWidget {
  const HadithList(
      {Key? key, required bool isArabic, required TabController? tabController})
      : tab = tabController,
        iA = isArabic,
        super(key: key);
  final TabController? tab;
  final bool iA;

  @override
  _HadithListState createState() => _HadithListState();
}

class _HadithListState extends State<HadithList> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () => widget.tab!.animateTo(0) as Future<bool>,
      child: ListView(children: <Widget>[
        FutureBuilder(
            future: getHadithList(widget.iA),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 500.h,
                  width: 1.sw,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
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
                    children: <Widget>[
                      FutureBuilder(
                          future: getHadithChapter(element.bookid, widget.iA),
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
                                                isArabic: widget.iA,
                                              )),
                                    );
                                  },
                                  title: Directionality(
                                      textDirection: widget.iA
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      child: Text(elementII.chapter)),
                                ));
                              });
                              return Column(children: reasonlistII);
                            }
                          })
                    ],
                    textColor: Colors.green,
                    iconColor: Colors.green,
                    title: Directionality(
                      textDirection:
                          widget.iA ? TextDirection.rtl : TextDirection.ltr,
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

Future<List<HadithChapter>> getHadithChapter(int bookid, bool isArabic) async {
  final result = await http.get(isArabic
      ? Uri.parse("https://ahadith-api.herokuapp.com/api/chapter/$bookid/ar")
      : Uri.parse("https://ahadith-api.herokuapp.com/api/chapter/$bookid/en"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['Chapter'];
    return jsonResponse
        .map((data) => new HadithChapter.fromJson(data))
        .toList();
  } else {
    print("error");
  }
  return <HadithChapter>[];
}

Future<List<HadithListing>> getHadithList(bool isArabic) async {
  final result = await http.get(isArabic
      ? Uri.parse("https://ahadith-api.herokuapp.com/api/books/ar")
      : Uri.parse("https://ahadith-api.herokuapp.com/api/books/en"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['Books'];
    return jsonResponse
        .map((data) => new HadithListing.fromJson(data))
        .toList();
  } else {
    print("error");
  }
  return <HadithListing>[];
}
