import 'package:application_1/models/RandomVerse.dart';
import 'package:application_1/src/customWidgets/API.dart';
import 'package:application_1/src/customWidgets/appbar.dart';
import 'package:application_1/src/customWidgets/providerSettings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RecitationScreen extends StatefulWidget {
  const RecitationScreen({Key? key, required this.recitation})
      : super(key: key);
  final String recitation;
  @override
  _RecitationScreenState createState() => _RecitationScreenState();
}

class _RecitationScreenState extends State<RecitationScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  AudioPlayer audio = AudioPlayer();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
        length: 15,
        initialIndex: identifiers.indexOf(widget.recitation),
        vsync: this);
    tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    audio.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rec = Provider.of<RecitationProvider>(context);

    return Scaffold(
      appBar: customAppbar(context, false, "Recitation", false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                (tabController.index == nameEn.indexOf(nameEn.first))
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                        ))
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          tabController.animateTo(tabController.index - 1);
                        },
                      ),
                FutureBuilder(
                    future:
                        getVerse(identifiers[tabController.index], 2, audio),
                    builder: (context, AsyncSnapshot<RandomVerse?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return IconButton(
                          tooltip: "Try it out",
                          icon: Icon(
                            Icons.hearing_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            if (audio.state == PlayerState.PLAYING) {
                              setState(() {
                                audio.pause();
                              });
                            } else
                              setState(() {
                                audio.resume();
                              });
                          },
                        );
                      } else
                        return IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz_outlined));
                    }),
                (tabController.index == nameEn.indexOf(nameEn.last))
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          tabController.animateTo(tabController.index + 1);
                        },
                      ),
              ],
            ),
            title: Text(
              nameEn[tabController.index],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(nameAr[tabController.index]),
          ),
          Stack(children: [
            Container(
              width: 1.sw,
              height: 500.h,
              child: Stack(children: [
                TabBarView(
                    controller: tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/images/abdulbasit.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/abdullah-basfar.jpg",
                          alignment: Alignment(0.0, -0.5),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/soudaisi.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/shtari.jpg",
                          fit: BoxFit.cover,
                          alignment: Alignment(0.1, -0.3),
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/ajmi.jpg",
                          fit: BoxFit.cover,
                          alignment: Alignment(0.0, -0.2),
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/Mishary.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/hani.jpg",
                          fit: BoxFit.cover,
                          alignment: Alignment(0.0, -0.5),
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/mahmoudkhalil.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/Alhuzaify.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/akhdar.jpg",
                          alignment: Alignment(0.0, 0.2),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/maher.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/mnshawi.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/medayoub.jpg",
                          alignment: Alignment(0.0, -0.7),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/jibril.jpg",
                          alignment: Alignment(0.0, -0.8),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          "assets/images/saoudsharim.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ]),
              ]),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Center(
                    child: ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: 30,
                        width: 60,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]),
          Spacer(),
          InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              rec.recitation = identifiers[tabController.index];
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.all(30.sp),
              width: 300.w,
              height: 100.h,
              child: Center(child: Text("Save")),
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
          )
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
