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
import 'package:sfa_tools/models/quiz_config.dart';
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
  var quizConfigModel = <QuizConfig>[].obs;
  // var quizTarget = 0.obs;
  var isPassed = false.obs;
  var currentQuestion = 0.obs;
  List<int> showFalse = [];
  String allInvalidQuestions = '';

  var tes = "".obs;

  @override
  void onInit() async {
    super.onInit();

    repeatKe();

    final salesIdParams = Get.find<SplashscreenController>().salesIdParams;

    Box retrySubmitQuizBox = await Hive.openBox<ServiceBox>(AppConfig.boxSubmitQuiz);
    var isRetrySubmit = retrySubmitQuizBox.get(AppConfig.keyStatusBoxSubmitQuiz);
    if(isRetrySubmit != null && isRetrySubmit.value == "true") {
      change(null, status: RxStatus.empty());
    } else {
      if(Get.currentRoute == RouteName.starter) {
        getQuizConfig(salesIdParams.value);
      } else {
        quizConfigModel.clear();
        var quizConfigModelBox = await Hive.openBox<QuizConfig>('quizConfigBox');
        quizConfigModel.addAll(quizConfigModelBox.values); 

        // var quizConfigBox = await Hive.openBox('quizConfigBox');
        // quizTarget.value = int.parse(quizConfigModelBox.get(0)!.value);

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
    quizConfigModel.clear();
    change(null, status: RxStatus.loading());

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if (isConnected) {
      try {
        final encryptedParam = await Utils.encryptData(params);
        final encodeParam = Uri.encodeComponent(encryptedParam);

        var result = await ApiClient().getData(urlAPI, "/quiz/configdev?sales_id=$encodeParam");
        bool isValid = Utils.validateData(result.toString());

        if (isValid) {
          var data = jsonDecode(result.toString());

          if (data.length > 0) {
            List<QuizConfig> tempQuizConfigList = [];
            data.map((item) {
              tempQuizConfigList.add(QuizConfig.from(item));
            }).toList();
            
            var quizConfigBox = await Hive.openBox<QuizConfig>('quizConfigBox');

            if(tempQuizConfigList.length < 2) { // 0: target, 1: tolerance
              errorMessage.value = Message.errorQuizConfig;
              change(null, status: RxStatus.error(errorMessage.value));
            } else {
              if(quizConfigBox.values.length != tempQuizConfigList.length) {
                await quizConfigBox.clear();
                await quizConfigBox.addAll(tempQuizConfigList);
              } else {
                if(quizConfigBox.values.isNotEmpty) { // sudah ada data di hive, 
                  if (quizConfigBox.get(0)?.value != tempQuizConfigList[0].value || quizConfigBox.get(1)?.value != tempQuizConfigList[1].value) {
                    await quizConfigBox.clear(); // Selalu kosongkan dulu sebelum insert yang baru agar tidak isi hive tdk double
                    await quizConfigBox.addAll(tempQuizConfigList);
                  }
                } else {
                  await quizConfigBox.clear();
                  await quizConfigBox.addAll(tempQuizConfigList);    
                }
              }
            }

            if(!status.isError) {
              getQuizData(params); 
            }
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

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if(isConnected) {
      try {
        final encryptedSalesID = await Utils.encryptData(params);
        final encodeSalesID = Uri.encodeComponent(encryptedSalesID);

        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);

        final encryptedDate = await Utils.encryptData(formattedDate);
        final encodeDate = Uri.encodeComponent(encryptedDate);

        var result = await ApiClient().getData(urlAPI, "/quiz?sales_id=$encodeSalesID&date=$encodeDate");
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
        
        // Sudah tidak dipakai karena target kuis langsung ambil dari hive quizConfigModel
        // var quizConfigBox = await Hive.openBox('quizConfigBox');
        // quizTarget.value = quizConfigBox.get("target");
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
          text: TextSpan(
            text: 'Mohon maaf, Anda dinyatakan ',
            style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
            children: <TextSpan>[
              const TextSpan(text: 'BELUM LULUS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
              const TextSpan(text: ' kuis periode ini, silakan mencoba mengerjakan ulang kuisnya\n\n', style: TextStyle(fontFamily: "Poppins")),
              allInvalidQuestions != '' ?
              TextSpan(text: 'Pertanyaan yang belum dijawab dengan benar :\n$allInvalidQuestions', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"))
              : const TextSpan(),

            ],
          ),
        ),
      ),
      isAnimated: true,
      leftBtnMsg: "Ok",
      leftActionClick: () {
        if (allInvalidQuestions != '') {
          Get.back();
          Get.back();
        } else {
          Get.back();
          Get.back();
        }
      },
    );
  }

  scoreCalculation() async {
    int score = 0;
    showFalse = [];
    var tolerance = quizConfigModel[1].value.split("|");
    int toleranceRepeat = int.parse(tolerance[0]);
    int toleranceWrong = int.parse(tolerance[1]);
    int cntRepeat = 0;

    // Counter berapa kali gagal, untuk keperluan di tolerance
    Box cntRepeatBox = await Hive.openBox('counterRepeat');
    if (cntRepeatBox.get('counterRepeat') != null) {
      cntRepeat = cntRepeatBox.get('counterRepeat');
    } else {
      cntRepeatBox.put('counterRepeat',0);
    }

    for (int i = 0; i < quizModel.length; i++) {
      if (quizModel[i].answerSelected == quizModel[i].correctAnswerIndex) {
        score++;
      } else {
        showFalse.add(i+1);
      }
    }

    var target = ((int.parse(quizConfigModel[0].value) / 100) * quizModel.length);
    var arrTarget = target.toString().split(".");

    if (score >= int.parse(arrTarget[0])) {
      isPassed(true);
    } else {
      cntRepeatBox.put('counterRepeat',cntRepeat+1);
      isPassed(false);
      if (cntRepeatBox.get('counterRepeat') >= toleranceRepeat && showFalse.length <= toleranceWrong) {
        allInvalidQuestions = showFalse.join(", ");
      }
    }
  }

  repeatKe() async {
    int cntRepeat = 0;
    Box cntRepeatBox = await Hive.openBox('counterRepeat');
    if (cntRepeatBox.get('counterRepeat') != null) {
      cntRepeat = cntRepeatBox.get('counterRepeat');
    } else {
      cntRepeatBox.put('counterRepeat',0);
      cntRepeat = cntRepeatBox.get('counterRepeat');
    }
    tes.value = cntRepeat.toString();
    return tes.value;
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
        if (await Backgroundservicecontroller().isSameSalesid()) {
          await Backgroundservicecontroller().writeText("3;${salesId};${DateTime.now()};${_filequiz.split(";")[3]}");
        } else {
          await Backgroundservicecontroller().writeText("3;${salesId};${DateTime.now()};${DateTime.now()}");
        }
      } else {
        if (await Backgroundservicecontroller().isSameSalesid()) {
          await Backgroundservicecontroller().writeText("2;${salesId};${DateTime.now()};${_filequiz.split(";")[3]}");
        } else {
          await Backgroundservicecontroller().writeText("2;${salesId};${DateTime.now()};${DateTime.now()}");
        }
      }

      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if (isConnected) {
        var bodyData = jsonEncode(params);
        var resultSubmit = await ApiClient().postData(
          urlAPI,
          '/quiz/submit',
          Utils.encryptData(bodyData),
          Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json"
            }
          )
        );

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
