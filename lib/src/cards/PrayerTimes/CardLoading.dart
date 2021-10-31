import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CardLoading extends StatefulWidget {
  const CardLoading({
    Key? key,
  }) : super(key: key);

  @override
  _CardLoadingState createState() => _CardLoadingState();
}

class _CardLoadingState extends State<CardLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.h,
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.green,
        )));
  }
}
