import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextView extends StatelessWidget {

  final String? headings;
  final String? text;
  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;
  final bool? isCapslock;
  final bool? isAutoSize;

  const TextView({super.key, this.headings, this.text, this.color = Colors.black, this.textAlign, this.fontSize, this.isCapslock = false, this.isAutoSize = false});

  @override
  Widget build(BuildContext context) {
    return isAutoSize! ?
    AutoSizeText(
      isCapslock! ? text!.toUpperCase() : text!,
      maxLines: 1,
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
    )
    :
    Text(
      isCapslock! ? text!.toUpperCase() : text!,
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