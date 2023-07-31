import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../common/app_config.dart';

class DialogDelete extends StatelessWidget {
  String nmProduct;
  var ontap;
  DialogDelete({super.key, required this.nmProduct, required this.ontap});

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
                  text: "Konfirmasi Hapus",
                  headings: 'H3',
                  fontSize: 17,
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Lottie.asset('assets/lottie/delete.json',
                    width: Get.width * 0.25),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  width: Get.width * 0.4,
                  child: TextView(
                    text: "Yakin ingin menghapus ${nmProduct}?",
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
                      text: "YA, HAPUS",
                      onTap: ontap,
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
