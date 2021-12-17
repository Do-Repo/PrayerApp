import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class CardFailed extends StatelessWidget {
  const CardFailed({Key? key, required VoidCallback onPressed})
      : func = onPressed,
        super(key: key);
  final VoidCallback func;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.sp),
        width: 1.sw,
        height: 300.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.secondary),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(10.sp),
            width: 1.sw,
            child: Center(
                child: IconButton(
              onPressed: func,
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.secondary,
                size: 80.sp,
              ),
            ))));
  }
}
