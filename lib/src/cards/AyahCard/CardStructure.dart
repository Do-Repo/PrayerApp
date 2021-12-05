import 'dart:async';

import 'package:application_1/src/cards/AyahCard/CardDone.dart';
import 'package:application_1/src/cards/AyahCard/CardError.dart';
import 'package:application_1/src/cards/AyahCard/CardLoading.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:application_1/models/RandomVerse.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AyahCard extends StatefulWidget {
  const AyahCard({Key? key, required this.recitation}) : super(key: key);
  final String recitation;
  @override
  _AyahCardState createState() => _AyahCardState();
}

class _AyahCardState extends State<AyahCard> {
  Future<RandomVerse?>? randomVerse;

  bool? playing = false;

  PlayerState? playerState;

  final _audioPlayer = AudioPlayer();
  late int randomnumber;
  Random random = new Random();
  @override
  void initState() {
    randomnumber = random.nextInt(6237) + 1;
    randomVerse = getVerse(widget.recitation, randomnumber, _audioPlayer);
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 10,
        child: FutureBuilder<RandomVerse?>(
            future: randomVerse,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CardLoading();
              } else if (snapshot.hasError) {
                return CardFailed(
                  onPressed: () {
                    setState(() {
                      randomVerse = getVerse(
                          widget.recitation, randomnumber, _audioPlayer);
                    });
                  },
                );
              } else {
                return CardDone(
                  audioPlayer: _audioPlayer,
                  snap: snapshot,
                );
              }
            }));
  }
}
