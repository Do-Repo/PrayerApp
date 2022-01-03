import 'package:application_1/screens/Quranpage/Quranpage.dart';
import 'package:application_1/screens/Settings/Recitation.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

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
    var rec = Provider.of<RecitationProvider>(context, listen: false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 10.sp,
              left: 10.sp,
              right: 10.sp,
            ),
            width: 1.sw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Theme.of(context).colorScheme.secondary),
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
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 50.sp)),
                      ),
                      Text(
                          widget.snapshot.data.numberOfAyah.toString() +
                              '/' +
                              widget.snapshot.data.ayahsInSurah.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
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
            padding: EdgeInsets.all(10.sp),
            height: 150.sp,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Theme.of(context).colorScheme.secondary),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 70.sp,
                                )
                              : Icon(
                                  Icons.volume_off,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 70.sp,
                                )),
                    )),
                Container(
                  padding: EdgeInsets.only(left: 10.sp),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              RecitationScreen(recitation: rec.recitation)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'صوت:',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
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
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.sp),
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
                        color: Theme.of(context).colorScheme.secondary,
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
