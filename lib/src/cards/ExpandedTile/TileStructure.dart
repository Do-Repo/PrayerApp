import 'dart:convert';
import 'package:application_1/models/QuranModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class CustomTile extends StatefulWidget {
  const CustomTile(
      {Key? key,
      required String title,
      required String subtitle,
      required IconData icon,
      required List<Widget> children})
      : t = title,
        s = subtitle,
        i = icon,
        l = children,
        super(key: key);
  final String t;
  final String s;
  final IconData i;
  final List<Widget> l;
  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      textColor: Colors.green,
      trailing:
          RotatedBox(quarterTurns: 1, child: Icon(Icons.arrow_forward_ios)),
      iconColor: Colors.green,
      leading: Icon(
        widget.i,
        size: 120.sp,
      ),
      title: Text(
        widget.t,
        style: TextStyle(fontSize: 70.sp),
      ),
      subtitle: Text(widget.s),
      initiallyExpanded: false,
      children: widget.l,
    );
  }
}

Future<List<QuranPicker>> getTile(String x) async {
  final result = await http.get(Uri.parse(x));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data'];
    return jsonResponse.map((data) => new QuranPicker.fromJson(data)).toList();
  } else {
    print("error");
    return <QuranPicker>[];
  }
}
