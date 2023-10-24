import 'dart:ui';

import 'package:sfa_tools/tools/utils.dart';

class AppConfig {
  static const String key = "2anLBen0Vi6ysErxXR7vaepHXjnrAHAu";
  static const String iv = "sfatoolsparamobj";

  static const String baseLocalUrl = "http://192.168.10.213/SFATools/public/api";
  static const String initLocalUrl = "http://192.168.10.213/SFATools";
  static const String tesLocalUrl = "http://192.168.10.213/SFATools/public/test";

  static const String basePublicUrl = "https://link.tirtakencana.com/SFATools/public/api";
  static const String initPublicUrl = "https://link.tirtakencana.com/SFATools";
  static const String tesPublicUrl = "https://link.tirtakencana.com/SFATools/public/test";

  static const String baseUrlVendor = "https://mitra.tirtakencana.com";
  static const String baseUrlVendorLocal = "http://10.11.22.21";
  static const String apiurlvendorpath = "/tangki-air-jerapah";
  String unknowerrorvendor = "100";
  String itemcodenotfoundvendor = "101";
  String dateinvalidvendor = "102";
  String orderalreadyexistvendor = "103";
  String productdir = "/storage/emulated/0/TKTW/infoproduk";
  String forall = "ALL";
  String forbranch = "CABANG";
  String forcolor = "COLOR";
  String forarea = "AREA";
  String informasiconfig = "infoconfig.txt";
  String folderpricelist = "Pricelist";
  String folderProductKnowledge = "Product%20Knowledge";
  String folderPromo = "Promo";
  String vendorstate = 'VENDOR STATE';

  // static const String baseUrl = "https://link.tirtakencana.com/SFATools/public/api";
  // static const String initUrl = "https://link.tirtakencana.com/SFATools";

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