import 'package:get/get.dart';
import 'package:quiz_app/bindings/starter_binding.dart';
import 'package:quiz_app/bindings/splashscreen_binding.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/screens/countdown.dart';
import 'package:quiz_app/screens/dashboard.dart';
import 'package:quiz_app/screens/quiz.dart';
import 'package:quiz_app/screens/splashscreen.dart';
import 'package:quiz_app/screens/starter.dart';

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

    GetPage(name: RouteName.dashboard, page: () => Dashboard()),
    GetPage(name: RouteName.starter, page: () => StartQuiz(), binding: StarterBinding()),
    // GetPage(name: RouteName.starter, page: () => StartQuiz()),
    GetPage(name: RouteName.countdown, page: () => Countdown()),
    GetPage(name: RouteName.quiz, page: () => QuizPage()),
  ];
}