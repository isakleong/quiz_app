import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/tools/logging.dart';
// show Client, Request;

class ApiClient {
  Future getData(String url, String path, {int? timeouttime}) async {
    try {
      print(url);
      final dio = Dio(  
        BaseOptions(baseUrl: url,connectTimeout: Duration(seconds: timeouttime ?? 5 ))
      )..interceptors.add(Logging());

      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) {
            return true;
          };
          return client;
        },
      );

      //not used anymore (onHttpClientCreate is deprecated and shouldn't be used. Use createHttpClient instead)
      // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      //   client.badCertificateCallback=(X509Certificate cert, String host, int port){
      //       return true;
      //   };
      //   return null;
      // };

      dio.interceptors.add(Logging());

      final response = await dio.get(path);

      return response.data;
    } catch (e) {
      if(url == "") {
        throw Exception(Message.errorConnection);
      } else {
        throw Exception(e);
      }
    }
  }

  Future postData(String url, String path, var formData, var options) async {
    try {
      final dio = Dio(
        BaseOptions(baseUrl: url)
      );
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) {
            return true;
          };
          return client;
        },
      );

      //not used anymore (onHttpClientCreate is deprecated and shouldn't be used. Use createHttpClient instead)
      // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate  = (client) {
      //   client.badCertificateCallback=(X509Certificate cert, String host, int port){
      //       return true;
      //   };
      //   return null;
      // };

      dio.interceptors.add(Logging());

      final response = await dio.post(path, data: formData, options: options);

      return response.data;
    } catch (e) {
      if(url == "") {
        throw Exception(Message.errorConnection);
      } else {
        throw Exception(e);
      }
    }
  }

  Future<String> checkConnection() async {
    //get ip
    var ipAddress = [];
    for (var interface in await NetworkInterface.list()) {
      // print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        // print('${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
        ipAddress = addr.rawAddress;
      }
    }

    if(ipAddress.isNotEmpty) {
      if(ipAddress[0] == "10" && ipAddress[1] == "10") {
        return "true|${AppConfig.baseLocalUrl}";
      } else {
        return "true|${AppConfig.basePublicUrl}";
      }
    } else {
      return "false|";
    }

    // try {
    //   final conn_1 = await urlTest(AppConfig.tesPublicUrl);
    //   if (conn_1 == "OK") {
    //     data = "true|${AppConfig.basePublicUrl}";
    //   } else {
    //     final conn_2 = await urlTest(AppConfig.tesLocalUrl);
    //     if (conn_2 == "OK") {
    //       data = "true|${AppConfig.baseLocalUrl}";
    //     } else {
    //       data = "false|";
    //     }
    //   }
    // } on SocketException {
    //   try {
    //     final conn_2 = await urlTest(AppConfig.tesLocalUrl);
    //     if (conn_2 == "OK") {
    //       data = "true|${AppConfig.baseLocalUrl}";
    //     }
    //   } on SocketException {
    //     data = "false|";
    //   }
    // }
  }

  // Future<String> urlTest(String url) async {
  //   Client client = Client();
  //   String testResult = "ERROR";

  //   final request = Request('Get', Uri.parse(url))..followRedirects = false;
  //   try {
  //     final response = await client.send(request).timeout(const Duration(seconds: 5));

  //     if(response.statusCode <400 && response.statusCode !=0){
  //       testResult = "OK";
  //     } else {
  //       testResult = "ERROR";
  //     }
  //   } catch(e) {
  //     testResult = "ERROR";
  //   }

  //   return testResult;
  // }
  

}

class ApiHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}