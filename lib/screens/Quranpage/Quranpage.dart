import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:application_1/models/QuranModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class QuranPage extends StatefulWidget {
  const QuranPage(
      {Key? key,
      required String title,
      required bool isArabic,
      required int verseNumber})
      : iA = isArabic,
        t = title,
        vs = verseNumber,
        super(key: key);
  final bool iA;
  final String t;
  final int vs;
  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  Future<List<QuranAR>>? _futureAR;
  Future<List<QuranEN>>? _futureEN;

  @override
  void initState() {
    _futureAR = getAyahAR(widget.vs);
    _futureEN = getAyahEN(widget.vs);
    super.initState();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Directionality(
        textDirection: widget.iA ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          margin: EdgeInsets.all(30.sp),
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ExpansionTile(
                title: Text(
                  widget.t,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 90.sp,
                      fontWeight: FontWeight.bold),
                ),
                children: [widget.iA ? Container() : EnglishInfo()],
              ),
              Container(
                color: Colors.green,
                width: 1.sw,
                height: 3.sp,
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: FutureBuilder(
                  future: widget.iA ? _futureAR : _futureEN,
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "connection failed",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      List<TextSpan> reasonList = [];
                      snapshot.data!.forEach((element) {
                        reasonList.add(TextSpan(
                            style: widget.iA
                                ? reasonList.length + 1 == counter
                                    ? TextStyle(
                                        color: Colors.green, fontSize: 70.sp)
                                    : TextStyle(
                                        color: Colors.black, fontSize: 70.sp)
                                : TextStyle(
                                    color: Colors.black, fontSize: 60.sp),
                            text: widget.iA
                                ? '${element.ayah} ۝ '
                                : element.ayah + ' '));
                      });
                      return Container(
                          child: RichText(
                              text: TextSpan(
                        children: reasonList,
                      )));
                    }
                  },
                )),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class EnglishInfo extends StatelessWidget {
  const EnglishInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Translator: ',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 50.sp),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  'Mohammed Marmaduke William Pickthall  ',
                  style: TextStyle(fontSize: 50.sp),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Wikipedia: ',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 50.sp),
              ),
              InkWell(
                  child: new Text(
                    'Marmaduke Pickthall',
                    style: TextStyle(fontSize: 50.sp),
                  ),
                  onTap: () => launch(
                      'https://en.wikipedia.org/wiki/Marmaduke_Pickthall')),
            ],
          )
        ],
      ),
    );
  }
}

Future<List<QuranAR>> getAyahAR(int surahNumber) async {
  print(surahNumber);
  final result = await http
      .get(Uri.parse("http://api.alquran.cloud/v1/surah/$surahNumber"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data']['ayahs'];
    return jsonResponse.map((data) => new QuranAR.fromJson(data)).toList();
  } else {
    return <QuranAR>[];
  }
}

Future<List<QuranEN>> getAyahEN(int surahNumber) async {
  print(surahNumber);
  final result = await http.get(Uri.parse(
      "https://api.alquran.cloud/v1/surah/$surahNumber/en.pickthall"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data']['ayahs'];

    return jsonResponse.map((data) => new QuranEN.fromJson(data)).toList();
  } else {
    return <QuranEN>[];
  }
}
