import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({Key key, @required TabController tabController})
      : tab = tabController,
        super(key: key);
  final TabController tab;
  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        widget.tab.animateTo(0);
      },

      child: SingleChildScrollView(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.all(30.sp),
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      "Title",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 90.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.keyboard_arrow_down),
                    color: Colors.green,
                    iconSize: 90.sp,
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
    );
  }
}
