import 'dart:async';

import 'package:application_1/src/cards/PrayerTimes/CardDone.dart';
import 'package:application_1/src/cards/PrayerTimes/CardError.dart';
import 'package:application_1/src/cards/PrayerTimes/CardLoading.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:application_1/models/PrayerTimeCard.dart';

typedef Future<CardModel> FutureGenerator();

class PrayertimesCard extends StatefulWidget {
  const PrayertimesCard(
      {Key? key,
      required double latitude,
      required int timestamp,
      required double longitude})
      : lt = latitude,
        ts = timestamp,
        lot = longitude,
        super(key: key);
  final double lt;
  final int ts;
  final double lot;

  @override
  _PrayertimesCardState createState() => _PrayertimesCardState();
}

class _PrayertimesCardState extends State<PrayertimesCard> {
  String? _timeString;
  late Timer t;

  Future<CardModel?>? cardmodel;
  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTimeSeconds(DateTime.now());
    t = new Timer.periodic(Duration(seconds: 1), (Timer timer) => _getTime());
    cardmodel = getCardReady(widget.ts, widget.lt, widget.lot);
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTimeSeconds(now);

    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTimeSeconds(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<CardModel?>(
            future: cardmodel,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return (CardLoading());
              }
              if (snapshot.hasError) {
                return CardError(
                  snap: snapshot,
                  onPressed: () {
                    setState(() {
                      cardmodel =
                          getCardReady(widget.ts, widget.lt, widget.lot);
                    });
                  },
                );
              }
              if (snapshot.hasData) {
                return CardDone(timeString: _timeString, snap: snapshot);
              }
              return Container();
            }));
  }
}
