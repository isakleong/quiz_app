import 'package:get/get.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class QuizPageBinding implements Bindings {
  @override
  void dependencies() {
    // Get.reset();
    // Get.put<QuizController>( QuizController(), permanent: false);
    // Get.put<QuizController>( QuizController());
    Get.lazyPut<QuizController>(() => QuizController());
    // Get.create(() => QuizController(), permanent: true);
  }

}