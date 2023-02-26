import 'package:get/get.dart';
import 'package:quiz_app/bindings/splashscreen_binding.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/screens/dashboard.dart';
import 'package:quiz_app/screens/splashscreen.dart';

class AppRoute {
  static final pages = [
    GetPage(
      name: RouteName.home,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
    ),

    // GetPage(
    //   name: RouteName.home,
    //   page: () => SplashScreen(),
    //   binding: BindingsBuilder((){
    //     Get.lazyPut<ConfigController>(() => ConfigController());
    //   }),
    // ),
    GetPage(
      name: RouteName.dashboard,
      page: () => Dashboard(),
    ),
  ];
}