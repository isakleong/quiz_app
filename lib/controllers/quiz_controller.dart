// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/common/route_config.dart';
import 'package:sfa_tools/controllers/background_service_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/quiz.dart';
import 'package:sfa_tools/models/servicebox.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/dialog.dart';
import 'package:sfa_tools/widgets/textview.dart';

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

    Box retrySubmitQuizBox = await Hive.openBox<ServiceBox>(AppConfig.boxSubmitQuiz);
    var isRetrySubmit = retrySubmitQuizBox.get(AppConfig.keyStatusBoxSubmitQuiz);
    if(isRetrySubmit != null && isRetrySubmit.value == "true") {
      change(null, status: RxStatus.empty());
    } else {
      if(Get.currentRoute == RouteName.starter) {
        getQuizConfig(salesIdParams.value);
      } else {
        var quizConfigBox = await Hive.openBox('quizConfigBox');
        quizTarget.value = quizConfigBox.get("target");

        quizModel.clear();
        var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
        quizModel.addAll(quizModelBox.values);

        change(null, status: RxStatus.success());
      }
    }
    retrySubmitQuizBox.close();

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
    for (int i = 0; i < quizModelBox.length; i++) {
      Quiz? quiz = quizModelBox.getAt(i);
      if (quiz != null) {
        quiz.answerSelected = -1;
        quizModelBox.putAt(i, quiz);
      }
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
    if (isConnected) {
      try {
        var result = await ApiClient().getData("/quiz/config?sales_id=$params");
        bool isValid = Utils.validateData(result.toString());

        if (isValid) {
          var data = jsonDecode(result.toString());
          if (data.length > 0) {
            quizTarget.value = int.parse(data[0]["Value"].toString());
            var quizConfigBox = await Hive.openBox('quizConfigBox');
            if (quizConfigBox.get("target") != data[0]["Value"].toString()) {
              quizConfigBox.put("target", quizTarget.value);
            } else {
              quizTarget.value = quizConfigBox.get("target");
            }

            getQuizData(params);
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
        await getQuizData(params);
      } else {
        errorMessage(Message.errorConnection);
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  getQuizData(String params) async {
    quizModel.clear();

    bool isConnected = await ApiClient().checkConnection();
    if(isConnected) {
      try {
        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);

        var result = await ApiClient().getData("/quiz?sales_id=$params&date=$formattedDate");
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

  openErrorSubmitDialog(String message) {
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
        Get.back();
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
              const TextView(
                  headings: "H3",
                  text: Message.submittingQuiz,
                  fontSize: 16,
                  color: Colors.black),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  openPassQuizDialog() {
    appsDialog(
      type: "quiz_passed",
      title: Padding(
        padding: const EdgeInsets.all(10),
        child:  RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: 'Selamat! Anda dinyatakan ',
            style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
            children: <TextSpan>[
              TextSpan(text: 'LULUS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
              TextSpan(text: ' kuis periode ini', style: TextStyle(fontFamily: "Poppins")),
            ],
          ),
        ),
      ),
      isAnimated: true,
      leftBtnMsg: "Ok",
      leftActionClick: () {
        Get.back();
        Get.back();
      },
    );
  }

  openFailQuizDialog() {
    appsDialog(
      type: "quiz_failed",
      title: Padding(
        padding: const EdgeInsets.all(10),
        child:  RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: 'Mohon maaf, Anda dinyatakan ',
            style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
            children: <TextSpan>[
              TextSpan(text: 'BELUM LULUS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
              TextSpan(text: ' kuis periode ini, silakan mencoba mengerjakan ulang kuisnya', style: TextStyle(fontFamily: "Poppins")),
            ],
          ),
        ),
      ),
      isAnimated: true,
      leftBtnMsg: "Ok",
      leftActionClick: () {
        Get.back();
        Get.back();
      },
    );
  }

  scoreCalculation() {
    int score = 0;
    for (int i = 0; i < quizModel.length; i++) {
      if (quizModel[i].answerSelected == quizModel[i].correctAnswerIndex) {
        score++;
      }
    }

    var target = ((quizTarget.value / 100) * quizModel.length);
    var arrTarget = target.toString().split(".");

    if (score >= int.parse(arrTarget[0])) {
      isPassed(true);
    } else {
      isPassed(false);
    }
  }

  submitQuiz() async {
    try {
      openSubmitDialog();
      await postQuizData();
    } catch(e) {
      isError(true);
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

  postQuizData() async {
    try {
      final salesIdParams = Get.find<SplashscreenController>().salesIdParams;
      String salesId = salesIdParams.value;
      
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd H:m:s');
      String formattedDate = formatter.format(now);

      await scoreCalculation();

      int passed = 0;
      if (isPassed.value == true) {
        passed = 1;
      } else {
        passed = 0;
      }

      var params =  {
        'sales_id': salesId,
        'quiz_id': quizModel[0].quizID,
        'date': formattedDate,
        'passed': passed,
        'model': quizModel
      };

      //update txt after submit quiz (offline data handler), to keep notification running realtime
      String _filequiz = await Backgroundservicecontroller().readFileQuiz();
      if(passed == 1) {
        await Backgroundservicecontroller().writeText("3;${salesId};${_filequiz.split(";")[2]};${DateTime.now()}");
      } else {
        await Backgroundservicecontroller().writeText("2;${salesId};${_filequiz.split(";")[2]};${DateTime.now()}");
      }

      bool isConnected = await ApiClient().checkConnection();
      if (isConnected) {
        var bodyData = jsonEncode(params);
        var resultSubmit = await ApiClient().postData(
            '/quiz/submit',
            bodyData,
            Options(
                headers: {HttpHeaders.contentTypeHeader: "application/json"}));

        if(resultSubmit == "success") {
          Box retrySubmitQuizBox = await Hive.openBox<ServiceBox>(AppConfig.boxSubmitQuiz);
          retrySubmitQuizBox.put(AppConfig.keyStatusBoxSubmitQuiz, ServiceBox(value: "false"));

          //not used anymore (moved to top -- offline data handler)
          // var info = await Backgroundservicecontroller().getLatestStatusQuiz(salesId); 
          // if(info != "err"){
          //   String _filequiz = await Backgroundservicecontroller().readFileQuiz();
          //   await Backgroundservicecontroller().writeText("${info};${_filequiz.split(";")[1]};${salesId};${DateTime.now()}");
          // } else {
          //   await Backgroundservicecontroller().accessBox("create", "retryApi", "1");
          // }

          Get.back();
          if(isPassed.value) {
            isReset(!(isReset.value));
            openPassQuizDialog();
          } else {
            isRestart(!(isRestart.value));
            openFailQuizDialog();
          }
        } else {
          Get.back();
          openErrorSubmitDialog(resultSubmit);
        }
      } else {
        Box retrySubmitQuizBox = await Hive.openBox<ServiceBox>(AppConfig.boxSubmitQuiz);
        await retrySubmitQuizBox.put(AppConfig.keyStatusBoxSubmitQuiz, ServiceBox(value: "true"));
        await retrySubmitQuizBox.put(AppConfig.keyDataBoxSubmitQuiz,ServiceBox(value: jsonEncode(params)));
        retrySubmitQuizBox.close();
        
        Get.back();
        if(isPassed.value) {
          isReset(!(isReset.value));
        } else {
          isRestart(!(isRestart.value));
        }
        openRetrySubmitDialog();
      }
    } catch (e) {
      Get.back();
      openErrorSubmitDialog(e.toString());
    }
  }
}
