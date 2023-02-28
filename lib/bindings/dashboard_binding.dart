import 'package:get/get.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController());
  }

}