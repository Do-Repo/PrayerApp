import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:application_1/models/QuranModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranListAR extends StatefulWidget {
  const QuranListAR({Key key, @required TabController tabController})
      : tab = tabController,
        super(key: key);
  final TabController tab;
  @override
  _QuranListARState createState() => _QuranListARState();
}

class _QuranListARState extends State<QuranListAR> {
  Future<List<QuranPicker>> _future;

  @override
  void initState() {
    super.initState();
    _future = getSurahTitles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        widget.tab.animateTo(0);
      },
      child: ListView(children: <Widget>[
        new FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
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
                List<QuranPicker> data = snapshot.data;
                List<Widget> reasonList = [];
                data.forEach((element) {
                  reasonList.add(ListTile(
                    onTap: () {
                      print(element.number);
                    },
                    dense: true,
                    contentPadding: EdgeInsets.all(20.sp),
                    selectedTileColor: Colors.green,
                    leading: Text(element.number.toString()),
                    trailing: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        element.name,
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
}
