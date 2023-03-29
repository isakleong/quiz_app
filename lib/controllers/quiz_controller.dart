import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/tools/service.dart';
import 'package:quiz_app/tools/utils.dart';
import 'package:quiz_app/widgets/dialog.dart';
import 'package:quiz_app/widgets/textview.dart';

class QuizController extends GetxController with StateMixin {
  var isLoading = true.obs;
  var isError = false.obs;
  
  var isReset = false.obs;
  var isRetryFetch = false.obs;


  var errorMessage = "".obs;

  var quizModel = <Quiz>[].obs;
  var quizTarget = 0.obs;
  var isPassed = false.obs;
  var currentQuestion = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getQuizConfig();

    ever(isReset, (callback) {
      Get.offAllNamed(RouteName.quizDashboard);
      resetQuiz();
    });

    ever(isRetryFetch, (callback) {
      getQuizConfig();
    });
  }

  nextQuestion() {
    currentQuestion++;
  }

  previousQuestion() {
    currentQuestion--;
  }

  chooseQuestion(int index) {
    quizModel[currentQuestion.value].answerSelected = index;
  }

  updateIndex(int index) {
    currentQuestion.value = index;
  }

  resetQuestion() {
    currentQuestion.value = 0;
  }

  lulusQuiz() async {
    resetQuestion();

    var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
    await quizModelBox.deleteFromDisk();
  }

  resetQuiz() async {
    resetQuestion();

    var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
    await quizModelBox.deleteFromDisk();
  }

  getQuizConfig() async {
    change(null, status: RxStatus.loading());
    try {
      var result = await ApiClient().getData("/quiz/config?sales_id=01AC1A0103");
      bool isValid = Utils.validateData(result.toString());

      if(isValid) {
        var data = jsonDecode(result.toString());
        if(data.length > 0) {
          quizTarget.value = int.parse(data[0]["Value"].toString());
          var quizConfigBox = await Hive.openBox('quizConfigBox');
          if(quizConfigBox.get("target") != data[0]["Value"].toString()) {
            quizConfigBox.put("target", quizTarget.value);
          } else {
            quizTarget.value = quizConfigBox.get("target");
          }

          getQuizData();
        } else {
          errorMessage.value = "Mohon maaf, konfigurasi kuis tidak ditemukan,\nsilahkan menghubungi tim SFA.";
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        errorMessage.value = result.toString();
        change(null, status: RxStatus.error(errorMessage.value));
      }
    } catch (e) {
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

  getQuizData() async {
    quizModel.clear();

    try {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);

      var result = await ApiClient().getData("/quiz?sales_id=01AC1A0103&date=$formattedDate");
      bool isValid = Utils.validateData(result.toString());

      if(isValid) {
        var data = jsonDecode(result.toString());

        if(data.length > 0) {
          List<Quiz> tempQuizList = [];
          data.map((item) {
            tempQuizList.add(Quiz.from(item));
          }).toList();

          //check draft is exist or not
          var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
          if(quizModelBox.length > 0) {
            //check whether the draft is valid or not
            //the draft still valid
            if(quizModelBox.getAt(0)?.quizID == tempQuizList[0].quizID) {
              quizModel.addAll(quizModelBox.values);
            } else { //the draft was invalid
              quizModel.addAll(tempQuizList);

              await quizModelBox.clear();
              await quizModelBox.addAll(quizModel);
            }
          } else {
            quizModel.addAll(tempQuizList);

            await quizModelBox.clear();
            await quizModelBox.addAll(quizModel);
          }

          change(null, status: RxStatus.success());
        } else {
          var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
          await quizModelBox.clear();

          openEmptyDataDialog();
        }
      } else {
        errorMessage.value = result.toString();
        change(null, status: RxStatus.error(errorMessage.value));
      }
    } catch(e) {
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

  openEmptyDataDialog() {
    appsDialog(
      type: "quiz_inactive",
      title: const TextView(headings: "H3", text: "Mohon maaf, tidak ada kuis yang aktif untuk saat ini.", fontSize: 16, color: Colors.black),
      isAnimated: true,
      leftBtnMsg: "Ok",
      actionClick: () {
        Get.back();
        Get.offAllNamed(RouteName.quizDashboard);
      }
    );
  }

  openSubmitDialog() {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/submitting.json',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const TextView(headings: "H3", text: "Mohon tunggu, sedang proses mengumpulkan kuis.", fontSize: 16, color: Colors.black),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  closeSubmitDialog() {
    Get.back();
  }

  submitQuiz() async {
    try {
      openSubmitDialog();

      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd H:m:s');
      String formattedDate = formatter.format(now);

      int passed = 0;
      if(isPassed.value == true) {
        passed = 1;
      } else {
        passed = 0;
      }

      var params =  {
        'sales_id': '01AC1A0103',
        'quiz_id': quizModel[0].quizID,
        'date': formattedDate,
        'passed': passed,
        'model': quizModel
      };
      var bodyData = jsonEncode(params);

      await ApiClient().postData(
        '/quiz/submit',
        bodyData,
        Options(headers: {HttpHeaders.contentTypeHeader: "application/json"})
      );

      closeSubmitDialog();
      
    } catch(e) {
      isError(true);
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

}