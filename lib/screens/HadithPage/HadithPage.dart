import 'dart:convert';
import 'package:application_1/src/customWidgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:application_1/models/HadithModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HadithPage extends StatefulWidget {
  const HadithPage(
      {Key? key,
      required bool isArabic,
      required int bookid,
      required String booktitle,
      required String chaptertitle,
      required int chapterid})
      : ia = isArabic,
        bi = bookid,
        bt = booktitle,
        ct = chaptertitle,
        ci = chapterid,
        super(key: key);
  final bool ia;
  final String bt, ct;
  final int bi, ci;

  @override
  _HadithPageState createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  late Future<List> _futureEN, _futureAR;
  @override
  void initState() {
    _futureEN = getHadithEN(widget.bi, widget.ci);
    _futureAR = getHadithAR(widget.bi, widget.ci);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(30.sp),
          child: FutureBuilder(
            future: widget.ia ? _futureAR : _futureEN,
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  width: 1.sw,
                  height: 200.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  width: 1.sw,
                  height: 200.h,
                  child: Center(
                    child: Text(
                      'connection failed',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else {
                List<Widget> reasonList = [];
                snapshot.data!.forEach((element) {
                  reasonList.add(Column(
                    children: [
                      Material(
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Directionality(
                                textDirection: widget.ia
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Text(
                                  element.sanad,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 40.sp,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: Colors.green,
                              ),
                              Directionality(
                                textDirection: widget.ia
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Text(
                                  element.text,
                                  style: TextStyle(
                                    fontSize: 50.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.sp,
                      )
                    ],
                  ));
                });
                return Column(
                  children: [
                    Column(
                      children: reasonList,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<List<HadithsEN>> getHadithEN(int bookid, int chapterid) async {
  final result = await http.get(Uri.parse(
      "https://ahadith-api.herokuapp.com/api/ahadith/$bookid/$chapterid/en"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['Chapter'];
    return jsonResponse.map((data) => new HadithsEN.fromJson(data)).toList();
  } else {
    print("error");
  }
  return <HadithsEN>[];
}

Future<List<HadithsAR>> getHadithAR(int bookid, int chapterid) async {
  final result = await http.get(Uri.parse(
      "https://ahadith-api.herokuapp.com/api/ahadith/$bookid/$chapterid/ar-tashkeel"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['Chapter'];
    return jsonResponse.map((data) => new HadithsAR.fromJson(data)).toList();
  } else {
    print("error");
  }
  return <HadithsAR>[];
}
