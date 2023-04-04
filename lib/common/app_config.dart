
import 'dart:ui';

import 'package:quiz_app/tools/utils.dart';

class AppConfig {
  static const String appsName = "Kuis";

  // static const String baseUrl = "https://link.tirtakencana.com/QuizApp/public/api";
  static const String baseUrl = "https://link.tirtakencana.com/QuizApp/public/api";
  static const String initUrl = "https://link.tirtakencana.com/QuizApp";
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  static Color get darkGreen => Utils.color('#315C4E');
  static Color get mainGreen => Utils.color('#1B8C5C');
  static Color get softGreen => Utils.color('#56dbb0');
  static Color get lightSoftGreen => Utils.color('#80E4C4');
  static Color get grayishGreen => Utils.color('#E0F6E3');
  static Color get lightGrayishGreen => Utils.color('#F4FCF5');

  static Color get mainCyan => Utils.color('#11998E');
  static Color get softCyan => Utils.color('#38EF7D');
  static Color get mainRed => Utils.color('#EB3349');
  static Color get softRed => Utils.color('#F45C43');
  
}