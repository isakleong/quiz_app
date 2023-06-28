import 'package:get/get.dart';
import 'package:quiz_app/controllers/homepage_controller.dart';

class HomepageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomepageController>( HomepageController());
  }
}