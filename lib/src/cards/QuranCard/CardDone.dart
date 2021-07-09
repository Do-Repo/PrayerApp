import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardDone extends StatefulWidget {
  const CardDone({
    Key key,
    @required TabController tabController,
    @required AsyncSnapshot snap,
    @required bool playn,
  })  : tabcontroller = tabController,
        snapshot = snap,
        playing = playn,
        super(key: key);
  final TabController tabcontroller;
  final AsyncSnapshot snapshot;
  final bool playing;
  @override
  _CardDoneState createState() => _CardDoneState();
}

class _CardDoneState extends State<CardDone> {
  PlayerState playerState;

  AudioPlayer _audioPlayer = AudioPlayer();
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
                gradient: LinearGradient(
                    colors: [Colors.teal, Colors.green, Colors.green[300]])),
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
                  color: Colors.white,
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
                gradient: LinearGradient(
                    colors: [Colors.teal, Colors.green, Colors.green[300]])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(25),
                        )),
                    child: Center(
                      child: TextButton(
                          onPressed: () {
                            playSound();
                          },
                          child: widget.playing
                              ? Icon(
                                  Icons.volume_off,
                                  color: Colors.green,
                                  size: 70.sp,
                                )
                              : Icon(
                                  Icons.volume_up,
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
                        Text(
                          widget.snapshot.data.audioName,
                          style: TextStyle(
                              fontSize: 50.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.sp),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(25),
                      )),
                  child: IconButton(
                      onPressed: () {
                        widget.tabcontroller.animateTo(3);
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

  void playSound() {
    setState(() {
      if (!widget.playing) {
        _audioPlayer.play();
      } else
        _audioPlayer.stop();
    });
  }
}