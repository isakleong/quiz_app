import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/widgets/textview.dart';

class CustomElevatedButton extends StatelessWidget {
  String? text;
  var onTap;
  double? width;
  double? height;
  double? radius;
  Color? backgroundColor;
  Color? textcolor;
  double? elevation;
  Color? bordercolor;
  String? headings;
  Icon? icon;
  double? space;
  double? fonts;
  CustomElevatedButton(
      {super.key,
      this.text,
      this.onTap,
      this.width,
      this.height,
      this.radius,
      this.backgroundColor,
      this.textcolor,
      this.elevation,
      this.bordercolor,
      this.headings,
      this.icon,
      this.space,
      this.fonts});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              color: bordercolor == null ? Colors.white : bordercolor!,
              width: 1),
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(radius == null ? 0 : radius!)),
          padding: const EdgeInsets.all(10),
        ),
        child: icon == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextView(
                    text: text,
                    color: textcolor,
                    headings: headings ?? "H1",
                    fontSize: fonts ?? 14,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon!,
                  space != null
                      ? SizedBox(
                          width: space,
                        )
                      : Container(),
                  TextView(
                    text: text,
                    color: textcolor,
                    headings: headings ?? "H1",
                    fontSize: 14,
                  ),
                ],
              ));
  }
}
