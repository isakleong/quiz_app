import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../widgets/customelevatedbutton.dart';

class DialogConfirm extends StatelessWidget {
  String message;
  String title;
  DialogConfirm({super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.5,
      height: 0.4 * Get.height,
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.03,
                ),
                TextView(
                  text: title,
                  headings: 'H3',
                  fontSize: 17,
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Lottie.asset('assets/lottie/confirmquestion.json',
                    width: Get.width * 0.25),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                SizedBox(
                  width: Get.width * 0.4,
                  child: TextView(
                    text: message,
                    headings: 'H4',
                    textAlign: TextAlign.center,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0.02 * Get.height),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                      text: "BATAL",
                      onTap: () {
                        Get.back();
                      },
                      width: 0.18 * Get.width,
                      height: 0.045 * Get.height,
                      radius: 8,
                      backgroundColor: Colors.white,
                      textcolor: AppConfig.mainCyan,
                      elevation: 0,
                      bordercolor: AppConfig.mainCyan,
                      headings: 'H2'),
                  CustomElevatedButton(
                      text: "YA, SIMPAN",
                      onTap: () {
                        Get.back();
                      },
                      width: 0.18 * Get.width,
                      height: 0.045 * Get.height,
                      radius: 8,
                      backgroundColor: AppConfig.mainCyan,
                      textcolor: Colors.white,
                      elevation: 2,
                      bordercolor: AppConfig.mainCyan,
                      headings: 'H2')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
