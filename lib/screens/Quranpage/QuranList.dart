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
  String text = "";
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
        title: Text(
          "Quran",
          style: (TextStyle(color: Theme.of(context).accentColor)),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
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
                      color: Theme.of(context).accentColor,
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
      body: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Directionality(
              textDirection: (iA) ? TextDirection.rtl : TextDirection.ltr,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).accentColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor))),
              ),
            ),
          ),
          Flexible(
            child: ListView(children: <Widget>[
              FutureBuilder(
                  future: _future,
                  builder:
                      (context, AsyncSnapshot<List<QuranPicker>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return LinearProgressIndicator(
                        color: Theme.of(context).accentColor,
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                          height: 500.h,
                          width: 1.sw,
                          child: Center(
                            child: Text('Error loading data',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 60.sp)),
                          ));
                    } else {
                      List<Widget> reasonList = [];
                      snapshot.data!.forEach((element) {
                        if (text.isEmpty ||
                            (text.isNotEmpty && (iA)
                                ? element.name.contains(text)
                                : element.englishNameTranslation
                                    .toUpperCase()
                                    .contains(text.toUpperCase()))) {
                          reasonList.add(ListTile(
                            tileColor: (reasonList.length.isOdd)
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).scaffoldBackgroundColor,
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
                            leading: (iA)
                                ? Text(element.number.toString())
                                : Text(''),
                            trailing: (iA)
                                ? Text('')
                                : Text(element.number.toString()),
                            title: Directionality(
                              textDirection:
                                  iA ? TextDirection.rtl : TextDirection.ltr,
                              child: Text(
                                  iA
                                      ? element.name
                                      : element.englishNameTranslation,
                                  style: TextStyle(fontSize: 60.sp)),
                            ),
                          ));
                        }
                      });
                      return Column(children: reasonList);
                    }
                  })
            ]),
          ),
        ],
      ),
    );
  }
}
