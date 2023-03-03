import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/tools/service.dart';

class QuizController extends GetxController with StateMixin {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;

  var quizModel = <Quiz>[].obs;
  var quizTarget = 0.obs;
  var currentQuestion = 0.obs;

  @override
  void onInit() {
    super.onInit();

    var path = Directory.current.path;
    Hive
    ..init(path)
    ..registerAdapter(QuizAdapter());

    fetchQuizData();
  }

  nextQuestion() {
    currentQuestion++;
    updateIndex(currentQuestion.value);
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

  fetchQuizData() async {
    print("MASUK FETCH DATA");

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
      change(null, status: RxStatus.success());
      
    } catch(e) {
      print("masuk catch");
      isError(true);
      errorMessage.value = e.toString();
      // if done, change status to success
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }
}