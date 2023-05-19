import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:http/http.dart' as http;
import '../models/apiresponse.dart';
import '../tools/service.dart';
import '../tools/utils.dart';

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    await Backgroundservicecontroller().cekQuiz();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );
      }
    }
    // Backgroundservicecontroller().writeText("Updated at ${DateTime.now()}");
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}
  
class Backgroundservicecontroller {

  Future writeText(String teks) async {
     File(join(
          AppConfig.filequiz))
        ..createSync(recursive: true)..writeAsString(teks);
  }

  String getCurrentTimeStamp() {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('HH:mm:ss').format(now);
  return formattedTime;
}

  Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: null,
      onBackground: null,
    ),
  );

  service.startService();
}

  Future<bool> isSameSalesid() async {
    try {
      String parameter = await Utils().readParameter();
      String _salesidvendor = "";
      // print("parameter : " + parameter);
      if(parameter != "") {
        var arrParameter = parameter.split(';');
        for(int i=0; i<arrParameter.length; i++) {
            if(i == 0) {
              //salesid
              _salesidvendor  = arrParameter[i];
            } else if(i == 1) {
              // custid = arrParameter[i];
            } else {
              // loccin = arrParameter[2];
            }
          }
      }
      // print("ini sales id vendor : " + _salesidvendor);
      String _salesidQuiz = await readFileQuiz();
        // print("ini sales id sfatools : " + _salesidQuiz.split(";")[2]);
      if (_salesidQuiz != "" && _salesidvendor != ""){
          if(_salesidQuiz.split(";")[2] == _salesidvendor){
            return true;
          }
      }
      return false;
    } catch (e) {
      return false;
    }
  
}

  Future<String> readFileQuiz() async {
    try {
      final file = File(AppConfig.filequiz);

      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  deletefile(String files) async {
    try {
      final File file = File(files);
      file.delete();
    } catch (e) {
      return;
    }
  }

  cekQuiz() async {

    if (await isSameSalesid()){
      print("sales sama ");
      try {
        String _filequiz = await readFileQuiz();
        DateTime now = DateTime.now();
        DateTime datetimefilequiz = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(_filequiz.split(";")[3]);
        Duration difference = datetimefilequiz.difference(now);
        if(difference.inDays >= 1){
          //sudah melewati 1 hari
          String status = await getLatestStatusQuiz();
          if(status != "err"){
            //status;service time;salesid;last hit api time
            await writeText("${status};${DateTime.now()};${_filequiz.split(";")[2]};${DateTime.now()}");
          } else if (status == "err"){
            await writeText("${status};${DateTime.now()};${_filequiz.split(";")[2]};${_filequiz.split(";")[3]}");
          }
        } else {
          await writeText("${_filequiz.split(";")[0]};${DateTime.now()};${_filequiz.split(";")[2]};${_filequiz.split(";")[3]}");
        }
      } catch (e) {
        return;
      }
    } else {
      print("sales tidak sama ");
      try {
        String _salesidVendor = await Utils().readParameter();
        if(_salesidVendor!=""){
          //hit api only when there is salesid from vendor
          String status = await getLatestStatusQuiz();
          if(status != "err"){
            //status;service time;salesid;last hit api time
            await writeText("${status};${DateTime.now()};${_salesidVendor.split(';')[0]};${DateTime.now()}");
          } else{
            await writeText(";${DateTime.now()};;");
          }
        } else {
            await writeText(";${DateTime.now()};;");
        }
      } catch (e) {
        return;
      }
    }
  }

  Future<String> getLatestStatusQuiz() async{
    try {
     var req = await ApiClient().getData("/quiz/status?sales_id=01AC1A0103");
      Map<String, dynamic> jsonResponse = json.decode(req);
      ApiResponse response = ApiResponse.fromJson(jsonResponse);
      if(response.code.toString() == "200"){
        return response.message;
      }else {
        return "err";
      }
    } catch (e) {
      return "err";
    }
  }

}