import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardError extends StatelessWidget {
  const CardError({
    Key? key,
    required AsyncSnapshot snap,
  })  : snapshot = snap,
        super(key: key);

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420.h,
      child: Center(
        child: Column(
          children: [
            Text(
              "ERROR PLEASE REPORT",
              style: TextStyle(color: Colors.red, fontSize: 70.sp),
            ),
            Text(
              snapshot.error.toString(),
              style: TextStyle(color: Colors.red, fontSize: 30.sp),
            ),
          ],
        ),
      ),
    );
  }
}
