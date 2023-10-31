import 'dart:ui';

import 'package:sfa_tools/tools/utils.dart';

class AppConfig {
  static const String key = "2anLBen0Vi6ysErxXR7vaepHXjnrAHAu";
  static const String iv = "sfatoolsparamobj";

  static const String baseLocalUrl = "http://103.145.212.182/sfaquiz/public/api";
  static const String initLocalUrl = "http://103.145.212.182/sfaquiz";
  static const String tesLocalUrl = "http://103.145.212.182/sfaquiz/public/test";

  static const String basePublicUrl = "https://portal.avianbrands.com/sfaquiz/public/api";
  static const String initPublicUrl = "https://portal.avianbrands.com/sfaquiz";
  static const String tesPublicUrl = "https://portal.avianbrands.com/sfaquiz/public/test";

  static const String filevendor = '/storage/emulated/0/TKTW/SFATools.txt';
  static const String filequiz = '/storage/emulated/0/TKTW/SFANotif.txt';
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  static const boxSubmitQuiz = "retrySubmitQuizBox";
  static const keyDataBoxSubmitQuiz = "bodyData";
  static const keyStatusBoxSubmitQuiz = "retryStatus";

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