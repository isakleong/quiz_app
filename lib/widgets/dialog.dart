
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';

void appsDialog ({required String type, required String title, String rightBtnMsg = '', String leftBtnMsg = '', String iconAsset = '', required bool animated, void actionClick}) {
  Get.dialog(
    AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            animated == true ?
            Lottie.asset(
              type == "quiz_confirm" ?
              'assets/images/quiz-confirm.png'
              :
              type == "quiz_warning" ? 
              'assets/images/quiz-warning.png'
              :
              type == "quiz_success" ? 
              'assets/images/quiz-success.png'
              :
              type == "quiz_failed" ? 
              'assets/images/quiz-failed.png'
              :
              iconAsset,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            )
            :
            Image.asset(iconAsset, width: 220, height: 220),
            const SizedBox(height: 30),
            Text(title, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center)
          ],
        ),
      ),
      actions: <Widget>[
        rightBtnMsg == "" ?
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
            ),
            child: const Text('Ok', style: TextStyle(fontSize: 16, color: Colors.white)),
            onPressed: () => actionClick,
          ),
        )
        :
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
            ),
            child: Text(rightBtnMsg, style: const TextStyle(fontSize: 16, color: Colors.white)),
            onPressed: () => actionClick,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
            ),
            child: Text(leftBtnMsg, style: const TextStyle(fontSize: 16, color: Colors.white)),
            onPressed: () => actionClick,
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}