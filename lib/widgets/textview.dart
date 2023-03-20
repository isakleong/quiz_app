import 'package:flutter/material.dart';

class TextView extends StatelessWidget {

  final String? text;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final double? size;
  final bool? isCapslock;

  const TextView({super.key, this.text, this.color, this.fontWeight, this.fontStyle, this.textAlign, this.size, this.isCapslock});

  // String? text, family, fontFamilyUsed;
  // Color? color, labelColorUsed;
  // FontWeight? fontWeight, fontWeightUsed;
  // FontStyle fontStyle;
  // TextAlign align;
  // double? size, fontSizeUsed, lineHeight;
  // int maxLines;
  // String type;
  // bool? caps, italic;
  // TextDecoration? decoration;
  // TextOverflow? overflow;

  // TextView(this.text, this.type, {
  //   this.align = TextAlign.left,
  //   this.color,
  //   this.size,
  //   this.caps = false,
  //   this.fontStyle = FontStyle.normal,
  //   this.family,
  //   this.lineHeight = 1.2,
  //   this.maxLines = 9999,
  //   this.decoration,
  //   this.fontWeight,
  // });

  

  

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: this.labelColorUsed,
        fontFamily: this.fontFamilyUsed,
        fontWeight: this.fontWeightUsed,
        fontSize: this.fontSizeUsed,
        height: this.lineHeight,
        fontStyle: this.fontStyle,
        decoration: this.decoration,
        decorationThickness: 2,
        letterSpacing: space
      ),
      textAlign: this.align,
      maxLines: this.maxLines,
    );
  }
}