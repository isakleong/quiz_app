import 'package:get/get.dart';
import 'package:quiz_app/controllers/splashscreen_controller.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => SplashscreenController());
    Get.put(() => SplashscreenController(), permanent: true);
  }

}