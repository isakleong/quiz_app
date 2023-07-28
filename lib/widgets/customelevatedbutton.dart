import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/widgets/textview.dart';

class CustomElevatedButton extends StatelessWidget {
  String text;
  var onTap;
  double width;
  double height;
  double radius;
  Color backgroundColor;
  Color textcolor;
  double elevation;
  Color bordercolor;
  String headings;
  CustomElevatedButton(
      this.text,
      this.onTap,
      this.width,
      this.height,
      this.radius,
      this.backgroundColor,
      this.textcolor,
      this.elevation,
      this.bordercolor,
      this.headings);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: bordercolor, width: 1),
          backgroundColor: backgroundColor,
          elevation: elevation,
          fixedSize: Size(width, height),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          padding: const EdgeInsets.all(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextView(
              text: text,
              color: textcolor,
              headings: headings,
              fontSize: 14,
            ),
          ],
        ));
  }
}
