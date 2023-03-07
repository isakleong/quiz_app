

import 'package:get/get.dart';

class HistoryController extends GetxController with StateMixin {
  var errorMessage = "".obs;

  var quizTarget = 0.obs;
  var isPassed = false.obs;
  var currentQuestion = 0.obs;
}