import 'package:application_1/screens/Settings/Recitation.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart';
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

class _QuranPageState extends State<QuranPage> with TickerProviderStateMixin {
  int counter = 0;
  bool isOn = false;
  int currentposition = 0;
  AudioPlayer audio = AudioPlayer();
  int duration = 0;
  int bookmarkIndex = 0;
  String selectedAyah = "";
  bool playing = true;

  @override
  void initState() {
    super.initState();
    BookmarkPref().getBookmark(widget.vs).then((value) {
      setState(() {
        bookmarkIndex = value;
      });
    });
    counter = 0;
  }

  @override
  void dispose() {
    audio.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rec = Provider.of<RecitationProvider>(context);
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
                iconColor: Theme.of(context).accentColor,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
                collapsedTextColor: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: FutureBuilder(
                                    future:
                                        getAyahAR(widget.vs, rec.recitation),
                                    builder: (context,
                                        AsyncSnapshot<List> snapshot) {
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return Container(
                                          padding: EdgeInsets.all(30.sp),
                                          height: 200.sp,
                                          width: 200.sp,
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(context).accentColor,
                                            strokeWidth: 17.sp,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              getAyahAR(
                                                  widget.vs, rec.recitation);
                                            });
                                          },
                                          child: Icon(
                                            Icons.refresh,
                                            size: 200.sp,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        );
                                      } else {
                                        List<String> reasonList = [];
                                        snapshot.data!.forEach((element) {
                                          reasonList.add(element.audio);
                                        });

                                        return playing
                                            ? InkWell(
                                                onTap: () {
                                                  playing = false;
                                                  isOn
                                                      ? resumeQuran(audio)
                                                      : playQuran(
                                                          reasonList, audio);
                                                },
                                                child: Icon(
                                                  Icons
                                                      .play_circle_outline_outlined,
                                                  size: 200.sp,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              )
                                            : InkWell(
                                                child: Icon(
                                                  Icons
                                                      .pause_circle_outline_outlined,
                                                  size: 200.sp,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                onTap: () {
                                                  audio.pause();
                                                  setState(() {
                                                    playing = true;
                                                  });
                                                },
                                              );
                                      }
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) => (bookmarkIndex !=
                                                    0 &&
                                                selectedAyah.isNotEmpty)
                                            ? HighlightedAyahSettings(
                                                ayah: selectedAyah)
                                            : Container(
                                                padding: EdgeInsets.all(20.sp),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 200.sp,
                                                      width: 200.sp,
                                                      child:
                                                          LottieBuilder.asset(
                                                        "assets/images/longtap.json",
                                                        reverse: true,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Tap and hold on any ayah to highlight and bookmark",
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              ));
                                  },
                                  child: AnimatedSize(
                                    vsync: this,
                                    duration: Duration(milliseconds: 500),
                                    child: Container(
                                      padding: EdgeInsets.all(18.sp),
                                      child: Container(
                                        padding: EdgeInsets.all(15.sp),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 1.sw,
                                              padding: EdgeInsets.all(20.sp),
                                              child: Center(
                                                  child: Row(
                                                children: [
                                                  Icon((bookmarkIndex == 0)
                                                      ? Icons
                                                          .bookmark_add_outlined
                                                      : Icons
                                                          .bookmark_border_outlined),
                                                  Text(
                                                      " $bookmarkIndex/${widget.na.toString()}")
                                                ],
                                              )),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100))),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                      ),
                                      height: 200.sp,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecitationScreen(
                                              recitation: rec.recitation,
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(18.sp),
                                      padding: EdgeInsets.all(15.sp),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Container(
                                              padding: EdgeInsets.all(10.sp),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .backgroundColor,
                                                    backgroundImage: AssetImage(
                                                        imageUrls[identifiers
                                                            .indexOf(rec
                                                                .recitation)]),
                                                  ),
                                                  SizedBox(
                                                    width: 20.sp,
                                                  ),
                                                  Flexible(
                                                    fit: FlexFit.loose,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          fit: FlexFit.loose,
                                                          child: Text(
                                                            nameEn[identifiers
                                                                    .indexOf(rec
                                                                        .recitation)]
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          fit: FlexFit.loose,
                                                          child: Text(
                                                            nameAr[identifiers
                                                                    .indexOf(rec
                                                                        .recitation)]
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100))),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : EnglishInfo()
                ],
              ),
              Container(
                color: Theme.of(context).accentColor,
                width: 1.sw,
                height: 3.sp,
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: FutureBuilder(
                  future: widget.iA
                      ? getAyahAR(widget.vs, rec.recitation)
                      : getAyahEN(widget.vs),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator(
                        color: Theme.of(context).accentColor,
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
                      if (bookmarkIndex != 0)
                        selectedAyah = snapshot.data![bookmarkIndex - 1].ayah;
                      snapshot.data!.forEach((element) {
                        reasonList.add(TextSpan(
                            recognizer: LongPressGestureRecognizer()
                              ..onLongPress = () {
                                setState(() {
                                  if (bookmarkIndex ==
                                      snapshot.data!.indexOf(element) + 1) {
                                    bookmarkIndex = 0;
                                    BookmarkPref()
                                        .setBookmark(widget.vs, bookmarkIndex);
                                  } else {
                                    bookmarkIndex =
                                        snapshot.data!.indexOf(element) + 1;
                                    BookmarkPref()
                                        .setBookmark(widget.vs, bookmarkIndex);
                                    selectedAyah =
                                        snapshot.data![bookmarkIndex - 1].ayah;
                                    showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            HighlightedAyahSettings(
                                                ayah: element.ayah));
                                  }
                                });
                              },
                            style: widget.iA
                                ? reasonList.length + 1 == counter
                                    ? TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 70.sp)
                                    : (bookmarkIndex - 1 == reasonList.length)
                                        ? TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 70.sp)
                                        : TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 70.sp)
                                : TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 60.sp),
                            text: widget.iA
                                ? element.ayah +
                                    '${getVerseEndSymbol(reasonList.length + 1)} '
                                : element.ayah + '\n\n'));
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
        if (bookmarkIndex == counter) {
          bookmarkIndex = 0;
          BookmarkPref().setBookmark(widget.vs, bookmarkIndex);
        }
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
    setState(() {
      playing = true;
      currentposition = 0;
      counter = 0;
      isOn = false;
    });
  }

  resumeQuran(AudioPlayer audioPlayer) {
    audioPlayer.resume();
    setState(() {
      playing = false;
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
                    color: Theme.of(context).accentColor,
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
                    color: Theme.of(context).accentColor,
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

class HighlightedAyahSettings extends StatefulWidget {
  const HighlightedAyahSettings({Key? key, required this.ayah})
      : super(key: key);
  final String ayah;
  @override
  _HighlightedAyahSettingsState createState() =>
      _HighlightedAyahSettingsState();
}

class _HighlightedAyahSettingsState extends State<HighlightedAyahSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.ayah,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50.sp),
            ),
            Divider(),
          ],
        ));
  }
}
