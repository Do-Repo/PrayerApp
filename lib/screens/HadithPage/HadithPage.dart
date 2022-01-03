import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/animator.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HadithPage extends StatefulWidget {
  const HadithPage(
      {Key? key,
      required bool isArabic,
      required int bookid,
      required String booktitle,
      required String chaptertitle,
      required int chapterid})
      : ia = isArabic,
        bi = bookid,
        bt = booktitle,
        ct = chaptertitle,
        ci = chapterid,
        super(key: key);
  final bool ia;
  final String bt, ct;
  final int bi, ci;

  @override
  _HadithPageState createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  late Future<List> _future;

  @override
  void initState() {
    _future = getHadith(widget.bi, widget.ci, widget.ia);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(
            context, false, AppLocalizations.of(context)!.hadith, true),
        body: Column(
          children: [
            Directionality(
              textDirection:
                  (widget.ia) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              child: ListTile(
                title: Text(
                  widget.bt,
                ),
                subtitle: Text(widget.ct),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: _future,
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(
                        width: 1.sw,
                        height: 200.h,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return NoConnectionWidget(
                        function: () {
                          setState(() {
                            _future =
                                getHadith(widget.bi, widget.ci, widget.ia);
                          });
                        },
                      );
                    } else {
                      List<Widget> reasonList = [];
                      snapshot.data!.forEach((element) {
                        reasonList.add(Column(
                          children: [
                            WidgetAnimator(
                              child: Material(
                                elevation: 2,
                                child: Container(
                                  padding: EdgeInsets.all(30),
                                  child: Column(
                                    children: [
                                      Directionality(
                                        textDirection: widget.ia
                                            ? ui.TextDirection.rtl
                                            : ui.TextDirection.ltr,
                                        child: Text(
                                          element.sanad,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 40.sp,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Directionality(
                                        textDirection: widget.ia
                                            ? ui.TextDirection.rtl
                                            : ui.TextDirection.ltr,
                                        child: Text(
                                          element.text,
                                          style: TextStyle(
                                            fontSize: 50.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.sp,
                            )
                          ],
                        ));
                      });
                      return Column(children: reasonList);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
