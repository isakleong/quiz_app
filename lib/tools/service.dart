import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/tools/logging.dart';

class ApiClient {
  Future getData(String path) async {
    try {
      final dio = Dio(  
        BaseOptions(baseUrl: AppConfig.baseUrl)
      )..interceptors.add(Logging());
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate  = (client) {
        client.badCertificateCallback=(X509Certificate cert, String host, int port){
            return true;
        };
        return null;
      };

      dio.interceptors.add(Logging());

      final response = await dio.get(path);

      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future postData(String path, var formData, var options) async {
    try {
      final dio = Dio(
        BaseOptions(baseUrl: AppConfig.baseUrl)
      );
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate  = (client) {
        client.badCertificateCallback=(X509Certificate cert, String host, int port){
            return true;
        };
        return null;
      };

      dio.interceptors.add(Logging());

      final response = await dio.post(path, data: formData, options: options);

      return response.data;
    } on DioError catch (e) {
      debugPrint("exc ${e.message.toString()}");
      throw Exception(e.message);
    }
  }

  Future<bool> checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      return true;
    } else {
      return false;
    }
  }

}

class ApiHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}