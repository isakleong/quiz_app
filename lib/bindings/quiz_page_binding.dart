import 'package:get/get.dart';
import 'package:sfa_tools/controllers/quiz_controller.dart';

class QuizPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(() => QuizController());
  }

}