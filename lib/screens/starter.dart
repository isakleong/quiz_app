import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/common/configuration.dart';
import 'dart:math' as math;

import 'package:quiz_app/screens/countdown.dart';

class StartQuiz extends StatefulWidget {
  const StartQuiz({super.key});
  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.lightGreenColor,
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: const Center(
          child: CircularButton()
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  const CircularButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: ClipOval(
            child: Container(
              color: AppConfig.mainGreenColor,
              height: 250,
              width: 250,
            ),
          ),
        ),

        Center(
          child: Container(
            height: 230,
            width: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 10,
                style: BorderStyle.solid
              ),
            ),
            child: Material(
              color: AppConfig.mainGreenColor,
              shape: const CircleBorder(),
              child: InkWell(
                splashColor: AppConfig.lightGreenColor,
                customBorder: const CircleBorder(),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Countdown()));
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'MULAI',
                      style: TextStyle(color: Colors.white, fontSize: 30)
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Center(
        //   child: ClipOval(
        //     child: Container(
        //       color: const Color(0xFF7E89FE),
        //       height: 200,
        //       width: 200,
        //     ),
        //   ),
        // ),

        // Center(
        //   child: GestureDetector(
        //   onTap: () {},
        //   child: ClipOval(
        //     child: Container(
        //       height: 180,
        //       width: 180,
        //       decoration: BoxDecoration(
        //         color: const Color(0xFF7E89FE),
        //         border: Border.all(
        //           color: Colors.white,
        //           width: 10.0,
        //           style: BorderStyle.solid),
        //           boxShadow: const [
        //             BoxShadow(
        //                 color: Colors.grey,
        //                 offset: Offset(21.0, 10.0),
        //                 blurRadius: 20.0,
        //                 spreadRadius: 40.0)
        //           ],
        //           shape: BoxShape.circle),
        //           child: const Center(
        //             child: Text('START',
        //             style: TextStyle(color: Colors.white, fontSize: 20))),
        //     ),
        //   ),
        // )),
      ],
    );
  }
}