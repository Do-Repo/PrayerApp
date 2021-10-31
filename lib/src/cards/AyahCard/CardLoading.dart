import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardLoading extends StatelessWidget {
  const CardLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.sp),
        width: 1.sw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(colors: [
              (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.green
                  : Colors.teal,
              Colors.green,
              (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.green
                  : Colors.green[300]!
            ])),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(20.sp),
            width: 1.sw,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )));
  }
}
