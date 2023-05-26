// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/models/servicebox.dart';
import '../models/apiresponse.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/module.dart';
import '../models/quiz.dart';
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
  Timer.periodic(const Duration(hours: 1), (timer) async {
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
    // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

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
  Future hiveInitializer() async {
    Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(ModuleAdapter());
    Hive.registerAdapter(QuizAdapter());
    Hive.registerAdapter(ServiceBoxAdapter());
  }

  Future writeText(String teks) async {
    File(join(AppConfig.filequiz))
      ..createSync(recursive: true)
      ..writeAsString(teks);
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
      if (parameter != "") {
        var arrParameter = parameter.split(';');
        for (int i = 0; i < arrParameter.length; i++) {
          if (i == 0) {
            //salesid
            _salesidvendor = arrParameter[i];
          } else if (i == 1) {
            // custid = arrParameter[i];
          } else {
            // loccin = arrParameter[2];
          }
        }
      }

      String _salesidQuiz = await readFileQuiz();

      if (_salesidQuiz != "" && _salesidvendor != "") {
        if (_salesidQuiz.split(";")[2] == _salesidvendor) {
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

  retrySubmitQuiz() async {
    var retrySubmitQuizBox = await Hive.openBox('retrySubmitQuizBox');
    bool retryStatus = retrySubmitQuizBox.get("retryStatus");
    if(retryStatus) {
      var submitQuizBox = await Hive.openBox('submitQuizBox');
      var params = submitQuizBox.get("bodyData");

      bool isConnected = await ApiClient().checkConnection();
      if(isConnected) {
        var bodyData = jsonEncode(params);
        var resultSubmit = await ApiClient().postData(
          '/quiz/submit',
          bodyData,
          Options(headers: {HttpHeaders.contentTypeHeader: "application/json"})
        );

        if(resultSubmit == "success"){
          var retrySubmitQuizBox = await Hive.openBox('retrySubmitQuizBox');
          retrySubmitQuizBox.put("retryStatus", false);

          String tempSalesID = await Utils().readParameter();
          var salesId = tempSalesID.split(';')[0];

          var info = await Backgroundservicecontroller().getLatestStatusQuiz(salesId); 
          if(info != "err"){
            String _filequiz = await Backgroundservicecontroller().readFileQuiz();
            await Backgroundservicecontroller().writeText("${info};${_filequiz.split(";")[1]};${salesId};${DateTime.now()}");
          } else {
            await Backgroundservicecontroller().accessBox("create", "retryApi", "1");
          }
        }
      }

    }
  }

  cekQuiz() async {
    if (await isSameSalesid()) {
      try {
        String _filequiz = await readFileQuiz();
        DateTime now = DateTime.now();
        DateTime datetimefilequiz = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS")
            .parse(_filequiz.split(";")[3]);
        Duration difference = datetimefilequiz.difference(now);
        var dataBox = await accessBox("read", "retryApi", "");
        if (difference.inDays >= 1 ||
            (dataBox != null && dataBox.value == "1")) {
          //sudah melewati 1 hari
          String status = await getLatestStatusQuiz(_filequiz.split(";")[2]);
          if (status != "err") {
            //status;service time;salesid;last hit api time
            await accessBox("create", "retryApi", "0");
            await writeText(
                "${status};${DateTime.now()};${_filequiz.split(";")[2]};${DateTime.now()}");
          } else if (status == "err") {
            await writeText(
                "${status};${DateTime.now()};${_filequiz.split(";")[2]};${_filequiz.split(";")[3]}");
          }
        } else {
          await writeText(
              "${_filequiz.split(";")[0]};${DateTime.now()};${_filequiz.split(";")[2]};${_filequiz.split(";")[3]}");
        }
      } catch (e) {
        return;
      }
    } else {
      try {
        String _salesidVendor = await Utils().readParameter();
        if (_salesidVendor != "") {
          //hit api only when there is salesid from vendor
          String status =
              await getLatestStatusQuiz(_salesidVendor.split(';')[0]);
          if (status != "err") {
            //status;service time;salesid;last hit api time
            await writeText(
                "${status};${DateTime.now()};${_salesidVendor.split(';')[0]};${DateTime.now()}");
          } else {
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

  Future<String> getLatestStatusQuiz(String salesid) async {
    try {
      var req = await ApiClient().getData("/quiz/status?sales_id=${salesid}");
      Map<String, dynamic> jsonResponse = json.decode(req);
      ApiResponse response = ApiResponse.fromJson(jsonResponse);
      if (response.code.toString() == "200") {
        return response.message;
      } else {
        return "err";
      }
    } catch (e) {
      return "err";
    }
  }

  accessBox(String type, String key, String value) async {
    try {
      await hiveInitializer();
    } catch (e) {
      return;
    }
    var mybox = await Hive.openBox<ServiceBox>('serviceBox');
    if (type == "read") {
      try {
        var data = mybox.get(key);
        return data;
      } catch (e) {
        return "err";
      }
    } else if (type == "create") {
      try {
        mybox.put(key, ServiceBox(value: value));
        return "created";
      } catch (e) {
        return "err";
      }
    } else if (type == "update") {
      try {
        var boxtoupdate = mybox.get(key);
        boxtoupdate!.value = value;
        var newvalue = boxtoupdate.value;
        return newvalue;
      } catch (e) {
        return "err";
      }
    } else if (type == "delete") {
      try {
        mybox.delete(key);
        return "deleted";
      } catch (e) {
        return "err";
      }
    }
    return "err";
  }

  pauseOrContinueBackGroundService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    } else {
      service.startService();
    }
  }
}
