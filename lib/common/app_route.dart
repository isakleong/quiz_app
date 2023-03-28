import 'package:get/get.dart';
import 'package:quiz_app/bindings/history_page_binding.dart';
import 'package:quiz_app/bindings/quiz_page_binding.dart';
import 'package:quiz_app/bindings/starter_page_binding.dart';
import 'package:quiz_app/bindings/splashscreen_binding.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/screens/quiz_countdown.dart';
import 'package:quiz_app/screens/quiz_dashboard.dart';
import 'package:quiz_app/screens/quiz_history.dart';
import 'package:quiz_app/screens/homepage.dart';
import 'package:quiz_app/screens/quiz.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/quiz_starter.dart';

class AppRoute {
  static final pages = [
    GetPage(
      name: RouteName.splashscreen,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
    ),
    GetPage(name: RouteName.quizDashboard, page: () => const QuizDashboard()),
    GetPage(name: RouteName.homepage, page: () => Homepage()),
    GetPage(name: RouteName.starter, page: () => StartQuiz(), binding: StarterPageBinding()),
    GetPage(name: RouteName.countdown, page: () => const CountdownPage()),
    GetPage(name: RouteName.quiz, page: () => QuizPage(), binding: QuizPageBinding()),
    GetPage(name: RouteName.history, page: () => HistoryPage(), binding: HistoryPageBinding()),
  ];
}