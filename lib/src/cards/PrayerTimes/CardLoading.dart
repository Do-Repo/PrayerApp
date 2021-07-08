import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CardLoading extends StatefulWidget {
  const CardLoading({
    Key key,
    @required VoidCallback onpressed,
  })  : _function = onpressed,
        super(key: key);

  final VoidCallback _function;

  @override
  _CardLoadingState createState() => _CardLoadingState();
}

class _CardLoadingState extends State<CardLoading> {
  bool _timeout = false;

  Timer _timer;

  _eskettit() {
    _timer = new Timer(const Duration(seconds: 10), () {
      setState(() {
        _timeout = true;
      });
    });
  }

  void initState() {
    super.initState();
    _eskettit();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.h,
        child: Center(
            child: _timeout
                ? Container(
                    child: TextButton(
                      onPressed: () {
                        widget._function();
                        setState(() {
                          _timeout = false;
                        });
                      },
                      child: Text(
                        "Failed to get your location",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.sp),
                      ),
                    ),
                  )
                : CircularProgressIndicator(
                    color: Colors.green,
                  )));
  }
}
