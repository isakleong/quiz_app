import 'package:get/get.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashscreenController>(SplashscreenController(), permanent: true);
  }

}