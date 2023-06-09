// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/message_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/background_service_controller.dart';
import 'package:quiz_app/controllers/splashscreen_controller.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/models/servicebox.dart';
import 'package:quiz_app/tools/service.dart';
import 'package:quiz_app/tools/utils.dart';
import 'package:quiz_app/widgets/dialog.dart';
import 'package:quiz_app/widgets/textview.dart';

class QuizController extends GetxController with StateMixin {
  var isError = false.obs;
  
  var isReset = false.obs;
  var isRestart = false.obs;
  var isRetryFetch = false.obs;


  var errorMessage = "".obs;

  var quizModel = <Quiz>[].obs;
  var quizTarget = 0.obs;
  var isPassed = false.obs;
  var currentQuestion = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    final salesIdParams = Get.find<SplashscreenController>().salesIdParams;

    var retrySubmitQuizBox = await Hive.openBox('retrySubmitQuizBox');
    var isRetrySubmit = retrySubmitQuizBox.get("retryStatus");
    if(isRetrySubmit == true) {
      change(null, status: RxStatus.empty());
      
    } else {
      getQuizConfig(salesIdParams.value);
    }

    ever(isRestart, (callback) {
      restartQuiz();
    });

    ever(isReset, (callback) {
      resetQuiz();
    });

    ever(isRetryFetch, (callback) {
      getQuizConfig(salesIdParams.value);
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

  restartQuiz() async {
    resetQuestion();

    var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
    for(int i = 0; i<quizModelBox.length; i++) {
      quizModelBox.getAt(i)?.answerSelected = -1;
    }
  }

  resetQuiz() async {
    resetQuestion();

    var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
    await quizModelBox.deleteFromDisk();
  }

  getQuizConfig(String params) async {
    change(null, status: RxStatus.loading());
    
    bool isConnected = await ApiClient().checkConnection();
    if(isConnected) {
      try {
        var result = await ApiClient().getData("/quiz/config?sales_id=$params");
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
            errorMessage.value = Message.errorQuizConfig;
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
    } else {
      //check if draft is exist or not
      var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
      if(quizModelBox.length > 0) {
        await getQuizData();
      } else {
        errorMessage(Message.errorConnection);
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  getQuizData() async {
    quizModel.clear();

    bool isConnected = await ApiClient().checkConnection();
    if(isConnected) {
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
    } else {
      //check if draft is exist or not
      var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
      if(quizModelBox.length > 0) {
        var quizConfigBox = await Hive.openBox('quizConfigBox');
        quizTarget.value = quizConfigBox.get("target");
        quizModel.addAll(quizModelBox.values);

        change(null, status: RxStatus.success());
      } else {
        errorMessage(Message.errorConnection);
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  openEmptyDataDialog() {
    appsDialog(
      type: "quiz_inactive",
      title: const TextView(headings: "H3", text: Message.errorActiveQuiz, fontSize: 16, color: Colors.black),
      isAnimated: true,
      leftBtnMsg: "Ok",
      leftActionClick: () {
        Get.back();
        Get.back();
      }
    );
  }

  operErrorSubmitDialog(String message) {
    appsDialog(
      type: "app_error",
      title: TextView(headings: "H3", text: message, fontSize: 16, color: Colors.black),
      isAnimated: true,
      leftBtnMsg: "Ok",
      leftActionClick: () {
        Get.back();
      }
    );
  }

  openRetrySubmitDialog() {
    appsDialog(
      type: "quiz_retry",
      title: const TextView(headings: "H3", text: Message.retrySubmitQuiz, fontSize: 16, color: Colors.black),
      isAnimated: true,
      leftBtnMsg: "Ok",
      leftActionClick: () {
        Get.back();
        Get.offAndToNamed(RouteName.quizDashboard);
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
                'assets/lottie/quiz-submit.json',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const TextView(headings: "H3", text: Message.submittingQuiz, fontSize: 16, color: Colors.black),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  getSalesId() async {
      String sales_id = await Utils().readParameter();
      // return sales_id.split(';')[0];
      return '01AC1A0103';
  }

  scoreCalculation() {
    int score = 0;
    for(int i=0; i<quizModel.length; i++) {
      if(quizModel[i].answerSelected == quizModel[i].correctAnswerIndex) {
        score++;
      }
    }

    var target = ((quizTarget.value/100) * quizModel.length);
    var arrTarget = target.toString().split(".");

    if(score >= int.parse(arrTarget[0])) {
      isPassed(true);
    } else {
      isPassed(false);
    }
  }

  submitQuiz() async {
    try {
      openSubmitDialog();
      await postQuizData();
      // Get.back();
    } catch(e) {
      isError(true);
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

  postQuizData() async {
    try {
      String salesId = await getSalesId();
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd H:m:s');
      String formattedDate = formatter.format(now);

      await scoreCalculation();

      int passed = 0;
      if(isPassed.value == true) {
        passed = 1;
      } else {
        passed = 0;
      }

      var params = {};

      Box retrySubmitQuizBox = await Hive.openBox('retrySubmitQuizBox');
      var retrySubmit = retrySubmitQuizBox.get("retryStatus");
      if(retrySubmit == true) {
        var submitQuizBox = await Hive.openBox('submitQuizBox');
        params = submitQuizBox.get("bodyData");
      } else {
        params =  {
          'sales_id': salesId,
          'quiz_id': quizModel[0].quizID,
          'date': formattedDate,
          'passed': passed,
          'model': quizModel
        };
      }

      bool isConnected = await ApiClient().checkConnection();
      if(isConnected) {
        var bodyData = jsonEncode(params);
        var resultSubmit = await ApiClient().postData(
          '/quiz/submit',
          bodyData,
          Options(headers: {HttpHeaders.contentTypeHeader: "application/json"})
        );

        if(resultSubmit == "success"){
          var retrySubmitQuizBox = await Hive.openBox('retrySubmitQuizBox');
          retrySubmitQuizBox.put("retryStatus", false);

          var info = await Backgroundservicecontroller().getLatestStatusQuiz(salesId); 
          if(info != "err"){
            String _filequiz = await Backgroundservicecontroller().readFileQuiz();
            await Backgroundservicecontroller().writeText("${info};${_filequiz.split(";")[1]};${salesId};${DateTime.now()}");
          } else {
            await Backgroundservicecontroller().accessBox("create", "retryApi", "1");
          }
        } else {
          var submitQuizBox = await Hive.openBox('submitQuizBox');
          submitQuizBox.clear();
          submitQuizBox.put("bodyData", params);

          var retrySubmitQuizBox = await Hive.openBox('retrySubmitQuizBox');
          retrySubmitQuizBox.put("retryStatus", true);
          
          Get.back();
          openRetrySubmitDialog();
        }
      } else {
        var submitQuizBox = await Hive.openBox('submitQuizBox');
        submitQuizBox.clear();
        submitQuizBox.put("bodyData", params);

        var mybox = await Hive.openBox<ServiceBox>('submitQuizBox');
        mybox.put("bodyData",ServiceBox(value: params.toString()));

        var retrySubmitQuizBox = await Hive.openBox('retrySubmitQuizBox');
        retrySubmitQuizBox.put("retryStatus", true);

        Get.back();
        openRetrySubmitDialog();
      }
    } catch(e) {
      Get.back();
      operErrorSubmitDialog(e.toString());
    }
  }

}