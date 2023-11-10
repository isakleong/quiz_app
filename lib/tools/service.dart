import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/tools/logging.dart';
import 'package:http/http.dart' as http;
// show Client, Request;

class ApiClient {
  Future getData(String url, String path, {int? timeouttime, var options}) async {
    try {
      //print(url);
      final dio = Dio(  
        BaseOptions(baseUrl: url, connectTimeout: Duration(seconds: timeouttime ?? 15), receiveTimeout: Duration(seconds: timeouttime ?? 30))
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
      if(options == null){
        final response = await dio.get(path);
        return response.data;
      }
      else{
        final response = await dio.get(path,options: options);
        return response.data;
      }

    } catch (e) {
      if(url == "") {
        throw Exception(Message.errorConnection);
      } else {
        throw Exception(e);
      }
    }
  }

  Future postData(String url, String path, var formData, var options, {int? timeouttime}) async {
    try {
      final dio = Dio(
        BaseOptions(baseUrl: url, connectTimeout: Duration(seconds: timeouttime ?? 15), receiveTimeout: Duration(seconds: timeouttime ?? 30))
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

  Future<String> checkConnection({String? jenis}) async {
    //get ip
    var ipAddress = [];
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if(addr.type.name == "IPv4"){
          ipAddress = addr.rawAddress;
        }
      }
    }

    if(ipAddress.isNotEmpty) {
      if(ipAddress[0].toString() == "10" && ipAddress[1].toString() == "10") {
        if(jenis == "vendor"){
          return "true|${AppConfig.baseUrlVendorLocal}";
        }
        return "true|${AppConfig.baseLocalUrl}";
      } else {
        if(jenis == "vendor"){
          return "true|${AppConfig.baseUrlVendor}";
        }
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
  
  Future<void> downloadfiles(String dir,String fname, String vendorname) async{
     try {
        String productdir = AppConfig().productdir;
        print("on download");
    
        if (await Directory('$productdir/${vendorname.toLowerCase()}$dir'.replaceAll("%20", " ")).exists() && await File("$productdir/${vendorname.toLowerCase()}$dir/$fname".replaceAll("%20", " ")).exists()) {
            return;
        }
      
        var connTest = await ApiClient().checkConnection();
        var arrConnTest = connTest.split("|");
        bool isConnected = arrConnTest[0] == 'true';
        String urlAPI = arrConnTest[1];
        if(!isConnected){
          return;
        }
        // Create a folder if it doesn't exist
        Directory directory = Directory('$productdir/${vendorname.toLowerCase()}$dir'.replaceAll("%20", " "));
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Create the file path
        String filePath = '$productdir/${vendorname.toLowerCase()}$dir/$fname';

        var postbody = {
          'path' : '$dir/$fname',
          'vendor' : vendorname.toLowerCase()
        };

        // Download the file
        final response = await http.post(Uri.parse("$urlAPI/getproductbydir"),headers: {"Content-Type": "application/json",}, body: jsonEncode(postbody),);
        if (response.statusCode == 200) {
          // Write the file
          File file = File(filePath.replaceAll("%20", " "));
          await file.writeAsBytes(response.bodyBytes);
        }
     } catch (e) {
     }
  }

}

class ApiHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}