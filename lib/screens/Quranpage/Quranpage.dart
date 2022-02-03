import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:application_1/screens/SettingsPage/Recitation.dart';
import 'package:application_1/src/advancedSettings.dart';
import 'package:application_1/src/apiCalls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quran/quran.dart';

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

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  int counter = 0;
  bool isOn = false;
  int currentposition = 0;
  AudioPlayer audio = AudioPlayer();
  int duration = 0;
  int bookmarkIndex = 0;
  String selectedAyah = "";
  double fontsize = 50.sp;
  String font = "Tajawal";
  bool playing = true;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
    var rec = Provider.of<AdvancedSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.iA)
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (font == "Tajawal") {
                        font = "Scheherazade New";
                      } else if (font == "Scheherazade New") {
                        font = "Noto Nastaliq Urdu";
                      } else {
                        font = "Tajawal";
                      }
                    });
                  },
                  icon: Icon(Icons.font_download_outlined)),
            if (widget.iA)
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (fontsize == 50.sp) {
                        fontsize = 70.sp;
                      } else if (fontsize == 70.sp) {
                        fontsize = 90.sp;
                      } else {
                        fontsize = 50.sp;
                      }
                    });
                  },
                  icon: Icon(Icons.format_size_rounded)),
            Spacer(),
            Text(
              widget.t,
              style: TextStyle(fontSize: 80.sp),
            )
          ],
        ),
        bottom: (widget.iA)
            ? TabBar(
                controller: tabController,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: const [
                    Tab(
                      text: "FULL SURAH",
                    ),
                    Tab(
                      text: "AYAH BY AYAH",
                    ),
                  ])
            : PreferredSize(child: Container(), preferredSize: Size(0, 0)),
      ),
      body: Column(
        children: [
          Directionality(
            textDirection: (widget.iA) ? TextDirection.rtl : TextDirection.ltr,
            child: Expanded(
                child: FutureBuilder(
                    future: Future.wait([
                      getAyahAR(widget.vs, rec.recitation),
                      getAyahEN(widget.vs)
                    ]),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            LinearProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return NoConnectionWidget(
                          function: () {
                            widget.iA
                                ? getAyahAR(widget.vs, rec.recitation)
                                : getAyahEN(widget.vs);
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: (widget.iA)
                              ? TabBarView(
                                  controller: tabController,
                                  children: [
                                      fullSurah(rec, snapshot.data![0],
                                          snapshot.data![1], fontsize),
                                      ayahByAyah(rec, snapshot.data![0],
                                          snapshot.data![1], fontsize),
                                    ])
                              : fullSurah(rec, snapshot.data![1],
                                  snapshot.data![0], fontsize),
                        );
                      }
                    })),
          ),
          (widget.iA)
              ? Container(
                  width: 1.sw,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: getAyahAR(widget.vs, rec.recitation),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Container(
                              padding: EdgeInsets.all(30.sp),
                              height: 200.sp,
                              width: 200.sp,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 17.sp,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  getAyahAR(widget.vs, rec.recitation);
                                });
                              },
                              child: Icon(
                                Icons.refresh,
                                size: 200.sp,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            List<String> reasonList = [];
                            for (var element in snapshot.data!) {
                              reasonList.add(element.audio);
                            }
                            return playing
                                ? InkWell(
                                    onTap: () {
                                      playing = false;
                                      isOn
                                          ? resumeQuran(audio)
                                          : playQuran(reasonList, audio);
                                    },
                                    child: Icon(
                                      Icons.play_circle_outline_outlined,
                                      size: 200.sp,
                                      color: Colors.white,
                                    ),
                                  )
                                : InkWell(
                                    child: Icon(
                                      Icons.pause_circle_outline_outlined,
                                      size: 200.sp,
                                      color: Colors.white,
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
                      InkWell(
                        onTap: () {
                          if (bookmarkIndex == 0) {
                            showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      padding: EdgeInsets.all(20.sp),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 200.sp,
                                            width: 200.sp,
                                            child: LottieBuilder.asset(
                                              "assets/images/longtap.json",
                                              reverse: true,
                                            ),
                                          ),
                                          Text(
                                            "Tap and hold on any Ayah to highlight and bookmark",
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ));
                          }
                        },
                        child: AnimatedSize(
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
                                            ? Icons.bookmark_add_outlined
                                            : Icons.bookmark_border_outlined),
                                        Text(
                                            " $bookmarkIndex/${widget.na.toString()}")
                                      ],
                                    )),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
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
                                  builder: (context) => RecitationScreen(
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
                                              Theme.of(context).backgroundColor,
                                          backgroundImage: AssetImage(imageUrls[
                                              identifiers
                                                  .indexOf(rec.recitation)]),
                                        ),
                                        SizedBox(
                                          width: 20.sp,
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  nameEn[identifiers.indexOf(
                                                          rec.recitation)]
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  nameAr[identifiers.indexOf(
                                                          rec.recitation)]
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget ayahByAyah(AdvancedSettingsProvider rec, List<dynamic> quranInit,
      List<dynamic> quranTranslated, double fontsize) {
    List<Widget> reasonList = [];

    if (bookmarkIndex != 0) {
      selectedAyah = quranInit[bookmarkIndex - 1].ayah;
    }
    for (var element in quranInit) {
      reasonList.add(InkWell(
        onLongPress: () {
          setState(() {
            if (bookmarkIndex == quranInit.indexOf(element) + 1) {
              bookmarkIndex = 0;
              BookmarkPref().setBookmark(widget.vs, bookmarkIndex);
            } else {
              bookmarkIndex = quranInit.indexOf(element) + 1;
              BookmarkPref().setBookmark(widget.vs, bookmarkIndex);
              selectedAyah = quranInit[bookmarkIndex - 1].ayah;
            }
          });
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10.sp),
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
          child: Column(
            children: [
              Text(element.ayah + getVerseEndSymbol(reasonList.length + 1),
                  style: GoogleFonts.getFont(font,
                      textStyle: reasonList.length + 1 == counter
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: fontsize,
                            )
                          : (bookmarkIndex - 1 == reasonList.length)
                              ? TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: fontsize,
                                )
                              : TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: fontsize,
                                ))),
              Divider(),
              Text(
                quranTranslated[quranInit.indexOf(element)].ayah,
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ));
    }
    return ListView.builder(
      itemCount: reasonList.length,
      itemBuilder: (context, index) {
        return Container(
          child: reasonList[index],
        );
      },
    );
  }

  Widget fullSurah(AdvancedSettingsProvider rec, List<dynamic> quranInit,
      List<dynamic> quranTranslated, double fontsize) {
    List<TextSpan> reasonList = [];
    if (bookmarkIndex != 0) {
      selectedAyah = quranInit[bookmarkIndex - 1].ayah;
    }
    for (var element in quranInit) {
      reasonList.add(TextSpan(
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              setState(() {
                if (bookmarkIndex == quranInit.indexOf(element) + 1) {
                  bookmarkIndex = 0;
                  BookmarkPref().setBookmark(widget.vs, bookmarkIndex);
                } else {
                  bookmarkIndex = quranInit.indexOf(element) + 1;
                  BookmarkPref().setBookmark(widget.vs, bookmarkIndex);
                  selectedAyah = quranInit[bookmarkIndex - 1].ayah;
                }
              });
            },
          style: GoogleFonts.getFont(
            font,
            textStyle: widget.iA
                ? reasonList.length + 1 == counter
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: fontsize,
                      )
                    : (bookmarkIndex - 1 == reasonList.length)
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: fontsize,
                          )
                        : TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: fontsize,
                          )
                : TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: fontsize,
                  ),
          ),
          text: widget.iA
              ? element.ayah + '${getVerseEndSymbol(reasonList.length + 1)} '
              : element.ayah + '\n\n'));
    }
    return SingleChildScrollView(
      child: RichText(
          text: TextSpan(
        children: reasonList,
      )),
    );
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

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key, required this.function})
      : super(key: key);
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: function,
      title: Text(
        "Failed to connect",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50.sp),
      ),
      subtitle: Text(
          'For the first time you need to be connected to the Internet, next time you can come back offline. Connect to the Internet and tap here to retry'),
      leading: Icon(
        customIcon.MyFlutterApp.no_wifi,
        size: 200.sp,
      ),
    );
  }
}
