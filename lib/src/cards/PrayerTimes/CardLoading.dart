import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CardLoading extends StatefulWidget {
  const CardLoading({Key? key, required this.message}) : super(key: key);
  final String message;
  @override
  _CardLoadingState createState() => _CardLoadingState();
}

class _CardLoadingState extends State<CardLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20.sp,
        ),
        CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(
          height: 20.sp,
        ),
        Text(
          widget.message,
          style: TextStyle(color: Colors.white),
        )
      ],
    )));
  }
}
