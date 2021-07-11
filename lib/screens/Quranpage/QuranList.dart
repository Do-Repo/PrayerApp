import 'dart:convert';
import 'package:application_1/screens/Quranpage/Quranpage.dart';
import 'package:http/http.dart' as http;
import 'package:application_1/models/QuranModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranList extends StatefulWidget {
  const QuranList(
      {Key? key, required bool isArabic, required TabController? tabController})
      : tab = tabController,
        iA = isArabic,
        super(key: key);
  final TabController? tab;
  final bool iA;
  @override
  _QuranListState createState() => _QuranListState();
}

class _QuranListState extends State<QuranList> {
  Future<List<QuranPicker>>? _future;

  @override
  void initState() {
    super.initState();
    _future = getSurahTitles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () => widget.tab!.animateTo(0) as Future<bool>,
      child: ListView(children: <Widget>[
        FutureBuilder(
            future: _future,
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
                  reasonList.add(ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuranPage(
                                  title: widget.iA
                                      ? element.name
                                      : element.englishNameTranslation,
                                  isArabic: widget.iA,
                                  verseNumber: element.number,
                                )),
                      );
                    },
                    dense: true,
                    contentPadding: EdgeInsets.all(20.sp),
                    selectedTileColor: Colors.green,
                    leading: Text(element.number.toString()),
                    title: Directionality(
                      textDirection:
                          widget.iA ? TextDirection.rtl : TextDirection.ltr,
                      child: Text(
                        widget.iA
                            ? element.name
                            : element.englishNameTranslation,
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

Future<List<QuranPicker>> getSurahTitles() async {
  final result = await http.get(Uri.parse("http://api.alquran.cloud/v1/surah"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data'];
    return jsonResponse.map((data) => new QuranPicker.fromJson(data)).toList();
  } else {
    print("error");
  }
  return <QuranPicker>[];
}
