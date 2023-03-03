import 'package:get/get.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class StarterBinding implements Bindings {
  @override
  void dependencies() {
    // Get.reset();
    Get.put<QuizController>( QuizController(), permanent: true);
    // Get.lazyPut<QuizController>(() => QuizController(), fenix: true);
    // Get.create(() => QuizController(), permanent: true);
  }

}