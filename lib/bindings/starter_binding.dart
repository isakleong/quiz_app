import 'package:get/get.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class StarterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<QuizController>(QuizController());
  }

}