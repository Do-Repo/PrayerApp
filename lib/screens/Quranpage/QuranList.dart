import 'package:application_1/screens/Quranpage/Quranpage.dart';
import 'package:application_1/screens/Settings/Settings.dart';
import 'package:application_1/src/customWidgets/API.dart';

import 'package:application_1/models/QuranModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranList extends StatefulWidget {
  const QuranList({Key? key}) : super(key: key);

  @override
  _QuranListState createState() => _QuranListState();
}

class _QuranListState extends State<QuranList> {
  Future<List<QuranPicker>>? _future;
  bool iA = true;
  @override
  void initState() {
    super.initState();
    _future = getSurahTitles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 100.sp,
                ));
          },
        ),
        iconTheme: IconThemeData(color: Colors.green),
        actions: [
          Container(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      (iA) ? iA = false : iA = true;
                    });
                  },
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Text(
                    (iA) ? 'AR' : 'EN',
                    style: TextStyle(
                      fontSize: 70.sp,
                      color: Colors.green,
                    ),
                  ))),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
              },
              icon: Icon(
                Icons.settings_outlined,
                size: 90.sp,
              )),
        ],
      ),
      body: ListView(children: <Widget>[
        FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return LinearProgressIndicator(
                  color: Colors.green,
                );
              } else if (snapshot.hasError) {
                return Container(
                    height: 500.h,
                    width: 1.sw,
                    child: Center(
                      child: Text('Error loading data',
                          style: TextStyle(color: Colors.red, fontSize: 60.sp)),
                    ));
              } else {
                List<Widget> reasonList = [];
                snapshot.data!.forEach((element) {
                  reasonList.add(ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuranPage(
                                  title: iA
                                      ? element.name
                                      : element.englishNameTranslation,
                                  isArabic: iA,
                                  numberOfAyahs: element.numberOfAyahs,
                                  verseNumber: element.number,
                                )),
                      );
                    },
                    dense: true,
                    contentPadding: EdgeInsets.all(20.sp),
                    selectedTileColor: Colors.green,
                    leading: (iA) ? Text(element.number.toString()) : Text(''),
                    trailing: (iA) ? Text('') : Text(element.number.toString()),
                    title: Directionality(
                      textDirection: iA ? TextDirection.rtl : TextDirection.ltr,
                      child: Text(
                        iA ? element.name : element.englishNameTranslation,
                        style: (iA)
                            ? TextStyle(fontSize: 60.sp)
                            : TextStyle(fontSize: 70.sp),
                      ),
                    ),
                  ));
                });
                return Column(children: reasonList);
              }
            })
      ]),
    );
  }
}
