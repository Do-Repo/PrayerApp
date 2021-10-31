import 'package:application_1/screens/Quranpage/Quranpage.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';

class CardDone extends StatefulWidget {
  const CardDone({
    Key? key,
    required AsyncSnapshot snap,
    required AudioPlayer audioPlayer,
  })  : audioplayer = audioPlayer,
        snapshot = snap,
        super(key: key);

  final AsyncSnapshot snapshot;
  final AudioPlayer audioplayer;

  @override
  _CardDoneState createState() => _CardDoneState();
}

class _CardDoneState extends State<CardDone> {
  PlayerState? playerState;
  bool playiin = false;
  @override
  void initState() {
    super.initState();
    changeButton();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 20.sp,
              left: 20.sp,
              right: 20.sp,
            ),
            width: 1.sw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.green
                      : Colors.teal,
                  Colors.green,
                  (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.green
                      : Colors.green[300]!
                ])),
            child: Container(
              padding: EdgeInsets.all(20.sp),
              width: 1.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(widget.snapshot.data.surahNameAR,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 50.sp)),
                      ),
                      Text(
                          widget.snapshot.data.numberOfAyah.toString() +
                              '/' +
                              widget.snapshot.data.ayahsInSurah.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 50.sp)),
                    ],
                  ),
                  Text(
                    widget.snapshot.data.ayahText,
                    style: TextStyle(fontSize: 50.sp),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.sp),
            height: 150.sp,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.green
                      : Colors.teal,
                  Colors.green,
                  (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.green
                      : Colors.green[300]!
                ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                        )),
                    child: Center(
                      child: TextButton(
                          onPressed: () {
                            playSound(widget.audioplayer);
                          },
                          child: playiin
                              ? Icon(
                                  Icons.volume_up,
                                  color: Colors.green,
                                  size: 70.sp,
                                )
                              : Icon(
                                  Icons.volume_off,
                                  color: Colors.green,
                                  size: 70.sp,
                                )),
                    )),
                Container(
                  padding: EdgeInsets.only(left: 20.sp),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'صوت:',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 50.sp),
                        ),
                        Container(
                          width: 40.sp,
                        ),
                        Flexible(
                          child: Text(
                            widget.snapshot.data.audioName,
                            style: TextStyle(
                                fontSize: 50.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.sp),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                      )),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuranPage(
                                    title: widget.snapshot.data.surahNameAR,
                                    isArabic: true,
                                    numberOfAyahs:
                                        widget.snapshot.data.ayahsInSurah,
                                    verseNumber:
                                        widget.snapshot.data.numberOfSurah,
                                  )),
                        );
                      },
                      iconSize: 90.sp,
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.green,
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void changeButton() {
    widget.audioplayer.onPlayerStateChanged.listen((playerState) {
      if (PlayerState.PLAYING == playerState) {
        playiin = true;
      } else if (PlayerState.COMPLETED == playerState ||
          PlayerState.STOPPED == playerState) {
        playiin = false;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  void playSound(AudioPlayer _audioPlayer) {
    setState(() {
      if (!playiin) {
        _audioPlayer.resume();
      } else
        _audioPlayer.stop();
    });
  }
}
