import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardLoading extends StatelessWidget {
  const CardLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.sp),
        width: 1.sw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.secondary),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(20.sp),
            width: 1.sw,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 10.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )));
  }
}
