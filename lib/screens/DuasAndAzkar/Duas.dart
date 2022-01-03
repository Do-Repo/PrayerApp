import 'package:application_1/models/DuasModel.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/animator.dart';
import 'package:application_1/src/customWidgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:application_1/src/customIcons/my_flutter_app_icons.dart'
    as customIcon;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DuasPage extends StatefulWidget {
  const DuasPage({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;
  @override
  _DuasPageState createState() => _DuasPageState();
}

class _DuasPageState extends State<DuasPage>
    with AutomaticKeepAliveClientMixin {
  List<Widget> reasonList = [];
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
              AppLocalizations.of(context)!.duas, false, () {}),
          Flexible(
            child: FutureBuilder(
              future: getDuas(context),
              builder: (context, AsyncSnapshot<List<DuasModel>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Spacer()
                    ],
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return NoConnectionWidget(function: () {
                    setState(() {
                      getDuas(context);
                    });
                  });
                } else {
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      if (i == 9) {
                        //ListTile acting as subtitle to divide duas from azkar
                        return WidgetAnimator(
                          child: Container(
                            color: Theme.of(context).backgroundColor,
                            child: ListTile(
                              tileColor: Colors.transparent,
                              title: Text(
                                "Azkar",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50.sp),
                              ),
                            ),
                          ),
                        );
                      }
                      if (i <= 8)
                        //Duas expansiontiles
                        return WidgetAnimator(
                          child: ExpansionTile(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                              title: Text(
                                snapshot.data![i].title,
                                style: TextStyle(fontSize: 45.sp),
                              ),
                              children: List.generate(
                                  snapshot.data![i].children.length,
                                  (int index) => ListTile(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Duas(
                                                      title: snapshot
                                                          .data![i].title,
                                                      subtitle: snapshot
                                                          .data![i]
                                                          .children[index]
                                                          .title,
                                                      content: snapshot
                                                          .data![i]
                                                          .children[index]
                                                          .children,
                                                    ))),
                                        title: Text(snapshot
                                            .data![i].children[index].title),
                                      )),
                              leading: Icon(
                                image[i],
                                size: 100.sp,
                              )),
                        );
                      else
                        //Azkar expansiontiles
                        //Using index - 1 to match iconlist because subtitle listtile uses one index
                        return WidgetAnimator(
                          child: ExpansionTile(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.05),
                              title: Text(
                                snapshot.data![i - 1].title,
                                style: TextStyle(fontSize: 45.sp),
                              ),
                              children: List.generate(
                                  snapshot.data![i - 1].children.length,
                                  (int index) => ListTile(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Duas(
                                                      title: snapshot
                                                          .data![i - 1].title,
                                                      subtitle: snapshot
                                                          .data![i - 1]
                                                          .children[index]
                                                          .title,
                                                      content: snapshot
                                                          .data![i - 1]
                                                          .children[index]
                                                          .children,
                                                    ))),
                                        title: Text(snapshot.data![i - 1]
                                            .children[index].title),
                                      )),
                              leading: Icon(
                                image[i - 1],
                                size: 100.sp,
                              )),
                        );
                    },
                    itemCount: image.length + 1,
                  );
                }
              },
            ),
          ),
        ],
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Duas extends StatefulWidget {
  const Duas(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.content})
      : super(key: key);
  final String title;
  final String subtitle;
  final List<Cases> content;

  @override
  _DuasState createState() => _DuasState();
}

class _DuasState extends State<Duas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context, false, widget.title, true),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                widget.subtitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 2.sp,
              width: 1.sw,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.content.length,
                      (int i) => WidgetAnimator(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20.sp,
                              bottom: 20.sp,
                              left: 10.sp,
                              right: 10.sp),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20.sp),
                                child: GestureDetector(
                                  onLongPress: () {
                                    Clipboard.setData(new ClipboardData(
                                        text: widget.content[i].arabic));
                                    showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                            width: 1.sw,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(20.sp),
                                                    child: Text(
                                                      "Copied to clipboard",
                                                      style: TextStyle(
                                                          fontSize: 40.sp),
                                                    ),
                                                  ),
                                                ])));
                                  },
                                  child: Text(
                                    widget.content[i].arabic,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 60.sp),
                                  ),
                                ),
                              ),
                              ExpansionTile(
                                trailing: SizedBox(),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.1),
                                title: Text("Translate"),
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      Clipboard.setData(new ClipboardData(
                                          text: widget.content[i].english));
                                      showMaterialModalBottomSheet(
                                          context: context,
                                          builder: (context) => Container(
                                              width: 1.sw,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(20.sp),
                                                      child: Text(
                                                        "Copied to clipboard",
                                                        style: TextStyle(
                                                            fontSize: 40.sp),
                                                      ),
                                                    ),
                                                  ])));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(20.sp),
                                      child: Text(
                                        widget.content[i].english,
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(fontSize: 50.sp),
                                      ),
                                    ),
                                  )
                                ],
                                leading: Icon(Icons.translate),
                              ),
                              (widget.content[i].ref.isNotEmpty)
                                  ? Divider()
                                  : Container(),
                              (widget.content[i].ref.isNotEmpty)
                                  ? Padding(
                                      padding: EdgeInsets.all(20.sp),
                                      child: Text(
                                        widget.content[i].ref,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          width: 1.sw,
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ));
  }
}

List<IconData> image = [
  customIcon.MyFlutterApp.home,
  customIcon.MyFlutterApp.double_bed,
  customIcon.MyFlutterApp.ablution,
  customIcon.MyFlutterApp.fork,
  customIcon.MyFlutterApp.mosque,
  customIcon.MyFlutterApp.plane,
  customIcon.MyFlutterApp.pray,
  customIcon.MyFlutterApp.toilet,
  customIcon.MyFlutterApp.fashion,
  customIcon.MyFlutterApp.beads,
  customIcon.MyFlutterApp.day,
  customIcon.MyFlutterApp.pray,
  customIcon.MyFlutterApp.diet,
  customIcon.MyFlutterApp.book,
  customIcon.MyFlutterApp.heart,
  customIcon.MyFlutterApp.balance,
  customIcon.MyFlutterApp.handshake,
  customIcon.MyFlutterApp.prayer,
  customIcon.MyFlutterApp.shield,
  customIcon.MyFlutterApp.health,
  customIcon.MyFlutterApp.sad,
  customIcon.MyFlutterApp.rating,
  customIcon.MyFlutterApp.patience,
  customIcon.MyFlutterApp.family,
  customIcon.MyFlutterApp.debt,
];
