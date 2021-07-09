import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranPageAR extends StatefulWidget {
  const QuranPageAR({Key key}) : super(key: key);

  @override
  _QuranPageARState createState() => _QuranPageARState();
}

class _QuranPageARState extends State<QuranPageAR> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: EdgeInsets.all(30.sp),
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ExpansionTile(
                  title: Text(
                    "Title",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 90.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Container(
                      height: 300.h,
                    )
                  ],
                ),
                Container(
                  color: Colors.green,
                  width: 1.sw,
                  height: 3.sp,
                ),
                Text(
                  "placeholder",
                  style: TextStyle(fontSize: 50.sp, color: Colors.black),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
