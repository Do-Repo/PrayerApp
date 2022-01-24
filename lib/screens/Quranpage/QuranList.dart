import 'package:application_1/screens/QuranPage/QuranPage.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:flutter/material.dart';
import 'package:application_1/models/quran.dart';
import 'package:application_1/src/apiCalls.dart';
import 'package:application_1/src/widgetAnimator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranList extends StatefulWidget {
  const QuranList({
    Key? key,
  }) : super(key: key);
  @override
  _QuranListState createState() => _QuranListState();
}

class _QuranListState extends State<QuranList>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("The Holy Qur'an"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  iA = !iA;
                });
              },
              icon: Icon(Icons.translate_outlined))
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Directionality(
              textDirection: (iA) ? TextDirection.rtl : TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      text = value;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
              ),
            ),
          ),
          Flexible(
              child: FutureBuilder(
                  future: _future,
                  builder:
                      (context, AsyncSnapshot<List<QuranPicker>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return LinearProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      );
                    } else if (snapshot.hasError) {
                      return NoConnectionWidget(
                        function: () {
                          setState(() {
                            _future = getSurahTitles();
                          });
                        },
                      );
                    } else {
                      List<Widget> reasonList = [];
                      for (var element in snapshot.data!) {
                        var _future2 = checkIfSaved(element.number, iA);
                        if (text.isEmpty ||
                            (text.isNotEmpty && (iA)
                                ? element.name.contains(text)
                                : element.englishName
                                    .toUpperCase()
                                    .contains(text.toUpperCase()))) {
                          reasonList.add(WidgetAnimator(
                            child: Container(
                              color: (reasonList.length.isOdd)
                                  ? Colors.transparent
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                              child: ListTile(
                                tileColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    _future2 = checkIfSaved(element.number, iA);
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuranPage(
                                              title: iA
                                                  ? element.name
                                                  : 'Surah ' +
                                                      element.englishName,
                                              isArabic: iA,
                                              numberOfAyahs:
                                                  element.numberOfAyahs,
                                              verseNumber: element.number,
                                            )),
                                  );
                                },
                                isThreeLine: true,
                                dense: true,
                                contentPadding: EdgeInsets.all(20.sp),
                                leading: (iA)
                                    ? (element.relevationType == "Meccan")
                                        ? Icon(customIcon.MyFlutterApp.mecca)
                                        : Text('')
                                    : FutureBuilder(
                                        future: _future2,
                                        builder: (context,
                                            AsyncSnapshot<bool> snap) {
                                          if (!snap.hasData) {
                                            return SizedBox(
                                              height: 24,
                                              width: 24,
                                            );
                                          } else {
                                            if (snap.data!) {
                                              return Tooltip(
                                                message:
                                                    "This is saved and can be accessed offline",
                                                child: Icon(Icons
                                                    .bookmark_added_outlined),
                                              );
                                            } else {
                                              return SizedBox(
                                                height: 24,
                                                width: 24,
                                              );
                                            }
                                          }
                                        }),
                                trailing: (iA)
                                    ? FutureBuilder(
                                        future: _future2,
                                        builder: (context,
                                            AsyncSnapshot<bool> snap) {
                                          if (!snap.hasData) {
                                            return SizedBox(
                                              height: 24,
                                              width: 24,
                                            );
                                          } else {
                                            if (snap.data!) {
                                              return Tooltip(
                                                message:
                                                    "This is saved and can be accessed offline",
                                                child: Icon(Icons
                                                    .bookmark_added_outlined),
                                              );
                                            } else {
                                              return SizedBox(
                                                height: 24,
                                                width: 24,
                                              );
                                            }
                                          }
                                        })
                                    : (element.relevationType == "Meccan")
                                        ? Icon(customIcon.MyFlutterApp.mecca)
                                        : Text(''),
                                subtitle: Directionality(
                                  textDirection: iA
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  child: Text((iA)
                                      ? 'Number of Ayahs: ' +
                                          element.numberOfAyahs.toString()
                                      : element.englishNameTranslation),
                                ),
                                title: Directionality(
                                  textDirection: iA
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  child: Text(
                                      iA
                                          ? element.name
                                          : 'Surah ' + element.englishName,
                                      style: TextStyle(fontSize: 60.sp)),
                                ),
                              ),
                            ),
                          ));
                        }
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(child: reasonList[index]);
                        },
                        itemCount: reasonList.length,
                      );
                    }
                  })),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Future<bool> checkIfSaved(int surahNumber, bool isArabic) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (isArabic) {
    if (pref.containsKey('getAyahAR$surahNumber')) {
      return true;
    } else
      return false;
  } else if (pref.containsKey("getAyahEN$surahNumber")) {
    return true;
  } else
    return false;
}
