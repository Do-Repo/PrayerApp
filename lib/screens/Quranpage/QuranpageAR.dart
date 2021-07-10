import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:application_1/models/QuranModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranPageAR extends StatefulWidget {
  const QuranPageAR({Key key}) : super(key: key);

  @override
  _QuranPageARState createState() => _QuranPageARState();
}

class _QuranPageARState extends State<QuranPageAR> {
  Future<List<Quran>> _future;
  @override
  void initState() {
    _future = getAyah();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.all(30.sp),
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ExpansionTile(
                title: Text(
                  "Title",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 90.sp,
                      fontWeight: FontWeight.bold),
                ),
                children: [
                  Container(
                    height: 300.h,
                  )
                ],
              ),
              Container(
                color: Colors.green,
                width: 1.sw,
                height: 3.sp,
              ),
              FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading');
                  } else if (snapshot.hasError) {
                    return Text("oh no");
                  } else {
                    List<Quran> reasonList = snapshot.data;
                    var concat = StringBuffer();
                    reasonList.forEach((element) {
                      concat.write(element.ayah);
                    });

                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

Future<List<Quran>> getAyah() async {
  final result =
      await http.get(Uri.parse("http://api.alquran.cloud/v1/surah/114"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data']['ayahs'];
    return jsonResponse.map((data) => new Quran.fromJson(data)).toList();
  } else {
    print("error");
  }
}
