
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/widgets/textview.dart';

void appsDialog ({required String type, bool isDismmisible = false, required Widget title, Widget? content, String rightBtnMsg = '', String leftBtnMsg = '', String iconAsset = '', required bool isAnimated, bool isCancel = false, VoidCallback? leftActionClick, VoidCallback? rightActionClick}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async{
        return isDismmisible;
      },
      child: AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              isAnimated == true ?
              Lottie.asset(
                type == "app_error" ? 
                'assets/lottie/error.json'
                :
                type == "app_info" ? 
                'assets/lottie/info.json'
                :
                type == "quiz_inactive" ? 
                'assets/lottie/quiz-search.json'
                :
                type == "quiz_warning" ? 
                'assets/lottie/quiz-warning.json'
                :
                type == "quiz_confirm" ? 
                'assets/lottie/quiz-confirm.json'
                :
                type == "quiz_passed" ? 
                'assets/lottie/quiz-passed.json' 
                :
                type == "quiz_failed" ? 
                'assets/lottie/quiz-failed.json' 
                :
                type == "quiz_retry" ? 
                'assets/lottie/quiz-retry.json' 
                :
                iconAsset,
                width: 230,
                height: 230,
                fit: BoxFit.contain,
              )
              :
              type == "confirm_dialog" ?
              Container(
                child: title
              )
              :
              Image.asset(
                iconAsset,
                width: 220,
                height: 220
              ),
              const SizedBox(height: 30),
              type == "confirm_dialog" ?
              content!
              :
              title
            ],
          ),
        ),
        actions: <Widget>[
          isCancel == true ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreen),
                    ),
                    onPressed: leftActionClick,
                    child: TextView(headings: "H3", text: leftBtnMsg, color: Colors.white, isCapslock: true),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreen),
                    ),
                    onPressed: rightActionClick,
                    child: TextView(headings: "H3", text: rightBtnMsg, color: Colors.white, isCapslock: true),
                  ),
                ),
              )
            ],
          )
          :
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: leftActionClick,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.darkGreen,
                  padding: const EdgeInsets.all(12),
                ),
                child: TextView(headings: "H3", text: leftBtnMsg, textAlign: TextAlign.center, color: Colors.white, isCapslock: true),
              )
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: isDismmisible,
  );
}