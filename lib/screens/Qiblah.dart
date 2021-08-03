import 'package:flutter/material.dart';

class Qiblah extends StatefulWidget {
  const Qiblah({Key? key, required TabController? tabController})
      : tc = tabController,
        super(key: key);

  final TabController? tc;
  @override
  _QiblahState createState() => _QiblahState();
}

class _QiblahState extends State<Qiblah> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.tc!.animateTo(0) as Future<bool>,
      child: Container(),
    );
  }
}
