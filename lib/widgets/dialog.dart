
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/widgets/textview.dart';

void appsDialog ({required String type, bool isDismmisible = false, required Widget title, String rightBtnMsg = '', String leftBtnMsg = '', String iconAsset = '', required bool animated, bool isCancel = false, VoidCallback? actionClick}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async{
        return isDismmisible;
      },
      child: AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              animated == true ?
              Lottie.asset(
                type == "app_error" ? 
                'assets/lottie/error.json'
                :
                type == "app_info" ? 
                'assets/lottie/info.json'
                :
                type == "quiz_inactive" ? 
                'assets/lottie/search_2.json'
                :
                iconAsset,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              )
              :
              Image.asset(
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
                height: 220
              ),
              const SizedBox(height: 30),
              title
            ],
          ),
        ),
        actions: <Widget>[
          isCancel == true ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreen),
                  ),
                  onPressed: actionClick,
                  child: TextView(headings: "H3", text: leftBtnMsg, fontSize: 16, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreen),
                  ),
                  onPressed: actionClick,
                  child: TextView(headings: "H3", text: rightBtnMsg, fontSize: 16, color: Colors.white),
                ),
              )
            ],
          )
          :
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: actionClick,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.darkGreen,
                  padding: const EdgeInsets.all(12),
                ),
                child: TextView(headings: "H3", text: leftBtnMsg, fontSize: 16, textAlign: TextAlign.center, color: Colors.white),
              )
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: isDismmisible,
  );
}