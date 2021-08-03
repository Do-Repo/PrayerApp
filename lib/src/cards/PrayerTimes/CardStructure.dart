import 'dart:async';
import 'dart:convert';
import 'package:application_1/src/cards/PrayerTimes/CardDone.dart';
import 'package:application_1/src/cards/PrayerTimes/CardError.dart';
import 'package:application_1/src/cards/PrayerTimes/CardLoading.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
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
    cardmodel = getCardReady();
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
        color: Colors.white,
        child: FutureBuilder<CardModel?>(
            future: cardmodel,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return (CardLoading(
                  onpressed: () {
                    setState(() {
                      cardmodel = getCardReady();
                    });
                  },
                ));
              }
              if (snapshot.hasError) {
                return CardError(snap: snapshot);
              }
              if (snapshot.hasData) {
                return CardDone(timeString: _timeString, snap: snapshot);
              }
              return Container();
            }));
  }

  Future<CardModel?> getCardReady() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(widget.lt, widget.lot);

// GETTING CURRENT DAY FOR PRAYERTIMES
    String timestamp = widget.ts.toString();
// cALLING API
    final result = await http.get(Uri.parse(
        "http://api.aladhan.com/v1/timings/${timestamp.substring(0, 10)}?latitude=${widget.lt}&longitude=${widget.lot}&method=2"));
    if (result.statusCode == 200) {
      return CardModel.fromJson(
          jsonDecode(result.body),
          placemark.first.locality,
          placemark.first.administrativeArea,
          placemark.first.country);
    } else {
      return null;
    }
  }
}
