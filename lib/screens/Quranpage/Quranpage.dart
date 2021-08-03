import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
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
      int numberOfAyahs = 0,
      required int verseNumber})
      : iA = isArabic,
        t = title,
        vs = verseNumber,
        na = numberOfAyahs,
        super(key: key);
  final bool iA;
  final int na;
  final String t;
  final int vs;
  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  int counter = 0;
  bool isOn = false;
  int currentposition = 0;
  bool playiin = true;
  @override
  void initState() {
    counter = 0;
    super.initState();
  }

  @override
  void dispose() {
    audio.release();
    super.dispose();
  }

  AudioPlayer audio = AudioPlayer();
  int duration = 0;
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
                iconColor: Colors.green,
                textColor: Colors.black,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
                collapsedTextColor: Colors.green,
                title: Text(
                  widget.t,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 90.sp, fontWeight: FontWeight.bold),
                ),
                children: [
                  widget.iA
                      ? SizedBox(
                          width: 1.sw,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: FutureBuilder(
                                    future: getAyahAR(widget.vs),
                                    builder: (context,
                                        AsyncSnapshot<List> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                          padding: EdgeInsets.all(30.sp),
                                          margin: EdgeInsets.all(18.sp),
                                          height: 205.sp,
                                          width: 205.sp,
                                          child: CircularProgressIndicator(
                                            color: Colors.green,
                                            strokeWidth: 17.sp,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return IconButton(
                                          onPressed: () {},
                                          splashColor: Colors.red[100],
                                          highlightColor: Colors.transparent,
                                          icon: Icon(Icons.refresh),
                                          iconSize: 200.sp,
                                          color: Colors.green,
                                        );
                                      } else {
                                        List<String> reasonList = [];
                                        snapshot.data!.forEach((element) {
                                          reasonList.add(element.audio);
                                        });

                                        return playiin
                                            ? IconButton(
                                                splashColor: Colors.green[100],
                                                highlightColor:
                                                    Colors.transparent,
                                                onPressed: () {
                                                  playiin = false;
                                                  isOn
                                                      ? resumeQuran(audio)
                                                      : playQuran(
                                                          reasonList, audio);
                                                },
                                                iconSize: 200.sp,
                                                icon: Icon(
                                                  Icons.play_circle_outline,
                                                  color: Colors.green,
                                                ),
                                              )
                                            : IconButton(
                                                splashColor: Colors.green[100],
                                                highlightColor:
                                                    Colors.transparent,
                                                onPressed: () {
                                                  audio.pause();
                                                  setState(() {
                                                    playiin = true;
                                                  });
                                                },
                                                iconSize: 200.sp,
                                                icon: Icon(
                                                  Icons.pause_circle_outline,
                                                  color: Colors.green,
                                                ),
                                              );
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              "Recitation:",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 50.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Text(
                                              "Mishary bin Rashid Alafasy",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 40.sp),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              "Number of Ayah's:",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 50.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              widget.na.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 40.sp),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : EnglishInfo()
                ],
              ),
              Container(
                color: Colors.green,
                width: 1.sw,
                height: 3.sp,
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: FutureBuilder(
                  future: widget.iA
                      ? getAyahAR(
                          widget.vs,
                        )
                      : getAyahEN(widget.vs),
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

  playQuran(List<String> list, AudioPlayer audioPlayer) async {
    if (currentposition >= list.length - 1) currentposition = 0;

    for (var i = currentposition; i < list.length; i++) {
      currentposition = i;

      setState(() {
        counter = i + 1;
      });
      await audioPlayer.play(list[i]);

      while (audioPlayer.state == PlayerState.PLAYING ||
          audioPlayer.state == PlayerState.PAUSED) {
        await Future.delayed(Duration(seconds: 1));
        if (audioPlayer.state == PlayerState.PAUSED) {
          isOn = true;
          // without this, it made another for loop everytime you pause, causing it to stack
        }
        if (audioPlayer.state == PlayerState.PLAYING) {
          audioPlayer.onPlayerCompletion.listen((onDone) async {
            audioPlayer.stop();
          });
        }
      }
    }

    print('yea bro');
    setState(() {
      playiin = true;
      currentposition = 0;
      counter = 0;
      isOn = false;
    });
  }

  resumeQuran(AudioPlayer audioPlayer) {
    audioPlayer.resume();
    setState(() {
      playiin = false;
    });
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
                  'Muhammad Asad',
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
                    'wiki/Muhammad_Asad',
                    style: TextStyle(fontSize: 50.sp),
                  ),
                  onTap: () =>
                      launch(' https://en.wikipedia.org/wiki/Muhammad_Asad')),
            ],
          )
        ],
      ),
    );
  }
}

Future<List<QuranAR>> getAyahAR(int surahNumber) async {
  print(surahNumber);
  final result = await http.get(
      Uri.parse("http://api.alquran.cloud/v1/surah/$surahNumber/ar.alafasy"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data']['ayahs'];
    return jsonResponse.map((data) => new QuranAR.fromJson(data)).toList();
  } else {
    return <QuranAR>[];
  }
}

Future<List<QuranEN>> getAyahEN(int surahNumber) async {
  print(surahNumber);
  final result = await http
      .get(Uri.parse("http://api.alquran.cloud/v1/surah/$surahNumber/en.asad"));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data']['ayahs'];

    return jsonResponse.map((data) => new QuranEN.fromJson(data)).toList();
  } else {
    return <QuranEN>[];
  }
}
