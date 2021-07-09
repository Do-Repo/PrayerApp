import 'dart:convert';
import 'package:application_1/models/QuranModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class CustomTile extends StatefulWidget {
  const CustomTile({Key key, @required String title, @required String apiLink})
      : t = title,
        api = apiLink,
        super(key: key);
  final String t;
  final String api;
  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  Future<List<QuranPicker>> _future;
  @override
  void initState() {
    super.initState();
    _future = getTile(widget.api);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        textColor: Colors.green,
        iconColor: Colors.green,
        title: Text(
          widget.t,
          style: TextStyle(fontSize: 70.sp),
        ),
        initiallyExpanded: false,
        children: <Widget>[
          new FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: const Text('Loading...'),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: const Text('Error loading data'),
                  );
                } else {
                  List<QuranPicker> data = snapshot.data;
                  List<Widget> reasonList = [];
                  data.forEach((element) {
                    reasonList.add(ListTile(
                      onTap: () {
                        print(element.number);
                      },
                      dense: true,
                      contentPadding: EdgeInsets.all(20.sp),
                      selectedTileColor: Colors.green,
                      leading: Text(element.number.toString()),
                      trailing: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          element.name,
                          style: TextStyle(fontSize: 60.sp),
                        ),
                      ),
                    ));
                  });
                  return Column(children: reasonList);
                }
              })
        ]);
  }
}

Future<List<QuranPicker>> getTile(String x) async {
  final result = await http.get(Uri.parse(x));
  if (result.statusCode == 200) {
    List jsonResponse = json.decode(result.body)['data'];
    return jsonResponse.map((data) => new QuranPicker.fromJson(data)).toList();
  } else {
    print("error");
  }
}
