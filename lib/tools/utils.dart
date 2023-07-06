import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:encrypt/encrypt.dart';
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
}