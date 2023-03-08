import 'package:get/get.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class StarterPageBinding implements Bindings {
  @override
  void dependencies() {
    // Get.reset();
    Get.put<QuizController>( QuizController(), permanent: true);
    // Get.put<QuizController>( QuizController());
    // Get.lazyPut<QuizController>(() => QuizController(), fenix: true);
    // Get.create(() => QuizController(), permanent: true);
  }

}