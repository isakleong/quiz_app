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
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/models/cartdetail.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/models/couponmab.dart';
import 'package:sfa_tools/models/customer.dart';
import 'package:sfa_tools/models/quiz_config.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/servicebox.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';
import '../common/hivebox_vendor.dart';
import '../models/apiresponse.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/detailproductdata.dart';
import '../models/loginmodel.dart';
import '../models/module.dart';
import '../models/paymentdata.dart';
import '../models/penjualanpostmodel.dart';
import '../models/productdata.dart';
import '../models/quiz.dart';
import '../tools/service.dart';
import '../tools/utils.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
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

  //on ready (EXECUTED ONLY ONCE WHEN BACKROUND SERVICE STARTED)
  onReady(service);

  Timer.periodic(const Duration(hours: 1), (timer) async {
    await Backgroundservicecontroller().cekQuiz();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "SFA Tools Service",
          content: "quiz status at ${DateTime.now()}",
        );
      }
    }

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

  Timer.periodic(const Duration(minutes: 5), (timer) async {
    await Backgroundservicecontroller().retrySubmitQuiz();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "SFA Tools Service",
          content: "retry quiz at ${DateTime.now()}",
        );
      }
    }

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

  Timer.periodic(const Duration(seconds: 63), (timer) async {
    print("check data mab");
    String salesId = await Utils().readParameter();

    if (salesId != "") {
      if(salesId.split(';')[0].toLowerCase().contains("kcc") || salesId.split(';')[0].toLowerCase().contains("tcc") || salesId.split(';')[0].toLowerCase().contains("c100")) {
        await Backgroundservicecontroller().syncDataMAB();

        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            service.setForegroundNotificationInfo(
              title: "SFA Tools Service",
              content: "check data mab at ${DateTime.now()}",
            );
          }
        }

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
      }
    }
  });

  Timer.periodic(const Duration(minutes: 30), (timer) async {
    Backgroundservicecontroller().getlistvendor();
    await Backgroundservicecontroller().getPendingData();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "SFA Tools Service",
          content: "pending data Updated at ${DateTime.now()}",
        );
      }
    }

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

Future<void> onReady(ServiceInstance service) async {
  Backgroundservicecontroller().cekQuiz();
  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
       service.setForegroundNotificationInfo(
        title: "SFA Tools Service",
        content: "wake up task at ${DateTime.now()}",
      );
    }
  }

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
  //
}

class Backgroundservicecontroller {
  
  Future hiveInitializer() async {
    Directory directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(ModuleAdapter());
    Hive.registerAdapter(QuizAdapter());
    Hive.registerAdapter(QuizConfigAdapter());
    Hive.registerAdapter(ServiceBoxAdapter());
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(ShipToAddressAdapter());
    Hive.registerAdapter(VendorAdapter());
    Hive.registerAdapter(ReportPenjualanModelAdapter());
    Hive.registerAdapter(PenjualanPostModelAdapter());
    Hive.registerAdapter(CartDetailAdapter());
    Hive.registerAdapter(CartModelAdapter());
    Hive.registerAdapter(ProductDataAdapter());
    Hive.registerAdapter(DetailProductDataAdapter());
  }

  initializeNotifConfiguration() async {
    String fileNotif = "";
    fileNotif = await readFileQuiz();
    if (fileNotif == "") {
      String _salesidVendor = await Utils().readParameter();
      if (_salesidVendor != "") {
        //hit api only when there is salesid from vendor
        String status = await getLatestStatusQuiz(_salesidVendor.split(';')[0]);
        if (status != "err") {
          //status;salesid;service time;last hit api time
          await writeText(
              "${status};${_salesidVendor.split(';')[0]};${DateTime.now()};${DateTime.now()}");
        } else {
          await writeText(";;${DateTime.now()};");
        }
      } else {
        await writeText(";;${DateTime.now()};");
      }
    }
  }

