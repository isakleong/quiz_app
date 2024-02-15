import 'package:get/get.dart';
import 'package:sfa_tools/bindings/coupon_mab_binding.dart';
import 'package:sfa_tools/bindings/history_page_binding.dart';
import 'package:sfa_tools/bindings/quiz_page_binding.dart';
import 'package:sfa_tools/bindings/starter_page_binding.dart';
import 'package:sfa_tools/bindings/splashscreen_binding.dart';
import 'package:sfa_tools/common/route_config.dart';
import 'package:sfa_tools/screens/coupon_mab/approval.dart';
import 'package:sfa_tools/screens/quiz_screen/quiz_countdown.dart';
import 'package:sfa_tools/screens/quiz_screen/quiz_dashboard.dart';
import 'package:sfa_tools/screens/quiz_screen/quiz_history.dart';
import 'package:sfa_tools/screens/homepage.dart';
import 'package:sfa_tools/screens/quiz_screen/quiz.dart';
import 'package:sfa_tools/screens/splash_screen.dart';
import 'package:sfa_tools/screens/quiz_screen/quiz_starter.dart';
import 'package:sfa_tools/screens/taking_order_vendor/bottombartransaction.dart';

class AppRoute {
  static final pages = [
    GetPage(
      name: RouteName.splashscreen,
      page: () => const SplashScreen(),
      binding: SplashScreenBinding(),
      // transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.quizDashboard,
      page: () => const QuizDashboard(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: RouteName.homepage,
      page: () => Homepage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.starter,
      page: () => StartQuiz(),
      binding: StarterPageBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.countdown,
      page: () => const CountdownPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.quiz,
      page: () => QuizPage(),
      binding: QuizPageBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RouteName.history,
      page: () => HistoryPage(),
      binding: HistoryPageBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.couponMAB,
      page: () => CouponMAB(),
      binding: CouponMABBinding(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: RouteName.takingOrderVendor,
      page: () => BottomBartransaction(),
      transition: Transition.circularReveal,
    ),
  ];
}
