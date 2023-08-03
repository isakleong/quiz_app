import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/widgets/textview.dart';

class NoInputRetur extends StatelessWidget {
  String image;
  String title;
  String description;
  bool? isHorizontal;
  NoInputRetur(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      this.isHorizontal});

  @override
  Widget build(BuildContext context) {
    return isHorizontal == true
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                image,
                width: 0.25 * Get.width,
                height: 0.2 * Get.width,
                fit: BoxFit.scaleDown,
              ),
              Container(
                width: 0.6 * Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextView(
                      text: title,
                      fontSize: 24,
                      headings: 'H4',
                    ),
                    TextView(
                      text: description,
                      fontSize: 16,
                    )
                  ],
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.04 * Get.height,
              ),
              Image.asset(
                image,
                width: 0.6 * Get.width,
                height: 0.35 * Get.width,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                height: 0.02 * Get.height,
              ),
              TextView(
                text: title,
                fontSize: 24,
                headings: 'H4',
              ),
              TextView(
                text: description,
                fontSize: 16,
              )
            ],
          );
  }
}
