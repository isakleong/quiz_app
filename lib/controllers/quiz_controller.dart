import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/tools/service.dart';

class QuizController extends GetxController with StateMixin {
  var isLoading = true.obs;
  var isError = false.obs;
  var isReset = false.obs;

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
      Get.offNamed(RouteName.dashboard);
      print("AFTER WORKER");
      resetQuiz();
    });
  }

  nextQuestion() {
    currentQuestion++;
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

  retryQuiz() async {
    resetQuestion();

    for(int i=0; i<quizModel.length; i++) {
      quizModel[i].answerSelected = -1;
    }
    var quizBox = await Hive.openBox<Quiz>('quizBox');
    for(int i=0; i<quizBox.length; i++) {
      quizBox.putAt(i, quizModel[i]);
    }
  }

  resetQuiz() async {
    resetQuestion();

    var quizBox = await Hive.openBox<Quiz>('quizBox');
    await quizBox.deleteFromDisk();

    await fetchQuizData();
  }

  fetchQuizData() async {
    print("MASUK FETCH DATA");
    quizModel.clear();

    var quizBox = await Hive.openBox<Quiz>('quizBox');
    if(quizBox.length > 0) {
      change(null, status: RxStatus.loading());

      quizModel.addAll(quizBox.values);
      print("MASUK SINI");
      currentQuestion.value = 0;

      change(null, status: RxStatus.success());

    } else {
      // make status to loading
      change(null, status: RxStatus.loading());

      try {
        //fetch quiz config data
        var result = await ApiClient().getData("/quiz/config?sales_id=00AC1A0103");
        var data = jsonDecode(result.toString());
        quizTarget.value = int.parse(data[0]["Value"].toString());

        //fetch quiz data
        result = await ApiClient().getData("/quiz?sales_id=00AC1A0103&date=2023-02-24");
        data = jsonDecode(result.toString());
        data.map((item) {
          quizModel.add(Quiz.from(item));
        }).toList();

        for(int i=0; i<quizModel.length; i++) {
          quizModel[i].answerList.shuffle();
        }

        //stored quiz config data to hive
        var quizBox = await Hive.openBox<Quiz>('quizBox');
        for(int i=0; i<quizModel.length; i++) {
          await quizBox.add(quizModel[i]);
        }
        print(quizBox.getAt(0));

        // if done, change status to success
        // change(null, status: RxStatus.success());
        
      } catch(e) {
        print("masuk catch");
        isError(true);
        errorMessage.value = e.toString();
        // if done, change status to success
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  submitQuiz() async {
    // make status to loading
    change(null, status: RxStatus.loading());

    try {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd H:m:s');
      String formattedDate = formatter.format(now);

      int passed = 0;
      if(isPassed.value) {
        passed = 1;
      } else {
        passed = 0;
      }

      var params =  {
        'sales_id': '00AC1A0103',
        'quiz_id': 'Quiz-001',
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

      // if done, change status to success
      change(null, status: RxStatus.success());
      
    } catch(e) {
      print("masuk catch "+errorMessage.value.toString());
      isError(true);
      errorMessage.value = e.toString();
      // if done, change status to success
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

}