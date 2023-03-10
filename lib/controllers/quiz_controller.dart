import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/tools/service.dart';

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
    fetchQuizData();

    ever(isReset, (callback) {
      print("MASUK WORKER");
      Get.offAllNamed(RouteName.dashboard);
      print("AFTER WORKER");
      resetQuiz();
    });

    ever(isRetryFetch, (callback) {
      fetchQuizData();
    });
  }

  nextQuestion() {
    currentQuestion++;
    print("target "+quizTarget.value.toString());
    // updateIndex(currentQuestion.value);
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

  // retryQuiz() async {
  //   resetQuestion();

  //   for(int i=0; i<quizModel.length; i++) {
  //     quizModel[i].answerSelected = -1;
  //   }
  //   var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
  //   for(int i=0; i<quizModelBox.length; i++) {
  //     quizModelBox.putAt(i, quizModel[i]);
  //   }
  // }

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

  // resetQuiz() async {
  //   resetQuestion();

  //   var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
  //   await quizModelBox.deleteFromDisk();

  //   await fetchQuizData();
  // }

  //uncomment
  // fetchQuizData() async {
  //   print("MASUK FETCH DATA");
  //   quizModel.clear();

  //   change(null, status: RxStatus.loading());

  //   try {
  //     //fetch quiz config data
  //     var result = await ApiClient().getData("/quiz/config?sales_id=00AC1A0103");
  //     var data = jsonDecode(result.toString());
  //     quizTarget.value = int.parse(data[0]["Value"].toString());
  //     var quizConfigBox = await Hive.openBox('quizConfigBox');
  //     quizConfigBox.put("target", quizTarget.value);

  //     var now = DateTime.now();
  //     var formatter = DateFormat('yyyy-MM-dd');
  //     String formattedDate = formatter.format(now);
  //     //fetch quiz data
  //     result = await ApiClient().getData("/quiz?sales_id=00AC1A0103&date=$formattedDate");
  //     data = jsonDecode(result.toString());

  //     if(data.length > 0) {
  //       //check if draft data is exist
  //       var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
  //       if(quizModelBox.length > 0) {
  //         //check kuis yang belum dikerjakan sama sekali
  //         int cntValid = 0;
  //         for(int i=0; i<quizModelBox.length; i++) {
  //           if(quizModelBox.getAt(i)!.answerSelected >= 0) {
  //             cntValid++;
  //             break;
  //           }
  //         }

  //         if(cntValid > 0) {
  //           quizModelBox.clear(); //buggy

  //           quizModel.addAll(quizModelBox.values);
  //           print("MASUK SINI LESGOO");
  //           currentQuestion.value = 0;

  //           var quizConfigBox = await Hive.openBox('quizConfigBox');
  //           quizTarget.value = quizConfigBox.get("target");

  //         } else {
  //           data.map((item) {
  //             quizModel.add(Quiz.from(item));
  //           }).toList();

  //           // for(int i=0; i<quizModel.length; i++) {
  //           //   quizModel[i].answerList.shuffle();
  //           // }

  //           //stored quiz config data to hive
  //           var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
  //           for(int i=0; i<quizModel.length; i++) {
  //             await quizModelBox.add(quizModel[i]);
  //           }
  //         }

  //         change(null, status: RxStatus.success());

  //       } else {
  //         data.map((item) {
  //           quizModel.add(Quiz.from(item));
  //         }).toList();

  //         // for(int i=0; i<quizModel.length; i++) {
  //         //   quizModel[i].answerList.shuffle();
  //         // }

  //         //stored quiz config data to hive
  //         var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
  //         for(int i=0; i<quizModel.length; i++) {
  //           await quizModelBox.add(quizModel[i]);
  //         }

  //         change(null, status: RxStatus.success());
  //       }
  //     } else {
  //       openEmptyDataDialog();
  //     }
  //   } catch(e) {
  //     print("masuk catch");
  //     isError(true);
  //     errorMessage.value = e.toString();
  //     change(null, status: RxStatus.error(errorMessage.value));
  //   } 
  // }

  fetchQuizData() async {
    print("MASUK FETCH DATA");
    quizModel.clear();

    var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
    if(quizModelBox.length > 0) {
      change(null, status: RxStatus.loading());

      //check invalid draft (belum diisi sama sekali, maka harus load data baru)
      int cntValid = 0;
      for(int i=0; i<quizModelBox.length; i++) {
        if(quizModelBox.getAt(i)!.answerSelected >= 0) {
          cntValid++;
          break;
        }
      }

      if(cntValid > 0) {
        quizModel.addAll(quizModelBox.values);
        print("MASUK SINI LESGOO");
        currentQuestion.value = 0;

        var quizConfigBox = await Hive.openBox('quizConfigBox');
        quizTarget.value = quizConfigBox.get("target");

      } else {
        quizModelBox.clear(); //buggy
        
        try {
          //fetch quiz config data
          var result = await ApiClient().getData("/quiz/config?sales_id=00AC1A0103");
          var data = jsonDecode(result.toString());
          quizTarget.value = int.parse(data[0]["Value"].toString());
          var quizConfigBox = await Hive.openBox('quizConfigBox');
          quizConfigBox.put("target", quizTarget.value);

          var now = DateTime.now();
          var formatter = DateFormat('yyyy-MM-dd');
          String formattedDate = formatter.format(now);
          //fetch quiz data
          result = await ApiClient().getData("/quiz?sales_id=00AC1A0103&date=$formattedDate");
          data = jsonDecode(result.toString());

          if(data.length > 0) {
            data.map((item) {
              quizModel.add(Quiz.from(item));
            }).toList();

            //stored quiz config data to hive
            var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
            for(int i=0; i<quizModel.length; i++) {
              await quizModelBox.add(quizModel[i]);
            }
            print(quizModelBox.getAt(0));

            change(null, status: RxStatus.success());

          } else {
            openEmptyDataDialog();
          }
          
        } catch(e) {
          print("masuk catch");
          isError(true);
          errorMessage.value = e.toString();

          change(null, status: RxStatus.error(errorMessage.value));
        }
      }

      change(null, status: RxStatus.success());

    } else {
      change(null, status: RxStatus.loading());

      try {
        //fetch quiz config data
        var result = await ApiClient().getData("/quiz/config?sales_id=00AC1A0103");
        var data = jsonDecode(result.toString());
        quizTarget.value = int.parse(data[0]["Value"].toString());
        var quizConfigBox = await Hive.openBox('quizConfigBox');
        quizConfigBox.put("target", quizTarget.value);

        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);
        //fetch quiz data
        result = await ApiClient().getData("/quiz?sales_id=00AC1A0103&date=$formattedDate");
        data = jsonDecode(result.toString());

        if(data.length > 0) {
          data.map((item) {
            quizModel.add(Quiz.from(item));
          }).toList();

          //stored quiz config data to hive
          var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
          for(int i=0; i<quizModel.length; i++) {
            await quizModelBox.add(quizModel[i]);
          }
          print(quizModelBox.getAt(0));

          change(null, status: RxStatus.success());

        } else {
          openEmptyDataDialog();
        }
        
      } catch(e) {
        print("masuk catch");
        isError(true);
        errorMessage.value = e.toString();

        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  openEmptyDataDialog() {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/search_2.json',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const Text("Mohon maaf, tidak ada kuis yang aktif", style: TextStyle(fontSize: 16), textAlign: TextAlign.center)
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
              ),
              child: const Text('Ok', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Get.back();
                Get.offAllNamed(RouteName.dashboard);
              },
            ),
          ),
        ],
      ),
      barrierDismissible: false,
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
              const Text("Mohon tunggu, sedang proses mengumpulkan kuis", style: TextStyle(fontSize: 16), textAlign: TextAlign.center)
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
        'sales_id': '00AC1A0103',
        'quiz_id': quizModel[0].quizID,
        'date': formattedDate,
        'passed': passed,
        'model': quizModel
      };
      var bodyData = jsonEncode(params);

      var result = await ApiClient().postData(
        '/quiz/submit',
        bodyData,
        Options(headers: {HttpHeaders.contentTypeHeader: "application/json"})
      );

      closeSubmitDialog();
      
    } catch(e) {
      print("masuk catch "+errorMessage.value.toString());
      isError(true);
      errorMessage.value = e.toString();
      // if done, change status to success
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

}