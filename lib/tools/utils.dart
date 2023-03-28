import 'dart:convert';
import 'dart:ui';

import 'package:quiz_app/tools/service.dart';

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
    } on FormatException catch (e) {
      isDecodeSucceed = false;
    }

    return isDecodeSucceed;
  }

}