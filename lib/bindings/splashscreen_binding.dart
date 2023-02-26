import 'package:get/get.dart';
import 'package:quiz_app/controllers/config_controller.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConfigController());
  }

}