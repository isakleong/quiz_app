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
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/models/servicebox.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';
import '../models/apiresponse.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/detailproductdata.dart';
import '../models/module.dart';
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

  Timer.periodic(const Duration(minutes: 1), (timer) async {
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
  late Box boxpostpenjualan;
  late Box boxreportpenjualan;
  late Box vendorBox;
  List<Vendor> vendorlist = [];
  
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

  //taking order vendor section
  getPendingData() async {
    print("trying to get pending data");
    await getBox();
    print("finish get box");
    List<dynamic> keys = await getListKey();
    print("finish get key");
    await closebox();
    if(keys.isNotEmpty){
    print("key not empty");
      for (var m = 0; m < keys.length; m++) {
        await sendPendingData(keys[m]);
      }
    }
  }

  sendPendingData(String keybox) async {
    print("send pending data for key $keybox");
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
      // for (var i = 0; i < listpost.length; i++) {
      //   await postDataOrder(listpost[i].dataList,salesid,cust,keybox,vendorurl);
      // }
      await postDataOrderAll(listpost, salesid, cust, keybox, vendorurl);
    }
  }

  getListKey() async {
      List<dynamic> keys = boxpostpenjualan.keys.toList();
      return keys;
  }

  getBox() async {
    try {
      await hiveInitializer();
      try {
        vendorBox = await Hive.openBox('vendorBox');
        boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
        boxreportpenjualan = await Hive.openBox('penjualanReport');
      } catch (e) {
      }
    } catch (e) {
      try {
        vendorBox = await Hive.openBox('vendorBox');
        boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
        boxreportpenjualan = await Hive.openBox('penjualanReport');
      } catch (err) {
      }
    }
  }

  closebox(){
    try {
        vendorBox.close();
        boxpostpenjualan.close();
        boxreportpenjualan.close();
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
        await getBox();

        var _datareportpenjualan = await boxreportpenjualan.get(key);
        var inc = 0;
        final url = Uri.parse('${vendorurl}sales-orders/store');
        final request = http.MultipartRequest('POST', url);
        for (var i = 0; i < data.length; i++) {
          for (var j = 0; j < data[i].dataList.length; j++) {
              if (checkTimeDifference(data[i].dataList[j]['orderDate'])){
                    request.fields['data[$inc][extDocId]'] = data[i].dataList[j]['extDocId'];
                    request.fields['data[$inc][orderDate]'] = data[i].dataList[j]['orderDate'];
                    request.fields['data[$inc][customerNo]'] = data[i].dataList[j]['customerNo'];
                    request.fields['data[$inc][lineNo]'] = data[i].dataList[j]['lineNo'];
                    request.fields['data[$inc][itemNo]'] = data[i].dataList[j]['itemNo'];
                    request.fields['data[$inc][qty]'] = data[i].dataList[j]['qty'];
                    request.fields['data[$inc][note]'] = data[i].dataList[j]['note'];
                    request.fields['data[$inc][shipTo]'] = data[i].dataList[j]['shipTo'];
                    request.fields['data[$inc][salesPersonCode]'] = data[i].dataList[j]['salesPersonCode'];
                    inc = inc + 1;
              } else {
                break;
              }
          }
        }
        
        try {
          // print(request.fields['data[0][extDocId]']);
          final response = await request.send();
          final responseString = await response.stream.bytesToString();
          print(responseString);

          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(responseString);
            if(jsonResponse["success"] == true){
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
                  if(data[i].dataList[0]['extDocId'] == _datareportpenjualan[k].id && _datareportpenjualan[i].condition != "success"){
                    postadatanew.add(data[i]);
                    break;
                  }
                }
                // print(data[i].dataList[0]['extDocId']);
              }
              await boxpostpenjualan.delete(key);
              if(postadatanew.isNotEmpty){
                await boxpostpenjualan.put(key,postadatanew);
              }
              await boxreportpenjualan.delete(key);
              await boxreportpenjualan.put(key,_datareportpenjualan);
            } else {
                for (var i = 0; i < data.length; i++) {
                  for (var j = 0; j <= inc; j++) {
                      if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                          _datareportpenjualan[i].condition = "pending";
                      }
                  }
              }
              await boxreportpenjualan.delete(key);
              await boxreportpenjualan.put(key,_datareportpenjualan);
            }
          } else {
             for (var i = 0; i < data.length; i++) {
                for (var j = 0; j <= inc; j++) {
                    if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                        _datareportpenjualan[i].condition = "pending";
                    }
                }
            }
            await boxreportpenjualan.delete(key);
            await boxreportpenjualan.put(key,_datareportpenjualan);
            print(responseString);
          }
        } on SocketException {
             for (var i = 0; i < data.length; i++) {
                for (var j = 0; j <= inc; j++) {
                    if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                        _datareportpenjualan[i].condition = "pending";
                    }
                }
            }
            await boxreportpenjualan.delete(key);
            await boxreportpenjualan.put(key,_datareportpenjualan);
            print("socketexception");
        } catch (e) {
             for (var i = 0; i < data.length; i++) {
                for (var j = 0; j <= inc; j++) {
                    if ( _datareportpenjualan[i].id == request.fields['data[$j][extDocId]']){
                        _datareportpenjualan[i].condition = "pending";
                    }
                }
            }
            await boxreportpenjualan.delete(key);
            await boxreportpenjualan.put(key,_datareportpenjualan);
            print("$e abnormal ");
        } 
        await closebox();
  }

  Future<void> postDataOrder(List<Map<String, dynamic>> data ,String salesid,String custid ,String key,String vendorurl) async {
    print("send to api");
    await getBox();

    String noorder = data[0]['extDocId'];

    var listpostbox = await boxpostpenjualan.get(key);
    List<PenjualanPostModel> listpost = [];
    for (var i = 0; i < listpostbox.length; i++) {
      listpost.add(listpostbox[i]);
    }

    var _datareportpenjualan = await boxreportpenjualan.get(key);
    var idx = -1;
    if(_datareportpenjualan != null){
      List<ReportPenjualanModel> _listreportpenjualan = [];
        for (var i = 0; i < _datareportpenjualan.length; i++) {
          _listreportpenjualan.add(_datareportpenjualan[i]);
        }
       idx = _listreportpenjualan.indexWhere((element) => element.id == noorder);
    }
    
    var idxpost = -1;
    for (var i = 0; i < listpost.length; i++) {
      if(listpost[i].dataList[0]['extDocId'] == noorder){
          idxpost = i;
          break;
      }
    }

    final url = Uri.parse('${vendorurl}sales-orders/store');
    final request = http.MultipartRequest('POST', url);
      for (var i = 0; i < data.length; i++) {
            request.fields['data[$i][extDocId]'] = data[i]['extDocId'];
            request.fields['data[$i][orderDate]'] = data[i]['orderDate'];
            request.fields['data[$i][customerNo]'] = data[i]['customerNo'];
            request.fields['data[$i][lineNo]'] = data[i]['lineNo'];
            request.fields['data[$i][itemNo]'] = data[i]['itemNo'];
            request.fields['data[$i][qty]'] = data[i]['qty'];
            request.fields['data[$i][note]'] = data[i]['note'];
            request.fields['data[$i][shipTo]'] = data[i]['shipTo'];
            request.fields['data[$i][salesPersonCode]'] = data[i]['salesPersonCode'];
      }
      
      try {
        final response = await request.send();
        final responseString = await response.stream.bytesToString();
        print(responseString);

        if (response.statusCode == 200) {
          if(idx != -1){
            _datareportpenjualan[idx].condition = "success";
          }
          listpost.removeAt(idxpost);
          await boxpostpenjualan.delete(key);
          if(listpost.isNotEmpty) {
            print("isi list post ulang");
            await boxpostpenjualan.put(key,listpost);
          }
          await boxreportpenjualan.delete(key);
          print("isi ulang data report penjualan");
          await boxreportpenjualan.put(key,_datareportpenjualan);
          print(responseString);

        } else {
          if(idx != -1){
            _datareportpenjualan[idx].condition = "error";
          }
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key,_datareportpenjualan);
          print(responseString);
        }
      } on SocketException {
          if(idx != -1){
            _datareportpenjualan[idx].condition = "pending";
          }
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key,_datareportpenjualan);
          print("socketexception");
      } catch (e) {
          if(idx != -1){
            _datareportpenjualan[idx].condition = "pending";
          }
          await boxreportpenjualan.delete(key);
          await boxreportpenjualan.put(key,_datareportpenjualan);
          print("$e abnormal ");
      } 
      await closebox();
  }
  //end taking order vendor section
}