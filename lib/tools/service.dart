import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:quiz_app/common/app_config.dart';

class ApiClient {
  Future getData(String path) async {
    try {
      final dio = Dio(
        BaseOptions(baseUrl: AppConfig.baseUrl)
      );
      // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate  = (client) {
      //   client.badCertificateCallback=(X509Certificate cert, String host, int port){
      //       return true;
      //   };
      // };

      final response = await dio.get(path);

      return response.data;
    } on DioError catch (e) {
      print("exc ${e.message.toString()}");
      throw Exception(e.message);
    }
  }

  Future postData(String path, var formData, var options) async {
    try {
      final dio = Dio(
        BaseOptions(baseUrl: AppConfig.baseUrl)
      );
      // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate  = (client) {
      //   client.badCertificateCallback=(X509Certificate cert, String host, int port){
      //       return true;
      //   };
      // };

      final response = await dio.post(path, data: formData, options: options);

      return response.data;
    } on DioError catch (e) {
      print("exc ${e.message.toString()}");
      throw Exception(e.message);
    }
  }

}