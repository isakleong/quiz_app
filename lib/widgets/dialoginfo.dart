import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../common/app_config.dart';
import 'customelevatedbutton.dart';
import 'textview.dart';

class DialogInfo extends StatelessWidget {
  String judul;
  String desc;
  String lottieasset;
  // ignore: prefer_typing_uninitialized_variables
  var ontap;
  DialogInfo({super.key, required this.judul, required this.ontap, required this.desc, required this.lottieasset});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.5,
      height: 0.4 * height,
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                TextView(
                  text: judul,
                  headings: 'H3',
                  fontSize: 17,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Lottie.asset('assets/lottie/$lottieasset', width: width * 0.25),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.4,
                  child: TextView(
                    text: desc,
                    headings: 'H4',
                    textAlign: TextAlign.center,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0.04 * height),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                      text: "Oke",
                      onTap: ontap,
                      width: 0.18 * width,
                      height: 0.045 * height,
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