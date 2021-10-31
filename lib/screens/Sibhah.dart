import 'package:application_1/src/customWidgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';

class Sibhah extends StatefulWidget {
  const Sibhah({
    Key? key,
  }) : super(key: key);
  @override
  _SibhahState createState() => _SibhahState();
}

class _SibhahState extends State<Sibhah> with TickerProviderStateMixin {
  var _controller;
  String text = "";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int variable = 0, variable_2 = 0;
  List<String> quotes = [
    "صدق ٱللَّٰهُ العظيم",
    "ٱللَّٰهُ أَكْبَرُ",
    "ٱلْحَمْدُ لِلَّٰهِ",
    "سُبْحَانَ ٱللَّٰهِ"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      body: Center(
        child: CustomPaint(
          painter: CirclePainter(
            _controller,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100.sp,
              ),
              Text(
                (variable == 0)
                    ? "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ"
                    : quotes[variable_2],
                style: TextStyle(
                  fontSize: 90.sp,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              Spacer(),
              Container(
                width: 800.w,
                height: 800.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1000.w),
                      topRight: Radius.circular(1000.w)),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      SystemSound.play(SystemSoundType.click);
                      setState(() {
                        if (variable == 100) {
                          variable = 0;
                        } else if (variable == 99) {
                          variable_2 = 0;
                          variable++;
                        } else {
                          variable++;
                          variable_2++;
                        }

                        if (variable_2 > 3) variable_2 = 1;
                      });
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: ScaleTransition(
                          scale: Tween(begin: 0.95, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: CurveWave(),
                            ),
                          ),
                          child: Column(
                            children: [
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(15.sp),
                                height: 200.sp,
                                width: 200.sp,
                                child: Container(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Center(
                                    child: (variable == 0)
                                        ? Text(
                                            "Start",
                                            style: (TextStyle(
                                                color: Colors.green[900],
                                                fontWeight: FontWeight.bold)),
                                          )
                                        : (variable == 100)
                                            ? Icon(
                                                Icons.repeat,
                                                size: 80.sp,
                                                color: Colors.green[900],
                                              )
                                            : Text(
                                                variable.toString(),
                                                style: (TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight:
                                                        FontWeight.bold)),
                                              ),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green),
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green[800]),
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation,
  ) : super(repaint: _animation);

  final Animation<double> _animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = Colors.green.withOpacity(opacity);
    final double size = 1.sw;
    final double area = size * 1.sh;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.bottomCenter, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class CurveWave extends Curve {
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
