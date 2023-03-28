import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'dart:math' as math;

import 'package:quiz_app/widgets/textview.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key});

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}


class _CountdownPageState extends State<CountdownPage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((AnimationStatus status){
        if (status == AnimationStatus.dismissed) {
          Get.offAndToNamed(RouteName.quiz);
        }
    });
    controller.reverse(from: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String get timerCountdown {
    Duration duration = controller.duration! * controller.value;
    return (duration.inSeconds % 60).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.mainGreen,
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const TextView(headings: "H2", text: "Selamat mengerjakan!", fontSize: 30, color: Colors.white),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child:
                                    AnimatedBuilder(
                                      animation: controller,
                                      builder:(BuildContext context, Widget? child) {
                                        return CustomPaint(
                                          painter: CustomTimerPainter(
                                            animation: controller,
                                            backgroundColor: AppConfig.mainGreen,
                                            color: Colors.white,
                                          )
                                        );
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        AnimatedBuilder(
                                          animation: controller,
                                          builder: (BuildContext context, Widget? child) {
                                            return TextView(headings: "H2", text: timerCountdown, fontSize: 100, color: Colors.white);
                                          }
                                        ),
                                      ],
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
                }),
            ),
          )
        ),
      ),
    );
  }
  
  Future<bool> onWillPop() async {
    return true;
  }
}


class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}