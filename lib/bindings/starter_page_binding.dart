import 'package:get/get.dart';
import 'package:sfa_tools/controllers/quiz_controller.dart';

class StarterPageBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put<QuizController>(QuizController(), permanent: true);
    // Get.lazyPut<QuizController>(() => QuizController(), fenix: true);
    Get.lazyPut<QuizController>(() => QuizController());
  }

}