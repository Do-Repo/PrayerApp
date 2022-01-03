import 'package:application_1/screens/Quranpage/Quranpage.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:application_1/models/QuranModel.dart';
import 'package:application_1/src/customWidgets/animator.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuranList extends StatefulWidget {
  const QuranList({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;
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
    return WillPopScope(
      onWillPop: () {
        widget.pageController.animateToPage(0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutQuart);
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          children: [
            customHomeAppbar(context, widget.pageController,
                AppLocalizations.of(context)!.theHolyQuran, true, () {
              setState(() {
                iA = !iA;
              });
            }),
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
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary))),
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
                        snapshot.data!.forEach((element) {
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
                                    : Theme.of(context).backgroundColor,
                                child: ListTile(
                                  tileColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      _future2 =
                                          checkIfSaved(element.number, iA);
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuranPage(
                                                title: iA
                                                    ? element.name
                                                    : element.englishName,
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
                                                  message: AppLocalizations.of(
                                                          context)!
                                                      .tooltip,
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
                                                  message: AppLocalizations.of(
                                                          context)!
                                                      .tooltip,
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
                                        ? AppLocalizations.of(context)!
                                                .numberOfAyahs +
                                            ' ' +
                                            element.numberOfAyahs.toString()
                                        : element.englishNameTranslation),
                                  ),
                                  title: Directionality(
                                    textDirection: iA
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    child: Text(
                                        iA ? element.name : element.englishName,
                                        style: TextStyle(fontSize: 60.sp)),
                                  ),
                                ),
                              ),
                            ));
                          }
                        });
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
