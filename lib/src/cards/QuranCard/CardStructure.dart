import 'dart:async';
import 'dart:convert';
import 'package:application_1/src/cards/QuranCard/CardDone.dart';
import 'package:application_1/src/cards/QuranCard/CardError.dart';
import 'package:application_1/src/cards/QuranCard/CardLoading.dart';
import 'package:http/http.dart' as http;
import 'package:application_1/models/RandomVerse.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:just_audio/just_audio.dart';

class QuranCard extends StatefulWidget {
  const QuranCard({
    Key key,
    @required TabController tabController,
  })  : tabcontroller = tabController,
        super(key: key);
  final TabController tabcontroller;
  @override
  _QuranCardState createState() => _QuranCardState();
}

class _QuranCardState extends State<QuranCard> {
  Future<RandomVerse> randomVerse;

  bool playing;

  PlayerState playerState;

  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    randomVerse = getVerse();
    _audioPlayer.playerStateStream.listen((playerState) {
      final processingState = playerState.processingState;
      final isPlaying = playerState.playing;
      if (!isPlaying) {
        playing = false;
      } else if (processingState != ProcessingState.completed) {
        playing = true;
      } else if (processingState == ProcessingState.completed) {
        playing = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 10,
        child: FutureBuilder<RandomVerse>(
            future: randomVerse,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CardDone(
                  tabController: widget.tabcontroller,
                  snap: snapshot,
                  playn: playing,
                );
              } else if (snapshot.hasError) {
                return CardFailed();
              } else {
                return CardLoading();
              }
            }));
  }

  Future<RandomVerse> getVerse() async {
    Random random = new Random();

    int randomNumber = random.nextInt(6237) + 1;
    final result = await http.get(Uri.parse(
        "http://api.alquran.cloud/v1/ayah/${randomNumber.toString()}/ar.alafasy"));
    var data = jsonDecode(result.body);
    if (result.statusCode == 200) {
      await _audioPlayer.setUrl(data['data']['audio']);

      return RandomVerse.fromJson(jsonDecode(result.body));
    } else {
      print("error");
    }
  }
}
