import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/tools/service.dart';

class QuizController extends GetxController with StateMixin {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  // late List<Quiz> quizModel = [];
  var quizModel = <Quiz>[].obs;
  var currentQuestion = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  increment() {
    currentQuestion++;
    updateIndex(currentQuestion.value);
  }

  decrement() {
    currentQuestion--;
  }

  chooseQuestion(int index) {
    quizModel[currentQuestion.value].answerSelected = index;
  }

  updateIndex(int index) {
    currentQuestion.value = index;
  }

  fetchData() async {
    // make status to loading
    change(null, status: RxStatus.loading());

    final result = await ApiClient().getData("/quiz?sales_id=00AC1A0103&date=2023-02-24");
    var data = jsonDecode(result.toString());
    data.map((item) {
      quizModel.add(Quiz.from(item));
    }).toList();

    for(int i=0; i<quizModel.length; i++) {
      quizModel[i].answerList.shuffle();
    }

    // print(quizModel.length.toString());
    // print(quizModel[0].questionID);
    // print(quizModel[0].question);
    // print(quizModel[0].category);
    // print(quizModel[0].answerList[0]);
    // print(quizModel[0].answerList[1]);
    // print(quizModel[0].answerList[2]);
    // print(quizModel[0].answerList[3]);
    // print(quizModel[0].correctAnswerList[0]);
    // print(quizModel[0].correctAnswerList[1]);
    // print(quizModel[0].correctAnswerList[2]);
    // print(quizModel[0].correctAnswerList[3]);

    // if done, change status to success
    change(null, status: RxStatus.success());
  }
}