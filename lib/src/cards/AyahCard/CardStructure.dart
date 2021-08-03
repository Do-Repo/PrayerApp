import 'dart:async';
import 'dart:convert';
import 'package:application_1/src/cards/AyahCard/CardDone.dart';
import 'package:application_1/src/cards/AyahCard/CardError.dart';
import 'package:application_1/src/cards/AyahCard/CardLoading.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:application_1/models/RandomVerse.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AyahCard extends StatefulWidget {
  const AyahCard({
    Key? key,
    required TabController? tabController,
  })  : tabcontroller = tabController,
        super(key: key);
  final TabController? tabcontroller;
  @override
  _AyahCardState createState() => _AyahCardState();
}

class _AyahCardState extends State<AyahCard> {
  Future<RandomVerse?>? randomVerse;

  bool? playing = false;

  PlayerState? playerState;

  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    randomVerse = getVerse();

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
              if (snapshot.hasData) {
                return CardDone(
                  audioPlayer: _audioPlayer,
                  tabController: widget.tabcontroller,
                  snap: snapshot,
                );
              } else if (snapshot.hasError) {
                print('snapshot error ${snapshot.error}');
                return CardFailed();
              } else {
                return CardLoading();
              }
            }));
  }

  Future<RandomVerse?> getVerse() async {
    Random random = new Random();

    int randomNumber = random.nextInt(6237) + 1;
    final result = await http.get(Uri.parse(
        "http://api.alquran.cloud/v1/ayah/${randomNumber.toString()}/ar.alafasy"));

    var data = jsonDecode(result.body);
    if (result.statusCode == 200) {
      int results = await _audioPlayer.setUrl(data['data']['audio']);

      if (results == 1) {
        return RandomVerse.fromJson(jsonDecode(result.body));
      }
    } else {
      print("error");
      return null;
    }
  }
}
