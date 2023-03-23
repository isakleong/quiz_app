import 'package:flutter/material.dart';

class TextView extends StatelessWidget {

  final String? headings;
  final String? text;
  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;
  final bool? capslock;

  const TextView({super.key, this.headings, this.text, this.color, this.textAlign, this.fontSize, this.capslock = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      capslock! ? text!.toUpperCase() : text!,
      style: TextStyle(
        color: color,
        fontWeight: headings == "H1" ?
        FontWeight.w700
        :
        headings == "H2" ?
        FontWeight.w600
        :
        headings == "H3" ?
        FontWeight.w500
        :
        headings == "H4" ?
        FontWeight.w400
        :
        FontWeight.w300,
        fontFamily: 'Poppins',
        fontSize: fontSize,
      ),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}