  initializeMABConfiguration() async {
    String fileMAB = "";
    fileMAB = await readFileMAB();
    if (fileMAB == "") {
      String _salesidVendor = await Utils().readParameter();
      if (_salesidVendor != "") {
        //hit api only when there is salesid from vendor
        await syncDataMAB();
      } else {
        await writeMAB("0;${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())};");
      }
    }
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

  Future writeText(String teks) async {
    File(join(AppConfig.filequiz))
      ..createSync(recursive: true)
      ..writeAsString(teks);
  }

  Future writeMAB(String teks) async {
    File(join(AppConfig.filemab))
      ..createSync(recursive: true)
      ..writeAsString(teks);
  }

  // quiz section
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
        if (_salesidQuiz.split(";")[1] == _salesidvendor) {
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

  Future<String> readFileMAB() async {
    try {
      final file = File(AppConfig.filemab);

      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  syncDataMAB() async {
    try {
      String salesIdParams = await Utils().readParameter();

      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if(isConnected) {
        final encryptedParam = await Utils.encryptData(salesIdParams.split(';')[0]);
        final encodeParam = Uri.encodeComponent(encryptedParam);

        var result = await ApiClient().getData(urlAPI, "/mab/latest?sales_id=$encodeParam");
        bool isValid = Utils.validateData(result.toString());

        if(isValid) {
          var data = jsonDecode(result.toString());

          if(data.length > 0) {
            var newCheckData = <CouponMABData>[];

            data.map((item) {
              var tempItem = CouponMABData.fromJson(item);
              newCheckData.add(tempItem);
            }).toList();

            List<String?> newDocID = newCheckData.map((data) => data.id).toList();

            var boxDataMAB = await accessBox("read", "stateDataMAB", "", box: "boxDataMAB");
            
            if(boxDataMAB == null) {
              await Backgroundservicecontroller().accessBox("create", "stateDataMAB", jsonEncode(newDocID), box: "boxDataMAB");

              await writeMAB("${newDocID.length};${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}");
            } else {
              List<String?> stateDataMAB = (jsonDecode(boxDataMAB.value) as List<dynamic>).cast<String?>();

              // if (compareDataMAB(stateDataMAB, newDocID) && compareDataMAB(newDocID, stateDataMAB)){

              if (compareDataMAB(newDocID, stateDataMAB)){
                // print("DATA STILL SAME");
                //data still same
              } else {
                // print("DATA CHANGED !!!!!");
                await Backgroundservicecontroller().accessBox("create", "stateDataMAB", jsonEncode(newDocID), box: "boxDataMAB");
                await writeMAB("${newDocID.length};${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}");
              }
            }
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  bool compareDataMAB(List<dynamic> list1, List<dynamic> list2) {
    return list1.every((element) => list2.contains(element));
  }

  retrySubmitQuiz() async {
    try {
      var retryStatus = await accessBox(
          "read", AppConfig.keyStatusBoxSubmitQuiz, "",
          box: AppConfig.boxSubmitQuiz);
      if (retryStatus != null && retryStatus.value == "true") {
        var bodyData = await accessBox(
            "read", AppConfig.keyDataBoxSubmitQuiz, "",
            box: AppConfig.boxSubmitQuiz);

        var connTest = await ApiClient().checkConnection();
        var arrConnTest = connTest.split("|");
        bool isConnected = arrConnTest[0] == 'true';
        String urlAPI = arrConnTest[1];

        if (isConnected) {
          var resultSubmit = await ApiClient().postData(
              urlAPI,
              '/quiz/submit',
              Utils.encryptData(bodyData.value),
              Options(headers: {
                HttpHeaders.contentTypeHeader: "application/json"
              }));

          if (resultSubmit == "success") {
            await Backgroundservicecontroller().accessBox(
                "create", AppConfig.keyStatusBoxSubmitQuiz, "false",
                box: AppConfig.boxSubmitQuiz);

            //not used anymore (already using offline data handler on postquizdata function on quiz controller)
            // String tempSalesID = await Utils().readParameter();
            // var salesId = tempSalesID.split(';')[0];
            // var info = await Backgroundservicecontroller().getLatestStatusQuiz(salesId);
            // if(info != "err") {
            //   String _filequiz = await Backgroundservicecontroller().readFileQuiz();
            //   await Backgroundservicecontroller().writeText("${info};${_filequiz.split(";")[1]};${salesId};${DateTime.now()}");
            // } else {
            //   await Backgroundservicecontroller().accessBox("create", "retryApi", "1");
            // }
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  cekQuiz() async {
    if (await isSameSalesid()) {
      try {
        String _filequiz = await readFileQuiz();
        DateTime now = DateTime.now();
        DateTime datetimefilequiz = DateFormat("yyyy-MM-dd").parse(_filequiz.split(";")[3]);
        Duration difference = DateFormat("yyyy-MM-dd").parse(now.toString()).difference(datetimefilequiz);
        var dataBox = await accessBox("read", "retryApi", "");
        if (difference.inDays >= 1 || (dataBox != null && dataBox.value == "1")) {
          //sudah melewati 1 hari
          String status = await getLatestStatusQuiz(_filequiz.split(";")[1]);
          if (status != "err") {
            //status;salesid;service time;last hit api time
            await accessBox("create", "retryApi", "0");
            await writeText("${status};${_filequiz.split(";")[1]};${DateTime.now()};${DateTime.now()}");
          } else if (status == "err") {
            await writeText(
                "${status};${_filequiz.split(";")[1]};${DateTime.now()};${_filequiz.split(";")[3]}");
          }
        } else {
          await writeText(
              "${_filequiz.split(";")[0]};${_filequiz.split(";")[1]};${DateTime.now()};${_filequiz.split(";")[3]}");
        }
      } catch (e) {
        return;
      }
    } else {
      try {
        String _salesidVendor = await Utils().readParameter();
        if (_salesidVendor != "") {
          //hit api only when there is salesid from vendor
          String status = await getLatestStatusQuiz(_salesidVendor.split(';')[0]);
          if (status != "err") {
            //status;salesid;service time;last hit api time
            await writeText("${status};${_salesidVendor.split(';')[0]};${DateTime.now()};${DateTime.now()}");
          } else {
            await writeText(";;${DateTime.now()};");
          }
        } else {
          await writeText(";;${DateTime.now()};");
        }
      } catch (e) {
        return;
      }
    }
  }

  Future<String> getLatestStatusQuiz(String salesid) async {
    try {
      final encryptedParam = await Utils.encryptData(salesid);
      final encodeParam = Uri.encodeComponent(encryptedParam);

      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if (isConnected) {
        var req = await ApiClient().getData(urlAPI, "/quiz/status?sales_id=$encodeParam");
        Map<String, dynamic> jsonResponse = json.decode(req);
        ApiResponse response = ApiResponse.fromJson(jsonResponse);
        if (response.code.toString() == "200") {
          return response.message;
        } else {
          return "err";
        }
      } else {
        return "err";
      }
    } catch (e) {
      return "err";
    }
  }

  accessBox(String type, String key, String value, {String box = 'serviceBox'}) async {
    try {
      await hiveInitializer();
    } catch (e) {
      // return;
    }
    var mybox = await Hive.openBox<ServiceBox>(box);
    if (type == "read") {
      try {
        var data = mybox.get(key);
        mybox.close();

        return data;
      } catch (e) {
        return "err";
      }
    } else if (type == "create") {
      try {
        mybox.put(key, ServiceBox(value: value));
        mybox.close();

        return "created";
      } catch (e) {
        return "err";
      }
    } else if (type == "update") {
      try {
        var boxtoupdate = mybox.get(key);
        boxtoupdate!.value = value;
        var newvalue = boxtoupdate.value;
        mybox.close();

        return newvalue;
      } catch (e) {
        return "err";
      }
    } else if (type == "delete") {
      try {
        mybox.delete(key);
        mybox.close();

        return "deleted";
      } catch (e) {
        return "err";
      }
    }
    return "err";
  }
  //end quiz section

  //taking order vendor section
  List<Vendor> vendorlist = [];
  String productdir = AppConfig().productdir;
  String informasiconfig = AppConfig().informasiconfig;

  Future<void> createLogTes(String content) async {
    bool allowWriteLog = false; // Change to true to enable log writing
    const directoryPath = '/storage/emulated/0/TKTW/sfalog';
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final filePath = '$directoryPath/$formattedDate.txt';

    // ignore: dead_code
    if (allowWriteLog) {
      try {
        final directory = Directory(directoryPath);

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Delete log files older than 7 days
        final sevenDaysAgo = currentDate.subtract(const Duration(days: 7));
        await for (var entity in directory.list()) {
          if (entity is File) {
            final fileDateStr =
                DateFormat('yyyy-MM-dd').format(entity.lastModifiedSync());
            final fileDate = DateTime.parse(fileDateStr);
            if (fileDate.isBefore(sevenDaysAgo) ||
                fileDate.isAtSameMomentAs(sevenDaysAgo)) {
              await entity.delete();
              //print('Deleted old log file: ${entity.path}');
            }
          }
        }

        final file = File(filePath);

        if (!await file.exists()) {
          await file.create();
        }

        await file.writeAsString("$content\n", mode: FileMode.append);

        //print('File written successfully.');
      } catch (e) {
        //print('Error writing to file: $e');
      }
    }
  }

  gettoken() async {
    String salesId = await Utils().getParameterData('sales');
    var tokenboxdata = await tokenbox.get(salesId);
    var dectoken = Utils().decrypt(tokenboxdata);
    return dectoken;
  }

  getPendingData() async {
    print("get pending data");
    DateTime currentDateTime = DateTime.now();
    String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(currentDateTime);

    //pending penjualan
    await createLogTes("trying to get pending data at $date");
    await getBox();
    await createLogTes("finish get box");
    List<dynamic> keys = await getListKey('penjualan');
    await createLogTes("finish get key");
    await closebox();
    // print("keys penjualan");
    if (keys.isNotEmpty) {
      // print("keys penjualan");
      await createLogTes("key not empty");
      for (var m = 0; m < keys.length; m++) {
        await sendPendingData(keys[m]);
      }
    }

    //pending pembayaran
    await getBox();
    List<dynamic> keyspembayaran = await getListKey('pembayaran');
    await closebox();
    if (keyspembayaran.isNotEmpty) {
      // print("keys keyspembayaran");
      for (var m = 0; m < keyspembayaran.length; m++) {
        await sendPendingDatapembayaran(keyspembayaran[m]);
      }
    }

    //clear report penjualan
    await getBox();
    List<dynamic> keysreport = await getListKeyReport('penjualan');
    await closebox();
    if (keysreport.isNotEmpty) {
      for (var m = 0; m < keysreport.length; m++) {
        await removeoldreport(keysreport[m]);
      }
    }

    //clear report pembayaran
    await getBox();
    List<dynamic> keysreportpembayaran = await getListKeyReport('pembayaran');
    await closebox();
    if (keysreportpembayaran.isNotEmpty) {
      for (var m = 0; m < keysreportpembayaran.length; m++) {
        await removeoldreportpembayaran(keysreportpembayaran[m]);
      }
    }
    print("done get pending data");
  }

  sendPendingDatapembayaran(String keybox) async {
    await createLogTes("send pending data for key $keybox");
    await getBox();
    List<String> parts = keybox.split('|');
    String salesid = parts[0].trim();
    String cust = parts[1].trim();
    String vendorurl = parts[3].trim();
    var listpostbox = await postpembayaranbox.get(keybox);
    List<PenjualanPostModel> listpost = <PenjualanPostModel>[];
    if (listpostbox != null) {
      listpost.clear();
      for (var i = 0; i < listpostbox.length; i++) {
        listpost.add(listpostbox[i]);
      }
      await closebox();
      await postDataPembayaranAll(listpost, salesid, cust, keybox, vendorurl);
    }
  }

  sendPendingData(String keybox) async {
    await createLogTes("send pending data for key $keybox");
    await getBox();
    List<String> parts = keybox.split('|');
    String salesid = parts[0].trim();
    String cust = parts[1].trim();
    String vendorurl = parts[3].trim();
    var listpostbox = await boxpostpenjualan.get(keybox);
    List<PenjualanPostModel> listpost = <PenjualanPostModel>[];
    if (listpostbox != null) {
      listpost.clear();
      for (var i = 0; i < listpostbox.length; i++) {
        listpost.add(listpostbox[i]);
      }
      await closebox();
      await createLogTes("Listpost length ${listpost.length}");
      // for (var i = 0; i < listpost.length; i++) {
      //   await postDataOrder(listpost[i].dataList,salesid,cust,keybox,vendorurl);
      // }
      await postDataOrderAll(listpost, salesid, cust, keybox, vendorurl);
    }
  }

  removeoldreport(String keybox) async {
    await getBox();
    List<ReportPenjualanModel> listReportPenjualan = <ReportPenjualanModel>[];
    var datareportpenjualan = await boxreportpenjualan.get(keybox);
    for (var i = 0; i < datareportpenjualan.length; i++) {
      if (Utils().isDateNotToday(
              Utils().formatDate(datareportpenjualan[i].tanggal)) &&
          datareportpenjualan[i].condition == "success") {
      } else {
        listReportPenjualan.add(datareportpenjualan[i]);
      }
    }
    await boxreportpenjualan.delete(keybox);
    if (listReportPenjualan.isNotEmpty) {
      await boxreportpenjualan.put(keybox, listReportPenjualan);
    }
    await closebox();
  }

  removeoldreportpembayaran(String keybox) async {
    await getBox();
    var datapembayaranlist = [];
    var datareportpembayaran = await boxPembayaranReport.get(keybox);
    var converteddatapembayaran = json.decode(datareportpembayaran);
    for (var i = 0; i < converteddatapembayaran['data'].length; i++) {
      if (Utils().isDateNotToday(Utils()
              .formatDate(converteddatapembayaran['data'][i]['tanggal'])) &&
          converteddatapembayaran['data'][i]['condition'] == "success") {
      } else {
        datapembayaranlist.add(converteddatapembayaran['data'][i]);
      }
    }
    var joinedjson = {"data": datapembayaranlist};
    await boxPembayaranReport.delete(keybox);
    if (datapembayaranlist.isNotEmpty) {
      await boxPembayaranReport.put(keybox, jsonEncode(joinedjson));
    }
    await closebox();
  }

  getListKey(String jenis) async {
    if (jenis == 'penjualan') {
      List<dynamic> keys = boxpostpenjualan.keys.toList();
      return keys;
    } else if (jenis == 'pembayaran') {
      List<dynamic> keys = postpembayaranbox.keys.toList();
      return keys;
    } else if (jenis == 'vendor'){
      await openmastervendorbox('open');
      List<dynamic> keys = mastervendorbox.keys.toList();
      await openmastervendorbox('close');
      return keys;
    }
  }

  getListKeyReport(String jenis) async {
    if (jenis == 'penjualan') {
      List<dynamic> keys = boxreportpenjualan.keys.toList();
      return keys;
    } else if (jenis == 'pembayaran') {
      List<dynamic> keys = boxPembayaranReport.keys.toList();
      return keys;
    }
  }

  getBox() async {
    try {
      await hiveInitializer();
      try {
        boxpostpenjualan = await Hive.openBox('penjualanReportpostdata');
        boxreportpenjualan = await Hive.openBox('penjualanReport');
        postpembayaranbox = await Hive.openBox("postpembayaranbox");
        boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
        tokenbox = await Hive.openBox('tokenbox');
      // ignore: empty_catches
      } catch (e) {}
    } catch (e) {
      try {
        boxpostpenjualan = await Hive.openBox('penjualanReportpostdata');
        boxreportpenjualan = await Hive.openBox('penjualanReport');
        postpembayaranbox = await Hive.openBox("postpembayaranbox");
        boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
        tokenbox = await Hive.openBox('tokenbox');
      // ignore: empty_catches
      } catch (err) {}
    }
  }

  closebox() {
    try {
      boxpostpenjualan.close();
      boxreportpenjualan.close();
      postpembayaranbox.close();
      boxPembayaranReport.close();
      tokenbox.close();
    // ignore: empty_catches
    } catch (e) {}
  }

  openbranchinfobox() async {
    try {
      await hiveInitializer();
      try {
        branchinfobox = await Hive.openBox('BranchInfoBox');
      // ignore: empty_catches
      } catch (e) {}
    } catch (e) {
      try {
        branchinfobox = await Hive.openBox('BranchInfoBox');
      // ignore: empty_catches
      } catch (err) {}
    }
  }

  openmastervendorbox(String action) async{
    try {
      await hiveInitializer();
      try {
        if(action == 'open'){
          mastervendorbox = await Hive.openBox('mastervendorbox');
        } else {
          mastervendorbox.close();
        }
      } catch (e) {

      }
    } catch (e) {
      try {
        if(action == 'open'){
          mastervendorbox = await Hive.openBox('mastervendorbox');
        } else {
          mastervendorbox.close();
        }
      } catch (e) {

      }
    }
  }

  bool checkTimeDifference(String times) {
    DateTime currentDateTime = DateTime.now();
    DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateTime givenDateTime = format.parse(times);

    Duration difference = currentDateTime.difference(givenDateTime);

    if (difference.inMinutes > 1) {
      return true;
    }
    return false;
  }

  postDataOrderAll(List<PenjualanPostModel> data, String salesid, String custid,String key, String vendorurl) async {
    await createLogTes("on post Data order All");
    await getBox();
    var dectoken = await gettoken();
    var _datareportpenjualan = await boxreportpenjualan.get(key);
    var inc = 0;

    var connTest = await ApiClient().checkConnection(jenis: "vendor");
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];
    String urls = vendorurl;
    if(urlAPI == AppConfig.baseUrlVendorLocal){
      urlAPI = Utils().changeUrl(urls);
    } else {
      urlAPI = urls;
    }

    final url = Uri.parse('${urlAPI}sales-orders/store');
    final request = http.MultipartRequest('POST', url);
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < data[i].dataList.length; j++) {
        var ismorethan1minutes = checkTimeDifference(data[i].dataList[j]['orderDate']);
        // await createLogTes("${"list no on loop " + data[i].dataList[j]['extDocId']} $ismorethan1minutes ${data[i].dataList[j]['orderDate']}");
        if (ismorethan1minutes) {
          request.fields['data[$inc][extDocId]'] = data[i].dataList[j]['extDocId'];
          request.fields['data[$inc][orderDate]'] = data[i].dataList[j]['orderDate'];
          request.fields['data[$inc][customerNo]'] = data[i].dataList[j]['customerNo'];
          request.fields['data[$inc][lineNo]'] = data[i].dataList[j]['lineNo'];
          request.fields['data[$inc][uomId]'] = data[i].dataList[j]['uomId'];
          request.fields['data[$inc][itemId]'] = data[i].dataList[j]['itemId'];
          request.fields['data[$inc][qty]'] = data[i].dataList[j]['qty'];
          request.fields['data[$inc][note]'] = data[i].dataList[j]['note'];
          request.fields['data[$inc][shipTo]'] = data[i].dataList[j]['shipTo'];
          request.fields['data[$inc][salesPersonCode]'] = data[i].dataList[j]['salesPersonCode'];
          request.fields['data[$inc][komisi]'] = data[i].dataList[j]['komisi'];
          request.fields['data[$inc][receiverName]'] = data[i].dataList[j]['receiverName'] ?? "";
          request.fields['data[$inc][receiverAddress]'] = data[i].dataList[j]['receiverAddress'] ?? "";
          request.fields['data[$inc][receiverPhone]'] = data[i].dataList[j]['receiverPhone'] ?? "";
          request.fields['data[$inc][receiverPhone2]'] = data[i].dataList[j]['receiverPhone2'] ?? "";
          request.fields['data[$inc][receiverDesc]'] = data[i].dataList[j]['receiverDesc'] ?? "";
          inc = inc + 1;
        } else {
          break;
        }
      }
    }
    request.headers.addAll({
      'Authorization': 'Bearer ${dectoken}',
      'Accept': 'application/json',
    });
    // print("penjualan : ${urlAPI}sales-orders/store");
    if(!isConnected){
      await createLogTes("socketexception");
      for (var i = 0; i < _datareportpenjualan.length; i++) {
        for (var j = 0; j <= inc; j++) {
          if (_datareportpenjualan[i].id == request.fields['data[$j][extDocId]']) {
            _datareportpenjualan[i].condition = "pending";
          }
        }
      }
      await boxreportpenjualan.delete(key);
      await boxreportpenjualan.put(key, _datareportpenjualan);
      await closebox();
      return;
    }

    try {
      await createLogTes(request.fields.toString());
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      await createLogTes(responseString);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        if (jsonResponse["success"] == true) {
          // print("response true");
          var loopdatalength = jsonResponse['data'].length;
          for (var k = 0; k < loopdatalength; k++) {
            for (var i = 0; i < _datareportpenjualan.length; i++) {
              if (_datareportpenjualan[i].id ==
                      jsonResponse['data'][k]['extDocId'] &&
                  jsonResponse['data'][k]['success'] == true) {
                _datareportpenjualan[i].condition = "success";
              } else if (_datareportpenjualan[i].id ==
                      jsonResponse['data'][k]['extDocId'] &&
                  jsonResponse['data'][k]['success'] == false) {
                var listerror = jsonResponse['data'][k]['errors'].length;
                for (var m = 0; m < listerror; m++) {
                  if (jsonResponse['data'][i]['errors'][m]['code'] ==
                      AppConfig().orderalreadyexistvendor) {
                    _datareportpenjualan[i].condition = "success";
                    break;
                  } else {
                    _datareportpenjualan[i].condition = "pending";
                  }
                }
              }
            }
          }

          List<PenjualanPostModel> postadatanew = [];
          for (var i = 0; i < data.length; i++) {
            for (var k = 0; k < _datareportpenjualan.length; k++) {
              if (data[i].dataList[0]['extDocId'] ==
                      _datareportpenjualan[k].id &&
                  _datareportpenjualan[k].condition != "success") {
                postadatanew.add(data[i]);
                break;
              }
            }
          }

          await boxpostpenjualan.delete(key);
          if (postadatanew.isNotEmpty) {
            await boxpostpenjualan.put(key, postadatanew);
          }
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key, _datareportpenjualan);
        } else {
          for (var i = 0; i < _datareportpenjualan.length; i++) {
            for (var j = 0; j <= inc; j++) {
              if (_datareportpenjualan[i].id ==
                  request.fields['data[$j][extDocId]']) {
                _datareportpenjualan[i].condition = "pending";
              }
            }
          }
          await createLogTes("response not true");
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key, _datareportpenjualan);
        }
      } else {
        var jsonResponse = jsonDecode(responseString);
        try {
          if (jsonResponse["code"] == "300") {
            loginapivendor();
          }
        } finally {
          for (var i = 0; i < _datareportpenjualan.length; i++) {
            for (var j = 0; j <= inc; j++) {
              if (_datareportpenjualan[i].id ==
                  request.fields['data[$j][extDocId]']) {
                _datareportpenjualan[i].condition = "pending";
              }
            }
          }
          await createLogTes("response not 200");
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key, _datareportpenjualan);
        }
      }
    } on SocketException {
      await createLogTes("socketexception");
      for (var i = 0; i < _datareportpenjualan.length; i++) {
        for (var j = 0; j <= inc; j++) {
          if (_datareportpenjualan[i].id ==
              request.fields['data[$j][extDocId]']) {
            _datareportpenjualan[i].condition = "pending";
          }
        }
      }
      await boxreportpenjualan.delete(key);
      await boxreportpenjualan.put(key, _datareportpenjualan);
    } catch (e) {
      await createLogTes("$e abnormal");
      for (var i = 0; i < _datareportpenjualan.length; i++) {
        for (var j = 0; j <= inc; j++) {
          if (_datareportpenjualan[i].id ==
              request.fields['data[$j][extDocId]']) {
            _datareportpenjualan[i].condition = "pending";
          }
        }
      }
      await boxreportpenjualan.delete(key);
      await boxreportpenjualan.put(key, _datareportpenjualan);
    }
    await closebox();
  }

  loginapivendor() async {
    try {
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];
      if(!isConnected){
        return;
      }
      String salesiddata = await Utils().getParameterData("sales");
      String encparam = Utils().encryptsalescodeforvendor(salesiddata);
      var params = {"username": encparam};
      var result = await ApiClient().postData(urlAPI,"${AppConfig.apiurlvendorpath}/api/login",params,Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      var dataresp = LoginResponse.fromJson(result);
      if (!tokenbox.isOpen) {
        tokenbox = await Hive.openBox('tokenbox');
      }
      tokenbox.delete(salesiddata);
      tokenbox.put(salesiddata, dataresp.data!.token);
      tokenbox.close();
    // ignore: empty_catches
    } catch (e) {}
  }

  postDataPembayaranAll(List<PenjualanPostModel> data, String salesid, String custid, String key, String vendorurl) async {
    await createLogTes("on postDataPembayaranAll");
    await getBox();
    var dectoken = await gettoken();
    var _datareportpembayaran = json.decode(await boxPembayaranReport.get(key));
    List<ReportPembayaranModel> dataconvert = [];
    for (var i = 0; i < _datareportpembayaran['data'].length; i++) {
      List<PaymentData> _data = <PaymentData>[];
      var detail = _datareportpembayaran['data'][i]['listpayment'];
      for (var k = 0; k < detail.length; k++) {
        _data.add(PaymentData(detail[k]['jenis'], detail[k]['nomor'], detail[k]['tipe'], detail[k]['jatuhtempo'], detail[k]['value']));
      }
      dataconvert.add(ReportPembayaranModel(
          _datareportpembayaran['data'][i]['condition'],
          _datareportpembayaran['data'][i]['id'],
          _datareportpembayaran['data'][i]['total'],
          _datareportpembayaran['data'][i]['tanggal'],
          _datareportpembayaran['data'][i]['waktu'],
          _data));
    }

    
    var connTest = await ApiClient().checkConnection(jenis: "vendor");
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];
    String urls = vendorurl;
    if(urlAPI == AppConfig.baseUrlVendorLocal){
      urlAPI = Utils().changeUrl(urls);
    } else {
      urlAPI = urls;
    }

    //create post data
    var inc = 0;
    final url = Uri.parse('${urlAPI}payments/store');
    final request = http.MultipartRequest('POST', url);
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < data[i].dataList.length; j++) {
        var ismorethan1minutes = checkTimeDifference(data[i].dataList[j]['entryDate']);
        if (ismorethan1minutes) {
          request.fields['data[$inc][extDocId]'] = data[i].dataList[j]['extDocId'];
          request.fields['data[$inc][customerNo]'] = data[i].dataList[j]['customerNo'];
          request.fields['data[$inc][amount]'] = data[i].dataList[j]['amount'].toString();
          request.fields['data[$inc][salespersonCode]'] = data[i].dataList[j]['salespersonCode'];
          request.fields['data[$inc][entryDate]'] = data[i].dataList[j]['entryDate'];
          request.fields['data[$inc][bankId]'] = data[i].dataList[j]['bankId'].toString();
          request.fields['data[$inc][paymentMethodId]'] = data[i].dataList[j]['paymentMethodId'].toString();
          request.fields['data[$inc][bankName]'] = data[i].dataList[j]['bankName'];
          request.fields['data[$inc][dueDate]'] = data[i].dataList[j]['dueDate'];
          request.fields['data[$inc][serialNum]'] = data[i].dataList[j]['serialNum'];
          inc = inc + 1;
        } else {
          break;
        }
      }
    }
    request.headers.addAll({
      'Authorization': 'Bearer ${dectoken}',
      'Accept': 'application/json',
    });
    // print("pembayaran : ${urlAPI}payments/store");
    if(!isConnected){
      for (var i = 0; i < dataconvert.length; i++) {
        for (var j = 0; j <= inc; j++) {
          if (dataconvert[i].id == request.fields['data[$j][extDocId]']) {
            dataconvert[i].condition = "pending";
          }
        }
      }
      if (!boxPembayaranReport.isOpen) boxPembayaranReport = await Hive.openBox("BoxPembayaranReport");
      await boxPembayaranReport.delete(key);
      await boxPembayaranReport.put(key, tojsondata(dataconvert));
      await closebox();
      return;
    }
    //print(request.fields.toString());
    try {
      await createLogTes(request.fields.toString());
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      await createLogTes(responseString);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        //print(jsonResponse);
        if (jsonResponse["success"] == true) {
          // print("response true");
          var loopdatalength = jsonResponse['data'].length;
          for (var k = 0; k < loopdatalength; k++) {
            for (var i = 0; i < dataconvert.length; i++) {
              if (dataconvert[i].id == jsonResponse['data'][k]['extDocId'] && jsonResponse['data'][k]['success'] == true) {
                dataconvert[i].condition = "success";
              } else if (dataconvert[i].id == jsonResponse['data'][k]['extDocId'] && jsonResponse['data'][k]['success'] == false) {
                dataconvert[i].condition = "pending";
              }
            }
          }

          List<PenjualanPostModel> postadatanew = [];
          for (var i = 0; i < data.length; i++) {
            for (var k = 0; k < dataconvert.length; k++) {
              if (data[i].dataList[0]['extDocId'] == dataconvert[k].id && dataconvert[k].condition != "success") {
                postadatanew.add(data[i]);
                break;
              }
            }
          }
          if (!postpembayaranbox.isOpen) postpembayaranbox = await Hive.openBox("postpembayaranbox");
          await postpembayaranbox.delete(key);
          if (postadatanew.isNotEmpty) {
            await postpembayaranbox.put(key, postadatanew);
          }
          if (!boxPembayaranReport.isOpen) boxPembayaranReport = await Hive.openBox("BoxPembayaranReport");
          await boxPembayaranReport.delete(key);
          await boxPembayaranReport.put(key, tojsondata(dataconvert));
        } else {
          //print("response not true");
          for (var i = 0; i < dataconvert.length; i++) {
            for (var j = 0; j <= inc; j++) {
              if (dataconvert[i].id == request.fields['data[$j][extDocId]']) {
                dataconvert[i].condition = "pending";
              }
            }
          }
          if (!boxPembayaranReport.isOpen) boxPembayaranReport = await Hive.openBox("BoxPembayaranReport");
          await boxPembayaranReport.delete(key);
          await boxPembayaranReport.put(key, tojsondata(dataconvert));
        }
      } else {
        //response not 200
        var jsonResponse = jsonDecode(responseString);
        try {
          if (jsonResponse["code"] == "300") {
            loginapivendor();
          }
        } finally {
          for (var i = 0; i < dataconvert.length; i++) {
            for (var j = 0; j <= inc; j++) {
              if (dataconvert[i].id == request.fields['data[$j][extDocId]']) {
                dataconvert[i].condition = "pending";
              }
            }
          }
          if (!boxPembayaranReport.isOpen) boxPembayaranReport = await Hive.openBox("BoxPembayaranReport");
          await boxPembayaranReport.delete(key);
          await boxPembayaranReport.put(key, tojsondata(dataconvert));
        }
      }
    } on SocketException {
      // await createLogTes("socketexception");
      for (var i = 0; i < dataconvert.length; i++) {
        for (var j = 0; j <= inc; j++) {
          if (dataconvert[i].id == request.fields['data[$j][extDocId]']) {
            dataconvert[i].condition = "pending";
          }
        }
      }
      if (!boxPembayaranReport.isOpen) boxPembayaranReport = await Hive.openBox("BoxPembayaranReport");
      await boxPembayaranReport.delete(key);
      await boxPembayaranReport.put(key, tojsondata(dataconvert));
    } catch (e) {
      // await createLogTes("$e abnormal");
      for (var i = 0; i < dataconvert.length; i++) {
        for (var j = 0; j <= inc; j++) {
          if (dataconvert[i].id == request.fields['data[$j][extDocId]']) {
            dataconvert[i].condition = "pending";
          }
        }
      }
      if (!boxPembayaranReport.isOpen) boxPembayaranReport = await Hive.openBox("BoxPembayaranReport");
      await boxPembayaranReport.delete(key);
      await boxPembayaranReport.put(key, tojsondata(dataconvert));
    }

    await closebox();
  }

  tojsondata(List<ReportPembayaranModel> listreport) {
    List<Map<String, dynamic>> listreportmap = listreport.map((clist) {
      var _pdata = [];
      for (var i = 0; i < clist.paymentList.length; i++) {
        _pdata.add({
          'jenis': clist.paymentList[i].jenis,
          'nomor': clist.paymentList[i].nomor,
          'tipe': clist.paymentList[i].tipe,
          'jatuhtempo': clist.paymentList[i].jatuhtempo,
          'value': clist.paymentList[i].value
        });
      }
      return {
        'condition': clist.condition,
        'id': clist.id,
        'total': clist.total,
        'tanggal': clist.tanggal,
        'waktu': clist.waktu,
        'listpayment': _pdata
      };
    }).toList();
    var datamerge = {"data": listreportmap};
    return jsonEncode(datamerge);
  }

  getlistvendor() async {
    var keys = await getListKey('vendor');
    if (keys.isEmpty){
      return;
    }
    await openmastervendorbox('open');
    for (var i = 0; i < keys.length; i++) {
      var datavendor = await mastervendorbox.get(keys[i]);
      for (var i = 0; i < datavendor.length; i++) {
        print(datavendor[i].name.toString());
        int isfound = vendorlist.indexWhere((element) => element.name.toLowerCase() == datavendor[i].name.toString().toLowerCase());
        if(isfound == -1){
          vendorlist.add(datavendor[i]);
        }
      }
    }
    await openmastervendorbox('close');
    for (var i = 0; i < vendorlist.length; i++) {
      await processfile(true, vendorlist[i].name);
    }
  }

  processfile(bool download,String vendor) async {
    //download not using await because efficiency time for parallel download
    String branchuser = "";
    String warnauser = "";
    String areauser = "";
    await openbranchinfobox();
    var databranch = await branchinfobox.get(await Utils().getParameterData("sales"));
    try {
      branchuser = databranch[0]['branch'];
      warnauser = databranch[0]['color'];
      areauser = databranch[0]['area'];
    // ignore: empty_catches
    } catch (e) {
      
    }
    branchinfobox.close();

    if (await File('$productdir/${vendor.toLowerCase()}/$informasiconfig').exists()) {
        var res = await File('$productdir/${vendor.toLowerCase()}/$informasiconfig').readAsString();
        var ls = const LineSplitter();
        var tlist = ls.convert(res);
        for (var i = 0; i < tlist.length; i++) {
          var undollar = tlist[i].split('\$');
          var unpipelined = undollar[0].split("|");
          if(unpipelined[0] == AppConfig().forall){
            //untuk all cabang
            isthereanyperiod(undollar,download,vendor);
          } else if(unpipelined[0] == AppConfig().forbranch){
              //untuk cabang tertentu
              for (var j = 1; j < unpipelined.length; j++) {
                if(unpipelined[j] == branchuser){
                  isthereanyperiod(undollar,download,vendor);
                }
              }
          } else if(unpipelined[0] == AppConfig().forcolor){
              //untuk cabang dengan warna tertentu
              for (var j = 1; j < unpipelined.length; j++) {
                if(unpipelined[j] == warnauser){
                  isthereanyperiod(undollar,download,vendor);
                }
              }  
          } else if(unpipelined[0] == AppConfig().forarea){
              //untuk cabang dengan area tertentu
              for (var j = 1; j < unpipelined.length; j++) {
                if(unpipelined[j] == areauser){
                  isthereanyperiod(undollar,download,vendor);
                }
              }
          }
        }
      }
  }

  isthereanyperiod(List<String> stringdata,bool download, String vendor){
    var filedir = stringdata[1];
    if(stringdata.length == 2){
      //tanpa periode
      if(download){
        downloadusingdir(filedir,vendor);
      }
    } else if (stringdata.length == 3){
      //terdapat periode
      if(Utils().isinperiod(stringdata[2])){
        if(download){
          downloadusingdir(filedir,vendor);
        }
      }
    }
  }

  downloadusingdir(String directoryfile,String vendor) async {
    var pathh = directoryfile.split('/');
    var dir = "";
    for (var i = 0; i < pathh.length - 1; i++) {
      dir =  "$dir/${pathh[i]}";
    }
    var fname = pathh[pathh.length - 1];
    await ApiClient().downloadfiles(dir, fname,vendor);
  }
  //end taking order vendor section
}
