import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/tools/logging.dart';
import 'package:http/http.dart' show Client, Request;

class ApiClient {
  Future getData(String path) async {
    String urlAPI = await getUrlAPI();

    try {
      final dio = Dio(  
        BaseOptions(baseUrl: urlAPI)
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
      if(urlAPI == "") {
        throw Exception(Message.errorConnection);
      } else {
        throw Exception(e);
      }
    }
  }

  Future postData(String path, var formData, var options) async {
    String urlAPI = await getUrlAPI();
    try {
      final dio = Dio(
        BaseOptions(baseUrl: urlAPI)
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
      if(urlAPI == "") {
        throw Exception(Message.errorConnection);
      } else {
        throw Exception(e);
      }
    }
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  // getU() async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     return AppConfig.basePublicUrl;
  //   } else if (connectivityResult == ConnectivityResult.vpn) {
  //     return AppConfig.baseLocalUrl;
  //   } else if (connectivityResult == ConnectivityResult.other) {
  //     return "other";
  //   } else if (connectivityResult == ConnectivityResult.none) {
  //     return "none";
  //   }
  // }

  Future<String> getUrlAPI() async {
    String url = "";
    try {
      final conn_1 = await urlTest(AppConfig.tesLocalUrl);
      if (conn_1 == "OK") {
        url = AppConfig.baseLocalUrl;
      }
    } on SocketException {
      try {
        final conn_2 = await urlTest(AppConfig.tesPublicUrl);
        if (conn_2 == "OK") {
          url = AppConfig.basePublicUrl;
        }
      } on SocketException {
        url = "";
      }
    }
    return url;
  }

  Future<String> urlTest(String url) async {
    Client client = Client();
    String testResult = "ERROR";

    final request = Request('HEAD', Uri.parse(url))..followRedirects = false;
    try {
      final response = await client.send(request).timeout(
        const Duration(seconds: 10),
      );

      if(response.statusCode == 200){
        testResult = "OK";
      } else {
        testResult = "ERROR";
      }  
    } catch (e) {
      testResult = "ERROR";
    }

    return testResult;
  }

}

class ApiHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}