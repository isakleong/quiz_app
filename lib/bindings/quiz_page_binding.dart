import 'package:get/get.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class QuizPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(() => QuizController());
  }

}