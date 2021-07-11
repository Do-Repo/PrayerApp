import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class CardFailed extends StatelessWidget {
  const CardFailed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.sp),
        width: 1.sw,
        height: 300.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
                colors: [Colors.teal, Colors.green, Colors.green[300]!])),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(20.sp),
            width: 1.sw,
            child: Center(
              child: Text(
                "Failed to connect",
                style: TextStyle(color: Colors.red),
              ),
            )));
  }
}
