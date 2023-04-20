
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/widgets/textview.dart';
import 'package:google_fonts/google_fonts.dart';

void appsDialog ({required String type, bool isDismmisible = false, required Widget title, String rightBtnMsg = '', String leftBtnMsg = '', String iconAsset = '', required bool isAnimated, bool isCancel = false, VoidCallback? leftActionClick, VoidCallback? rightActionClick}) {
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
                'assets/lottie/search_2.json'
                :
                type == "quiz_warning" ? 
                'assets/lottie/warning.json'
                :
                iconAsset,
                width: 230,
                height: 230,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreen),
                    ),
                    onPressed: leftActionClick,
                    child: TextView(headings: "H3", text: leftBtnMsg, fontSize: 16, color: Colors.white, isCapslock: true),
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
                    child: TextView(headings: "H3", text: rightBtnMsg, fontSize: 16, color: Colors.white, isCapslock: true),
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
                // child: TextView(headings: "H3", text: leftBtnMsg, fontSize: 16, textAlign: TextAlign.center, color: Colors.white, isCapslock: true),
                child: Text(leftBtnMsg.toUpperCase(), style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 16, color: Colors.white)
                ), textAlign: TextAlign.center,),
              )
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: isDismmisible,
  );
}