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
        height: 500.h + 40.sp,
        child: Center(
            child: CircularProgressIndicator(
          color: Theme.of(context).accentColor,
        )));
  }
}
