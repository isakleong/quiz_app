import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Summary extends StatefulWidget {

  final int mode;

 const Summary({Key? key, required this.mode}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {

  @override
  Widget build(BuildContext context) {

    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFcaceff).withOpacity(1),
      body: Center(
        child: widget.mode == 1 ?
        Lottie.asset(
          'assets/lottie/firework.json',
          width: mediaWidth*0.8,
        )
        :
        Text(widget.mode.toString()),
      ),
    );

  }
}