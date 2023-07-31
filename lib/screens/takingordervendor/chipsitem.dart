import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sfa_tools/widgets/textview.dart';

class ChipsItem extends StatelessWidget {
  String satuan;
  Color? color;
  double? fontSize;
  ChipsItem({super.key, required this.satuan, this.color, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color == null ? Color(0XFF0098a6) : color,
          borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8, top: 2, bottom: 2),
        child: TextView(
          text: satuan,
          headings: 'H3',
          color: Colors.white,
          fontSize: fontSize == null ? 14 : fontSize,
        ),
      ),
    );
  }
}
