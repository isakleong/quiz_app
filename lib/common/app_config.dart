
import 'dart:ui';

import 'package:quiz_app/tools/utils.dart';

class AppConfig {
  // static const String baseUrl = "https://link.tirtakencana.com/QuizApp/public/api";
  static const String baseUrl = "http://192.168.10.213/QuizApp/public/api";
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  static Color get darkGreenColor => Utils.color('#315C4E');
  static Color get mainGreenColor => Utils.color('#1B8C5C');
  static Color get lightGreenColor => Utils.color('#80E4C4');
  static Color get lightOpactityGreenColor => Utils.color('#E0F6E3');
}