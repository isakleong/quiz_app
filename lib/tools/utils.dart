import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/common/app_config.dart';

class Utils {

  static Color color([String code = '#999999']) {
    if (code.isEmpty || code[0] != '#' || (code.length != 4 && code.length != 7)) {
      throw ArgumentError('The format of the passed string is wrong: $code');
    }
    if (code.length == 4) {
      code = '#${code[1]}${code[1]}${code[2]}${code[2]}${code[3]}${code[3]}';
    }

    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static validateData(var data) {
    bool isDecodeSucceed = false;

    try {
      jsonDecode(data.toString());
      isDecodeSucceed = true;
    } on FormatException {
      isDecodeSucceed = false;
    }

    return isDecodeSucceed;
  }

  int convertVersionNumber(String version) {
    var arrVersion = [];

    arrVersion = version.split('.');
    arrVersion = arrVersion.map(
      (i) => int.parse(i)
    ).toList();

    int versionNumber = arrVersion[0] * 100000 + arrVersion[1] * 1000 + arrVersion[2];

    return versionNumber;
  }

  Future<String> readParameter() async {
    try {
      final file = File('/storage/emulated/0/TKTW/SFATools.txt');

      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  static encryptData(String params){
    final key = Key.fromUtf8(AppConfig.key);
    final initVector = IV.fromUtf8(AppConfig.iv);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(params, iv: initVector);
    return encrypted.base64;
  }

  //created for vendor
  String formatNumber(var number) {
    final NumberFormat numberFormat = NumberFormat('#,##0');
    return numberFormat.format(number);
  }

  String encryptsalescodeforvendor(String toencrypt){
    // print("string to encrypt $toencrypt");
    // String salter = (Random().nextInt(900) + 100).toString();
    final key = Key.fromUtf8("fVkhoDWRAd4Rgj6l");  
    final iv = IV.fromUtf8("tGYINBYOtJ2tZoZJ");  

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(toencrypt, iv: iv);

    return encrypted.base64;
  }

  String formatDate(String dateTimeString) {
    final inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
    final outputFormat = DateFormat('dd-MM-yyyy');

    final dateTime = inputFormat.parse(dateTimeString);
    final formattedDate = outputFormat.format(dateTime);

    return formattedDate;
  }

  bool isDateNotToday(String dateTimeString) {
    final inputFormat = DateFormat('dd-MM-yyyy');
    final dateTime = inputFormat.parse(dateTimeString);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return dateTime.isBefore(today);
  }
  
  getParameterData(String type) async {
    //SalesID;CustID;LocCheckIn
    String parameter = await readParameter();
    if (parameter != "") {
      var arrParameter = parameter.split(';');
      for (int i = 0; i < arrParameter.length; i++) {
        if (i == 0 && type == "sales") {
          return arrParameter[i];
        } else if (i == 1 && type == "cust") {
          return arrParameter[i];
        } else if (type == "") {
          return arrParameter[i];
        }
      }
    }
  }

  String changeUrl(String originalUrl) {
  Uri originalUri = Uri.parse(originalUrl);
  String newPath = originalUri.path; // Keep the original path
  String newUrl = "${AppConfig.baseUrlVendorLocal}$newPath";
  return newUrl;
}
  
  bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
  }

  isinperiod(String tocompare){
    List<String> dateStrings = tocompare.split('&');

    // Extract the start and end date from the date strings
    String startDateStr  = dateStrings[0].split('=')[1];
    String endDateStr  = dateStrings[1];

    // Parse the start and end dates
    DateTime startDate = DateTime.parse(startDateStr);
    DateTime endDate = DateTime.parse(endDateStr);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Check if the current date is within the date range
    if ((currentDate.isAfter(startDate) || isSameDate(startDate, currentDate)) && (currentDate.isBefore(endDate) || isSameDate(endDate, currentDate))) {
      return true;
    } else {
      return false;
    }
  }

  String formatDateToMonthAlias(String dateString) {
    List<String> parts = dateString.split('-');
    int month = int.parse(parts[1]);
    
    // Mapping bulan
    final Map<int, String> monthMapping = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'Mei',
      6: 'Jun',
      7: 'Jul',
      8: 'Agu',
      9: 'Sep',
      10: 'Okt',
      11: 'Nov',
      12: 'Des'
    };

    String formattedDay = parts[2].padLeft(2, '0');
    String formattedMonth = monthMapping[month]!;

    return '$formattedDay $formattedMonth';
  }

  String decrypt(String encrypted) {
  final key = Key.fromUtf8("fVkhoDWRAd4Rgj6l"); //hardcode combination of 16 character
  final iv = IV.fromUtf8("tGYINBYOtJ2tZoZJ"); //hardcode combination of 16 character

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  Encrypted enBase64 = Encrypted.from64(encrypted);
  final decrypted = encrypter.decrypt(enBase64, iv: iv);
  return decrypted;
}
  //end created for vendor
}