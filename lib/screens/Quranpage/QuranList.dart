import 'package:application_1/screens/Quranpage/Quranpage.dart';
import 'package:application_1/screens/Settings/Settings.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:application_1/models/QuranModel.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
          style: (TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        elevation: 0,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
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
                      color: Theme.of(context).colorScheme.secondary,
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
            child: ListView(children: <Widget>[
              FutureBuilder(
                  future: _future,
                  builder:
                      (context, AsyncSnapshot<List<QuranPicker>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return LinearProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                          height: 500.h,
                          width: 1.sw,
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(
                              "Failed to connect to the internet",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 50.sp),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.grey),
                                  text:
                                      "Make sure you're connected to the Internet and try again.",
                                  children: <TextSpan>[
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showMaterialModalBottomSheet(
                                                context: context,
                                                builder: (context) => Container(
                                                      padding:
                                                          EdgeInsets.all(20.sp),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Why do I have to be connected to the internet?",
                                                            style: TextStyle(
                                                                fontSize: 50.sp,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "\nAll the data in the app like Quran, Hadith, Audio files and Country names are stored online in order to keep the application size reasonable. \n \nThere's nothing to worry about since none of your data is being stored online.",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    40.sp),
                                                          )
                                                        ],
                                                      ),
                                                    ));
                                          },
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w400),
                                        text:
                                            "\nWhy do I need to be connected to the internet?")
                                  ]),
                            ),
                            leading: Icon(
                              customIcon.MyFlutterApp.no_wifi,
                              size: 200.sp,
                            ),
                          ));
                    } else {
                      if (snapshot.data!.first.onError) {
                        return Center(
                          child: customErrorWidget(),
                        );
                      } else {
                        List<Widget> reasonList = [];
                        snapshot.data!.forEach((element) {
                          if (text.isEmpty ||
                              (text.isNotEmpty && (iA)
                                  ? element.name.contains(text)
                                  : element.englishName
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
                                                : element.englishName,
                                            isArabic: iA,
                                            numberOfAyahs:
                                                element.numberOfAyahs,
                                            verseNumber: element.number,
                                          )),
                                );
                              },
                              dense: true,
                              contentPadding: EdgeInsets.all(20.sp),
                              leading: (iA)
                                  ? (element.relevationType == "Meccan")
                                      ? Icon(customIcon.MyFlutterApp.mecca)
                                      : Text('')
                                  : Text(''),
                              trailing: (iA)
                                  ? Text('')
                                  : (element.relevationType == "Meccan")
                                      ? Icon(customIcon.MyFlutterApp.mecca)
                                      : Text(''),
                              subtitle: Directionality(
                                textDirection:
                                    iA ? TextDirection.rtl : TextDirection.ltr,
                                child: Text((iA)
                                    ? 'Number of ayahs: ' +
                                        element.numberOfAyahs.toString()
                                    : element.englishNameTranslation),
                              ),
                              title: Directionality(
                                textDirection:
                                    iA ? TextDirection.rtl : TextDirection.ltr,
                                child: Text(
                                    iA ? element.name : element.englishName,
                                    style: TextStyle(fontSize: 60.sp)),
                              ),
                            ));
                          }
                        });
                        return Column(children: reasonList);
                      }
                    }
                  })
            ]),
          ),
        ],
      ),
    );
  }
}
