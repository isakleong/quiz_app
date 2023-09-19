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
import 'package:sfa_tools/models/customer.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/servicebox.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';
import '../models/apiresponse.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/detailproductdata.dart';
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

  Timer.periodic(const Duration(hours: 1), (timer) async {
    await Backgroundservicecontroller().cekQuiz();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "SFA Tools Service",
          content: "Updated at ${DateTime.now()}",
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
          content: "Updated at ${DateTime.now()}",
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

  Timer.periodic(const Duration(minutes: 3), (timer) async {
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

class Backgroundservicecontroller {
  
  Future hiveInitializer() async {
    Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(ModuleAdapter());
    Hive.registerAdapter(QuizAdapter());
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
          await writeText("${status};${_salesidVendor.split(';')[0]};${DateTime.now()};${DateTime.now()}");
        } else {
          await writeText(";;${DateTime.now()};");
        }
      } else {
        await writeText(";;${DateTime.now()};");
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

  retrySubmitQuiz() async {
    try {
      var retryStatus = await accessBox("read", AppConfig.keyStatusBoxSubmitQuiz, "", box: AppConfig.boxSubmitQuiz);
      if(retryStatus != null && retryStatus.value == "true") {
        var bodyData = await accessBox("read", AppConfig.keyDataBoxSubmitQuiz, "", box: AppConfig.boxSubmitQuiz);

        var connTest = await ApiClient().checkConnection();
        var arrConnTest = connTest.split("|");
        bool isConnected = arrConnTest[0] == 'true';
        String urlAPI = arrConnTest[1];

        if(isConnected) {
          var resultSubmit = await ApiClient().postData(
            urlAPI,
            '/quiz/submit',
            Utils.encryptData(bodyData.value),
            Options(headers: {HttpHeaders.contentTypeHeader: "application/json"})
          );

          if(resultSubmit == "success") {
            await Backgroundservicecontroller().accessBox("create", AppConfig.keyStatusBoxSubmitQuiz, "false", box: AppConfig.boxSubmitQuiz);

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
    } catch(e) {
      return;
    }
  }

  cekQuiz() async {
    if (await isSameSalesid()) {
      try {
        String _filequiz = await readFileQuiz();
        DateTime now = DateTime.now();
        DateTime datetimefilequiz = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(_filequiz.split(";")[3]);
        Duration difference = datetimefilequiz.difference(now);
        var dataBox = await accessBox("read", "retryApi", "");
        if (difference.inDays >= 1 || (dataBox != null && dataBox.value == "1")) {
          //sudah melewati 1 hari
          String status = await getLatestStatusQuiz(_filequiz.split(";")[1]);
          if (status != "err") {
            //status;salesid;service time;last hit api time
            await accessBox("create", "retryApi", "0");
            await writeText("${status};${_filequiz.split(";")[1]};${DateTime.now()};${DateTime.now()}");
          } else if (status == "err") {
            await writeText("${status};${_filequiz.split(";")[1]};${DateTime.now()};${_filequiz.split(";")[3]}");
          }
        } else {
          await writeText("${_filequiz.split(";")[0]};${_filequiz.split(";")[1]};${DateTime.now()};${_filequiz.split(";")[3]}");
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

      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if(isConnected) {
        var req = await ApiClient().getData(urlAPI, "/quiz/status?sales_id=$encryptedParam");
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

  accessBox(String type, String key ,String value, {String box='serviceBox'}) async {
    try {
      await hiveInitializer();
    } catch (e) {
      // return;
    }
    var mybox = await Hive.openBox<ServiceBox>(box);
    if(type == "read"){
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
  late Box boxpostpenjualan;
  late Box boxreportpenjualan;
  late Box vendorBox;
  late Box postpembayaranbox;
  late Box boxPembayaranReport;
  List<Vendor> vendorlist = [];

  Future<void> createLogTes(String content) async {
    bool allowWriteLog = true; // Change to true to enable log writing
    final directoryPath = '/storage/emulated/0/TKTW/sfalog';
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final filePath = '$directoryPath/$formattedDate.txt';

    if (allowWriteLog) {
      try {
        final directory = Directory(directoryPath);

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Delete log files older than 7 days
        final sevenDaysAgo = currentDate.subtract(Duration(days: 7));
        await for (var entity in directory.list()) {
          if (entity is File) {
            final fileDateStr = DateFormat('yyyy-MM-dd').format(entity.lastModifiedSync());
            final fileDate = DateTime.parse(fileDateStr);
            if (fileDate.isBefore(sevenDaysAgo) || fileDate.isAtSameMomentAs(sevenDaysAgo)) {
              await entity.delete();
              print('Deleted old log file: ${entity.path}');
            }
          }
        }

        final file = File(filePath);

        if (!await file.exists()) {
          await file.create();
        }

        await file.writeAsString("$content\n", mode: FileMode.append);

        print('File written successfully.');
      } catch (e) {
        print('Error writing to file: $e');
      }
    }
  }

  getPendingData() async {
      DateTime currentDateTime = DateTime.now();
      String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(currentDateTime);

      //pending penjualan
      await createLogTes("trying to get pending data at $date");
      await getBox();
      await createLogTes("finish get box");
      List<dynamic> keys = await getListKey('penjualan');
      await createLogTes("finish get key");
      await closebox();
      if(keys.isNotEmpty){
        await createLogTes("key not empty");
        for (var m = 0; m < keys.length; m++) {
          await sendPendingData(keys[m]);
        }
      }

      //pending pembayaran **api not ready**
      // await getBox();
      // print("get list key pembayran");
      // List<dynamic> keyspembayaran = await getListKey('pembayaran');
      // await closebox();
      // if(keyspembayaran.isNotEmpty){
      // print("keyspembayaran is not empty");
      //   for (var m = 0; m < keyspembayaran.length; m++) {
      //     await sendPendingDatapembayaran(keyspembayaran[m]);
      //   }
      // }

      //clear report penjualan
      await getBox();
      List<dynamic> keysreport = await getListKeyReport('penjualan');
      await closebox();
      if(keysreport.isNotEmpty){
        for (var m = 0; m < keysreport.length; m++) {
          await removeoldreport(keysreport[m]);
         }
      }

      //clear report pembayaran
      await getBox();
      List<dynamic> keysreportpembayaran = await getListKeyReport('pembayaran');
      await closebox();
      if(keysreportpembayaran.isNotEmpty){
        for (var m = 0; m < keysreportpembayaran.length; m++) {
          await removeoldreportpembayaran(keysreportpembayaran[m]);
         }
      }
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
    if (listpostbox != null){
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
    if (listpostbox != null){
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
        if(Utils().isDateNotToday(Utils().formatDate(datareportpenjualan[i].tanggal)) && datareportpenjualan[i].condition == "success"){
        } else {
          listReportPenjualan.add(datareportpenjualan[i]);
        }
      }
      await boxreportpenjualan.delete(keybox);
      await boxreportpenjualan.put(keybox,listReportPenjualan);
      await closebox();
  }

  removeoldreportpembayaran(String keybox) async {
      await getBox();
      var datapembayaranlist = [];
      var datareportpembayaran = await boxPembayaranReport.get(keybox);
      var converteddatapembayaran = json.decode(datareportpembayaran);
      for (var i = 0; i < converteddatapembayaran['data'].length; i++) {
        if(Utils().isDateNotToday(Utils().formatDate(converteddatapembayaran['data'][i]['tanggal'])) && converteddatapembayaran['data'][i]['condition'] == "success"){
        } else {
            datapembayaranlist.add(converteddatapembayaran['data'][i]);
        }
      }
      var joinedjson = {
         "data" : datapembayaranlist
      };
      await boxPembayaranReport.delete(keybox);
      await boxPembayaranReport.put(keybox,jsonEncode(joinedjson));
      await closebox();

  }

  getListKey(String jenis) async {
    if(jenis == 'penjualan'){
      List<dynamic> keys = boxpostpenjualan.keys.toList();
      return keys;
    } else if (jenis == 'pembayaran') {
      List<dynamic> keys = postpembayaranbox.keys.toList();
      return keys;
    }
  }

  getListKeyReport(String jenis) async {
    if(jenis == 'penjualan'){
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
        vendorBox = await Hive.openBox('vendorBox');
        boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
        boxreportpenjualan = await Hive.openBox('penjualanReport');
        postpembayaranbox = await Hive.openBox("postpembayaranbox");
        boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
      } catch (e) {
      }
    } catch (e) {
      try {
        vendorBox = await Hive.openBox('vendorBox');
        boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
        boxreportpenjualan = await Hive.openBox('penjualanReport');
        postpembayaranbox = await Hive.openBox("postpembayaranbox");
        boxPembayaranReport = await Hive.openBox('BoxPembayaranReport');
      } catch (err) {
      }
    }
  }

  closebox(){
    try {
        vendorBox.close();
        boxpostpenjualan.close();
        boxreportpenjualan.close();
        postpembayaranbox.close();
        boxPembayaranReport.close();
    } catch (e) {
      
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

  postDataOrderAll(List<PenjualanPostModel> data ,String salesid,String custid ,String key,String vendorurl) async {
        await createLogTes("on post Data order All");
        await getBox();
        var _datareportpenjualan = await boxreportpenjualan.get(key);
        var inc = 0;
        final url = Uri.parse('${vendorurl}sales-orders/store');
        final request = http.MultipartRequest('POST', url);
        for (var i = 0; i < data.length; i++) {
          for (var j = 0; j < data[i].dataList.length; j++) {
            var ismorethan1minutes = checkTimeDifference(data[i].dataList[j]['orderDate']);
            await createLogTes("${"list no on loop " + data[i].dataList[j]['extDocId']} $ismorethan1minutes ${data[i].dataList[j]['orderDate']}");
              if (ismorethan1minutes){
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
                    inc = inc + 1;
              } else {
                break;
              }
          }
        }
        
        try {
          await createLogTes(request.fields.toString());
          // print(request.fields);
          final response = await request.send();
          final responseString = await response.stream.bytesToString();
          // print(responseString);
          await createLogTes(responseString);

          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(responseString);
            if(jsonResponse["success"] == true){
                // print("response true");
                var loopdatalength = jsonResponse['data'].length;
                for (var k = 0; k < loopdatalength; k++) {
                  for (var i = 0; i < _datareportpenjualan.length; i++) {
                      if ( _datareportpenjualan[i].id == jsonResponse['data'][k]['extDocId'] && jsonResponse['data'][k]['success'] == true){
                        _datareportpenjualan[i].condition = "success";
                      } else if (_datareportpenjualan[i].id == jsonResponse['data'][k]['extDocId'] && jsonResponse['data'][k]['success'] == false){
                          var listerror = jsonResponse['data'][k]['errors'].length;
                          for (var m = 0; m < listerror; m++) {
                            if(jsonResponse['data'][i]['errors'][m]['code'] == AppConfig().orderalreadyexistvendor){
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
                    if(data[i].dataList[0]['extDocId'] == _datareportpenjualan[k].id && _datareportpenjualan[k].condition != "success"){
                      postadatanew.add(data[i]);
                      break;
                    }
                  }
                }

                await boxpostpenjualan.delete(key);
                if(postadatanew.isNotEmpty){
                  await boxpostpenjualan.put(key,postadatanew);
                }
                await boxreportpenjualan.delete(key);
                await boxreportpenjualan.put(key,_datareportpenjualan);
            } else {
                for (var i = 0; i < _datareportpenjualan.length; i++) {
                  for (var j = 0; j <= inc; j++) {
                      if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                          _datareportpenjualan[i].condition = "pending";
                      }
                  }
              }
              await createLogTes("response not true");
              await boxreportpenjualan.delete(key);
              await boxreportpenjualan.put(key,_datareportpenjualan);
            }
          } else {
             for (var i = 0; i < _datareportpenjualan.length; i++) {
                for (var j = 0; j <= inc; j++) {
                    if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                        _datareportpenjualan[i].condition = "pending";
                    }
                }
            }
            await createLogTes("response not 200");
            await boxreportpenjualan.delete(key);
            await boxreportpenjualan.put(key,_datareportpenjualan);
            // print(responseString);
          }
        } on SocketException {
            await createLogTes("socketexception");
             for (var i = 0; i < _datareportpenjualan.length; i++) {
                for (var j = 0; j <= inc; j++) {
                    if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                        _datareportpenjualan[i].condition = "pending";
                    }
                }
            }
            await boxreportpenjualan.delete(key);
            await boxreportpenjualan.put(key,_datareportpenjualan);
            // print("socketexception");
        } catch (e) {
            await createLogTes("$e abnormal");
             for (var i = 0; i < _datareportpenjualan.length; i++) {
                for (var j = 0; j <= inc; j++) {
                    if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                        _datareportpenjualan[i].condition = "pending";
                    }
                }
            }
            await boxreportpenjualan.delete(key);
            await boxreportpenjualan.put(key,_datareportpenjualan);
            // print("$e abnormal ");
        }
        await closebox();
  }
  
  postDataPembayaranAll(List<PenjualanPostModel> data ,String salesid,String custid ,String key,String vendorurl) async {
        await createLogTes("on postDataPembayaranAll");
        await getBox();
        var _datareportpembayaran = await boxPembayaranReport.get(key);

        //create post data
        var inc = 0;
        final url = Uri.parse('${vendorurl}payments/store');
        final request = http.MultipartRequest('POST', url);
        var _datapostpembayaran = await postpembayaranbox.get(key);
        List<PenjualanPostModel> _postdata = <PenjualanPostModel>[];
        for (var i = 0; i < _datapostpembayaran.length; i++) {
          _postdata.add(_datapostpembayaran[i]);
        }
        for (var i = 0; i < _postdata.length; i++) {
          // print("ini post data " + _postdata[i].toString());
          for (var j = 0; j < _postdata[i].dataList.length; j++) {
            // print("ini isi detail ${_postdata[i].dataList[j]['extDocId']}");
            request.fields['data[$inc][extDocId]'] = _postdata[i].dataList[j]['extDocId'];
            request.fields['data[$inc][customerNo]'] = _postdata[i].dataList[j]['customerNo'];
            request.fields['data[$inc][amount]'] = _postdata[i].dataList[j]['amount'].toString();
            request.fields['data[$inc][salespersonCode]'] = _postdata[i].dataList[j]['salespersonCode'];
            request.fields['data[$inc][entryDate]'] = _postdata[i].dataList[j]['entryDate'];
            request.fields['data[$inc][bankId]'] = _postdata[i].dataList[j]['bankId'].toString();
            request.fields['data[$inc][paymentMethodId]'] = _postdata[i].dataList[j]['paymentMethodId'].toString();
            request.fields['data[$inc][bankName]'] = _postdata[i].dataList[j]['bankName'];
            request.fields['data[$inc][dueDate]'] = _postdata[i].dataList[j]['dueDate'];
            request.fields['data[$inc][serialNum]'] = _postdata[i].dataList[j]['serialNum'];
            inc = inc + 1;
          }
        }
        print(request.fields.toString());
        try {
          await createLogTes(request.fields.toString());
          // print(request.fields);
          final response = await request.send();
          final responseString = await response.stream.bytesToString();
          // print(responseString);
          await createLogTes(responseString);

          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(responseString);
            print(jsonResponse);
            if(jsonResponse["success"] == true){
                // print("response true");
                var loopdatalength = jsonResponse['data'].length;
                // for (var k = 0; k < loopdatalength; k++) {
                //   for (var i = 0; i < _datareportpenjualan.length; i++) {
                //       if ( _datareportpenjualan[i].id == jsonResponse['data'][k]['extDocId'] && jsonResponse['data'][k]['success'] == true){
                //         _datareportpenjualan[i].condition = "success";
                //       } else if (_datareportpenjualan[i].id == jsonResponse['data'][k]['extDocId'] && jsonResponse['data'][k]['success'] == false){
                //           var listerror = jsonResponse['data'][k]['errors'].length;
                //           for (var m = 0; m < listerror; m++) {
                //             if(jsonResponse['data'][i]['errors'][m]['code'] == AppConfig().orderalreadyexistvendor){
                //               _datareportpenjualan[i].condition = "success";
                //               break;
                //             } else {
                //               _datareportpenjualan[i].condition = "pending";
                //             }
                //           }
                //       }
                //   }
                // }
                
                // List<PenjualanPostModel> postadatanew = [];
                // for (var i = 0; i < data.length; i++) {
                //   for (var k = 0; k < _datareportpenjualan.length; k++) {
                //     if(data[i].dataList[0]['extDocId'] == _datareportpenjualan[k].id && _datareportpenjualan[k].condition != "success"){
                //       postadatanew.add(data[i]);
                //       break;
                //     }
                //   }
                // }

                // await boxpostpenjualan.delete(key);
                // if(postadatanew.isNotEmpty){
                //   await boxpostpenjualan.put(key,postadatanew);
                // }
                // await boxreportpenjualan.delete(key);
                // await boxreportpenjualan.put(key,_datareportpenjualan);
            } else {
              //   for (var i = 0; i < _datareportpenjualan.length; i++) {
              //     for (var j = 0; j <= inc; j++) {
              //         if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
              //             _datareportpenjualan[i].condition = "pending";
              //         }
              //     }
              // }
              // await createLogTes("response not true");
              // await boxreportpenjualan.delete(key);
              // await boxreportpenjualan.put(key,_datareportpenjualan);
            }
          } else {
            //  for (var i = 0; i < _datareportpenjualan.length; i++) {
            //     for (var j = 0; j <= inc; j++) {
            //         if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
            //             _datareportpenjualan[i].condition = "pending";
            //         }
            //     }
            // }
            // await createLogTes("response not 200");
            // await boxreportpenjualan.delete(key);
            // await boxreportpenjualan.put(key,_datareportpenjualan);
            // print(responseString);
          }
        } on SocketException {
            // await createLogTes("socketexception");
            //  for (var i = 0; i < _datareportpenjualan.length; i++) {
            //     for (var j = 0; j <= inc; j++) {
            //         if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
            //             _datareportpenjualan[i].condition = "pending";
            //         }
            //     }
            // }
            // await boxreportpenjualan.delete(key);
            // await boxreportpenjualan.put(key,_datareportpenjualan);
            // print("socketexception");
        } catch (e) {
            // await createLogTes("$e abnormal");
            //  for (var i = 0; i < _datareportpenjualan.length; i++) {
            //     for (var j = 0; j <= inc; j++) {
            //         if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
            //             _datareportpenjualan[i].condition = "pending";
            //         }
            //     }
            // }
            // await boxreportpenjualan.delete(key);
            // await boxreportpenjualan.put(key,_datareportpenjualan);
            // print("$e abnormal ");
        }

        await closebox();
  }
  
  //end taking order vendor section
}