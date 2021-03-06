import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math show sin, pi, sqrt;
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
      appBar: AppBar(
        title: Text("Sibhah"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Flexible(
            child: Center(
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
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            HapticFeedback.heavyImpact();
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
                            decoration:
                                BoxDecoration(color: Colors.transparent),
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
                                              ? FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    "Start",
                                                    style: (TextStyle(
                                                        color:
                                                            Color(0xFF1E555C),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                  ),
                                                )
                                              : (variable == 100)
                                                  ? Icon(
                                                      Icons.repeat,
                                                      size: 80.sp,
                                                      color: Color(0xFF1E555C),
                                                    )
                                                  : Text(
                                                      variable.toString(),
                                                      style: (TextStyle(
                                                          color:
                                                              Color(0xFF1E555C),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                    ),
                                        ),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.white.withOpacity(0.3)),
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF1E555C)
                                              .withOpacity(0.2)),
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
          ),
        ],
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
    final Color _color = Color(0xFF1E555C).withOpacity(opacity);
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
