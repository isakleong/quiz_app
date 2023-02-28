import 'dart:convert';

import 'package:get/get.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/tools/service.dart';

class QuizController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  Quiz? quizModel;

  getData() async {
    try{
      isLoading(true);
      isError(false);
      try {
        final result = await ApiClient().getData("/config?app=quiz");
        var data = jsonDecode(result.body.toString());
        quizModel =  Quiz.from(data);
        isLoading(false);
        isError(false);

        Get.offAndToNamed(RouteName.dashboard);
      } catch(e) {
        isLoading(false);
        isError(true);
        errorMessage(e.toString());
        // throw Exception(e);
      }
      return quizModel;
      
    }catch(e){
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
    }
  }
}