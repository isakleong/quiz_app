import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/common/route_config.dart';
import 'package:sfa_tools/controllers/background_service_controller.dart';
import 'package:sfa_tools/models/customer.dart';
import 'package:sfa_tools/models/loginmodel.dart';
import 'package:sfa_tools/models/module.dart';
import 'package:sfa_tools/models/vendor.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/dialog.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../models/vendorinfomodel.dart';

class SplashscreenController extends GetxController with StateMixin implements WidgetsBindingObserver {
  var errorMessage = "".obs;
  var isError = false.obs;

  var appName = "".obs;
  var appVersion = "".obs;
  var moduleList = <Module>[].obs;
  var isNeedUpdate = false.obs;

  //permission data
  var cntStoragePermissionDeny = 0.obs;
  var isOpenSettings = false.obs;

  //parameter data
  var salesIdParams = "".obs;
  var customerIdParams = "".obs;
  var isCheckInParams = "".obs;
  
  //about taking order vendor
  RxString selectedVendor = "".obs;
  late Box vendorBox; 
  late Box customerBox; 
  late Box boxpostpenjualan;
  late Box boxreportpenjualan;
  late Box shiptobox;
  late Box tokenbox;
  late Box branchinfobox;
  bool retrypermission = false;

  @override
  void onInit() {
    super.onInit();

    isError(false);
    // Add the controller as an observer when it's initialized
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (isOpenSettings.value) {
        isOpenSettings(false);
        await syncAppsReady('STORAGE');
      } else {
        if (Get.currentRoute.toString() != "/") {
          await Get.deleteAll(force: true);
          // Get.offAndToNamed(RouteName.splashscreen);
          Get.offAllNamed(RouteName.splashscreen);
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    startApp();
  }

  startApp() async {
    if (await getPermissionStatus('STORAGE')) {
      if (await getPermissionStatus('EXTERNAL STORAGE')) {
        //reset permanent deny permission flag
        cntStoragePermissionDeny.value = 0;

        await getParameterData();
        await getModuleData();
      } else {
        await openPermissionRequestDialog('EXTERNAL STORAGE');
      }
    } else {
      await openPermissionRequestDialog('STORAGE');
    }
  }

  openErrorDialog() {
    appsDialog(
        type: "app_error",
        title: Obx(
          () => TextView(
            headings: "H4",
            text: errorMessage.value,
            textAlign: TextAlign.center,
          ),
        ),
        leftBtnMsg: "Ok",
        isAnimated: true,
        leftActionClick: () {
          Get.back();
        });
  }

  Future<bool> getPermissionStatus(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (type == 'STORAGE') {
      if (sdkInt! < 33) {
        status = await Permission.storage.status;
      } else {
        status = await Permission.photos.status;
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (sdkInt! >= 30) {
        status = await Permission.manageExternalStorage.status;
      } else {
        return true;
      }
    }
    return status == PermissionStatus.granted;
  }

  syncAppsReady(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    if (type == 'STORAGE') {
      if (await checkAppsPermission('STORAGE')) {
        if (sdkInt! >= 30) {
          var status = await Permission.manageExternalStorage.status;
          if (status != PermissionStatus.granted) {
            openPermissionRequestDialog('EXTERNAL STORAGE');
          } else {
            await getParameterData();
            await getModuleData();
          }
        } else {
          syncAppsReady('EXTERNAL STORAGE');
        }
      } else {
        openPermissionRequestDialog('STORAGE');
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (await checkAppsPermission('EXTERNAL STORAGE')) {
        await getParameterData();
        await Backgroundservicecontroller().initializeNotifConfiguration();
        await getModuleData();
      } else {
        openPermissionRequestDialog('EXTERNAL STORAGE');
      }
    }
  }

  openPermissionRequestDialog(String type, {bool? actionButton}) async {
    retrypermission = false;

    if (type == 'STORAGE') {
      try {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        appsDialog(
          type: "app_info",
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text:
                      'Mohon bantuannya untuk memberikan izin akses aplikasi dengan menekan tombol ',
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Allow.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins")),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text:
                      'Jika tombol Allow tidak muncul, ikuti langkah berikut:\n ',
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
                  children: <TextSpan>[
                    sdkInt == 30
                        ? const TextSpan(
                            text: '1.  Tekan ',
                            style: TextStyle(fontFamily: "Poppins"),
                            children: [
                                TextSpan(
                                    text: 'Permissions.\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text: '2.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins")),
                                TextSpan(
                                    text: 'Storage.\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text: '3.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins")),
                                TextSpan(
                                    text: 'Allow access to media only.\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text: '4.  Tekan tombol ',
                                    style: TextStyle(fontFamily: "Poppins")),
                                TextSpan(
                                    text: 'Kembali (Back).\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                              ])
                        : sdkInt == 31 || sdkInt == 32
                            ? const TextSpan(
                                text: '1.  Tekan ',
                                style: TextStyle(fontFamily: "Poppins"),
                                children: [
                                    TextSpan(
                                        text: 'Permissions.\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                    TextSpan(
                                        text: '2.  Tekan ',
                                        style:
                                            TextStyle(fontFamily: "Poppins")),
                                    TextSpan(
                                        text: 'Files and Media.\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                    TextSpan(
                                        text: '3.  Tekan ',
                                        style:
                                            TextStyle(fontFamily: "Poppins")),
                                    TextSpan(
                                        text: 'Allow access to media only.\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                    TextSpan(
                                        text: '4.  Tekan tombol ',
                                        style:
                                            TextStyle(fontFamily: "Poppins")),
                                    TextSpan(
                                        text: 'Kembali (Back).\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                  ])
                            : sdkInt! >= 33
                                ? const TextSpan(
                                    text: '1.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins"),
                                    children: [
                                        TextSpan(
                                            text: 'Permissions.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '2.  Tekan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Photos and videos.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '3.  Tekan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Allow.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '4.  Tekan tombol ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Kembali (Back).\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                      ])
                                :
                                //below android 30 (should not happen because all device installed in office already os 11 or higher)
                                const TextSpan(
                                    text: '1.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins"),
                                    children: [
                                        TextSpan(
                                            text: 'Permissions.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '2.  Tekan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Storage.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '3.  Aktifkan atau Hidupkan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Storage.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '4.  Tekan tombol ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Kembali (Back).\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                      ])
                  ],
                ),
              ),
            ],
          ),
          isAnimated: true,
          leftBtnMsg: "Ok",
          leftActionClick: () async {
            if (cntStoragePermissionDeny > 0) {
              Get.back();
              await openAppSettings();
              isOpenSettings(true);
              // await syncAppsReady('STORAGE');
            } else {
              Get.back();
              await syncAppsReady('STORAGE');
            }
          });
      } catch (e) {
        retrypermission = true;
        errorMessage("gagal meminta perizinan penyimpanan ! ${e.toString()}");
        openErrorDialog();
        isError(true);
        change(null, status: RxStatus.error("gagal meminta perizinan penyimpanan ! ${e.toString()}"));
      } 
    } else if (type == 'EXTERNAL STORAGE') {
      try {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        appsDialog(
          type: "",
          title: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text:
                  'Mohon bantuannya untuk memberikan izin akses aplikasi dengan ',
              style: TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
              children: <TextSpan>[
                TextSpan(
                    text: 'mengaktifkan ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                TextSpan(
                    text: 'aplikasi SFA Tools seperti pada gambar.',
                    style: TextStyle(fontFamily: "Poppins")),
              ],
            ),
          ),
          isAnimated: false,
          iconAsset: sdkInt! < 31
              ? 'assets/images/bg-permission-os11.jpg'
              : 'assets/images/bg-permission-os13.jpg',
          leftBtnMsg: "Ok",
          leftActionClick: () async {
            Get.back();
            await syncAppsReady('EXTERNAL STORAGE');
          });
      } catch (e) {
        retrypermission = true;
        errorMessage("gagal meminta perizinan penyimpanan eksternal ! ${e.toString()}");
        openErrorDialog();
        isError(true);
        change(null, status: RxStatus.error("gagal meminta perizinan penyimpanan eksternal ! ${e.toString()}"));
      }
    }
  }

  Future<bool> checkAppsPermission(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (type == 'STORAGE') {
      if (sdkInt! < 33) {
        if (cntStoragePermissionDeny.value > 0) {
          status = await Permission.storage.status;
        } else {
          status = await Permission.storage.request();
        }
      } else {
        //if you need the access for both photos and videos,
        //you can use either Permission.photos or Permission.video, you don’t need both of them,
        //because in Granular Media the access is granted for both media types.
        if (cntStoragePermissionDeny.value > 0) {
          var statusPhoto = await Permission.photos.status;
          var statusVideo = await Permission.videos.status;
          if (statusPhoto == PermissionStatus.granted ||
              statusVideo == PermissionStatus.granted) {
            status = PermissionStatus.granted;
          }
        } else {
          status = await Permission.photos.request();
        }
      }
    } else if (type == 'INSTALLS PACKAGES') {
      if (sdkInt! >= 26) {
        status = await Permission.requestInstallPackages.request();
      } else {
        return true;
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (sdkInt! >= 30) {
        status = await Permission.manageExternalStorage.request();
      } else {
        return true;
      }
    }

    if (status != PermissionStatus.granted) {
      if (status == PermissionStatus.denied) {
        cntStoragePermissionDeny.value++;
        return status == PermissionStatus.granted;
      } else if (status == PermissionStatus.permanentlyDenied) {
        if (type == 'STORAGE') {
          status = await Permission.storage.status;
        } else if (type == 'EXTERNAL STORAGE') {
          status = await Permission.manageExternalStorage.status;
        }

        cntStoragePermissionDeny.value++;

        return status == PermissionStatus.granted;
      }
    }
    return status == PermissionStatus.granted;
  }

  getModuleData() async {
    isError(false);
    change(null, status: RxStatus.loading());

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if (isConnected) {
      // print("isconnected");
      moduleList.clear();

      if (salesIdParams.value != "") {
        try {
          final encryptedParam = await Utils.encryptData(salesIdParams.value);

          final result = await ApiClient().getData(urlAPI, "/datadev?sales_id=$encryptedParam");
          var data = jsonDecode(result.toString());
          data["AppModule"].map((item) {
            moduleList.add(Module.from(item));
          }).toList();

          var moduleBox = await Hive.openBox<Module>('moduleBox');
          await moduleBox.clear();
          await moduleBox.addAll(moduleList);

          if(!Hive.isBoxOpen("BranchInfoBox")){
            branchinfobox = await Hive.openBox('BranchInfoBox');
          }
          await branchinfobox.delete(salesIdParams.value);
          await branchinfobox.put(salesIdParams.value, data['BranchInfo']);
          await branchinfobox.close();
          // print(moduleList.length);
          
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String currentVersion = packageInfo.version;
          appVersion.value = currentVersion;

          // NOT USED ANYMORE (BECAUSE AUTO UPDATE FROM SFA)
          // await checkVersion(data["AppVersion"]);
          // if (isNeedUpdate.value) {
          //   change(null, status: RxStatus.success());
          //   appsDialog(
          //     type: "app_info",
          //     title: TextView(
          //       headings: "H4",
          //       text: "Terdapat versi aplikasi yang lebih baru.\n\nIkuti langkah-langkah berikut :\n1. Tekan OK untuk kembali ke aplikasi SFA.\n2. Tekan menu Pengaturan.\n3. Tekan tombol Unduh Aplikasi ${appName.value}.\n4. Tunggu hingga proses update selesai.",
          //       textAlign: TextAlign.start,
          //     ),
          //     leftBtnMsg: "ok",
          //     isAnimated: true,
          //     leftActionClick: () {
          //       Get.back();
          //       SystemNavigator.pop();
          //     }
          //   );
          // }
          var idx = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order"));
          if(idx != -1){
            await getBox();
            var datacustomerbox = await customerBox.get(customerIdParams.value);
            var datatoken = await tokenbox.get(salesIdParams.value);
            if(datatoken == null){
              await loginapivendor();
            }
            await closebox();
            if(datacustomerbox!= null){
              Customer custdata = datacustomerbox;
              if(!Utils().isDateNotToday(Utils().formatDate(custdata.timestamp))){
                await checkofflinevendor();
                await moduleBox.clear();
                moduleBox.addAll(moduleList);
              } else {
                await getVendor();
              }
            } else {
              await getVendor();
            }
          }
          await postTrackingVersion();
        } catch (e) {
          //print("ctc");
          errorMessage(e.toString());
          openErrorDialog();
          isError(true);
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        errorMessage(Message.errorParameterData);
        openErrorDialog();
        isError(true);
        change(null, status: RxStatus.error(errorMessage.value));
      }
    } else {
      var moduleBox = await Hive.openBox<Module>('moduleBox');
      if (moduleBox.length > 0) {
        // print("first if");
        moduleList.clear();
        moduleList.addAll(moduleBox.values);
        // print("before ${moduleBox.length} , ${moduleList.length}");

        await checkofflinevendor();

        await moduleBox.clear();
        moduleBox.addAll(moduleList);

        if(moduleBox.length > 0){
            // print("second if");
            change(null, status: RxStatus.success());
            Get.offAndToNamed(RouteName.homepage);
        } else {
            // print("second else");
            errorMessage(Message.errorConnection);
            openErrorDialog();
            isError(true);
            change(null, status: RxStatus.error(errorMessage.value));
        }
       
      } else {
        // print(" else");
        errorMessage(Message.errorConnection);
        openErrorDialog();
        isError(true);
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  checkofflinevendor() async {
    await getBox();
    var datavendor = vendorBox.get("${salesIdParams.value}|${customerIdParams.value}");
    var listindexdelete = [];
    for (var i = 0; i < moduleList.length; i++) {
        if(moduleList[i].moduleID.contains("Taking order ")){
          if(listindexdelete.isEmpty){
            listindexdelete.add(i);
          } else {
            listindexdelete.add(i-1);
          }
        }
    }
    var vendorversion = "";
    var vendororder = "";
    for (var i = 0; i < listindexdelete.length; i++) {
      if(vendorversion == ""){
        vendorversion = moduleList[i].version;
        vendororder = moduleList[i].orderNumber;
      }
      moduleList.removeAt(listindexdelete[i]);
    }

    if (datavendor != null){
      List<Vendor> vendorlist = <Vendor>[];
      for (var i = 0; i < datavendor.length; i++) {
          vendorlist.add(datavendor[i]);
      }
      for (var i = 0; i < vendorlist.length; i++) {
          moduleList.add(Module(moduleID: "Taking order ${vendorlist[i].name}", version: vendorversion, orderNumber: vendororder));
      }
    }
    
    moduleList.removeWhere((element) => element.moduleID.contains("Taking Order Vendor"));
    await closebox();
  }

  // NOT USED ANYMORE (BECAUSE AUTO UPDATE FROM SFA)
  // checkVersion(var data) async {
  //   isNeedUpdate(false);

  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String currentVersion = packageInfo.version;
  //   appVersion.value = currentVersion;

  //   try {
  //     String latestVersion = data[0]["Value"];
  //     appName.value = data[0]["AppName"];

  //     int currentVersionConverted =Utils().convertVersionNumber(currentVersion);
  //     int latestVersionConverted = Utils().convertVersionNumber(latestVersion);

  //     //compare latest version with module version (if module version is bigger than latest version, then app should be updated)
  //     bool moduleVersionStatus = true;
  //     int cntPendingData = 0; //count pending data (if there is pending data, then app should not be updated)

  //     Box retrySubmitQuizBox = await Hive.openBox<ServiceBox>(AppConfig.boxSubmitQuiz);
  //     var isRetrySubmit = retrySubmitQuizBox.get(AppConfig.keyStatusBoxSubmitQuiz);
  //     retrySubmitQuizBox.close();

  //     if (isRetrySubmit != null && isRetrySubmit.value == "true") {
  //       cntPendingData = 1;
  //     }

  //     for (int i = 0; i < moduleList.length; i++) {
  //       int moduleVersionConverted = Utils().convertVersionNumber(moduleList[i].version);
  //       if (moduleVersionConverted > currentVersionConverted) {
  //         moduleVersionStatus = false;
  //         break;
  //       }
  //     }

  //     if (latestVersionConverted > currentVersionConverted && !moduleVersionStatus && cntPendingData == 0) {
  //       isNeedUpdate(true);
  //     }
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     openErrorDialog();
  //     isError(true);
  //     change(null, status: RxStatus.error(errorMessage.value));
  //   }
  // }

  getBox() async {
    try {
      vendorBox = await Hive.openBox('vendorBox');
      shiptobox = await Hive.openBox('shiptoBox');
      customerBox = await Hive.openBox('customerBox');
      boxpostpenjualan =  await Hive.openBox('penjualanReportpostdata');
      boxreportpenjualan = await Hive.openBox('penjualanReport');
      tokenbox = await Hive.openBox('tokenbox');
    // ignore: empty_catches
    } catch (e) {
    }
  }

  closebox() async{
    try {
      vendorBox.close();
      shiptobox.close();
      customerBox.close();
      boxpostpenjualan.close();
      boxreportpenjualan.close();
      tokenbox.close();
    // ignore: empty_catches
    } catch (e) {
    }
  }

  getVendor() async { 
    await getBox();
    try {
      
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if(!isConnected){
        moduleList.removeWhere((element) => element.moduleID.contains("Taking Order Vendor"));
        await closebox();
        return;
      }

      var tokenboxdata = await tokenbox.get(salesIdParams.value);
      var dectoken = Utils().decrypt(tokenboxdata);
      var result = await ApiClient().getData(urlAPI,"${AppConfig.apiurlvendorpath}/api/setting/customer/${customerIdParams.value}",options: Options(headers: {
          'Authorization': 'Bearer $dectoken',
          'Accept': 'application/json',
      },));
      // print("$urlAPI${AppConfig.apiurlvendorpath}/api/setting/customer/${customerIdParams.value}");
      var data = VendorInfo.fromJson(result);
      if(data.availVendors.isNotEmpty){
        int index = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order Vendor"));
        var versi = moduleList[index].version;
        var order = moduleList[index].orderNumber;
        for (var i = 0; i < data.availVendors.length; i++) {
          moduleList.add(Module(moduleID: "Taking order ${data.availVendors[i].name}", version: versi, orderNumber: order));
        }
        moduleList.removeWhere((element) => element.moduleID.contains("Taking Order Vendor"));
      }
      var moduleBox = await Hive.openBox<Module>('moduleBox');
      await moduleBox.clear();
      await moduleBox.addAll(moduleList);
      await vendorBox.delete("${salesIdParams.value}|${customerIdParams.value}");
      await vendorBox.put("${salesIdParams.value}|${customerIdParams.value}", data.availVendors);
      await customerBox.delete(data.customer.no);
      await customerBox.put(data.customer.no,Customer(address: data.customer.address,city: data.customer.city,county:data.customer.county ,name: data.customer.name,no: data.customer.no,timestamp:  DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())));
      await shiptobox.delete(data.customer.no);
      if(data.shipToAddresses.isNotEmpty){
        await shiptobox.put(data.customer.no,data.shipToAddresses);
      }
    } on SocketException{
      moduleList.removeWhere((element) => element.moduleID.contains("Taking Order Vendor"));
    } catch (e) {
      moduleList.removeWhere((element) => element.moduleID.contains("Taking Order Vendor"));
      await loginapivendor();
    }
    
    await closebox();
  }

  postTrackingVersion() async {
    //print("post");
    var trackVersionBox = await Hive.openBox('trackVersionBox');
    var trackVersion = trackVersionBox.get('trackVersion');
    var lastUpdated = trackVersionBox.get('lastUpdatedVersion');

    if ((trackVersion != null && trackVersion != "") && (lastUpdated != null && lastUpdated != "")) {
      var now = DateTime.now();

      var formatter = DateFormat('yyyy-MM-dd');
      String strLastUpdated = formatter.format(lastUpdated);
      String strCurrentDate = formatter.format(now);

      int mLastUpdated = int.parse(strLastUpdated.substring(5, 7));
      int yLastUpdated = int.parse(strLastUpdated.substring(0, 4));
      int mCurrentDate = int.parse(strCurrentDate.substring(5, 7));
      int yCurrentDate = int.parse(strCurrentDate.substring(0, 4));

      bool submitVersion = false;
      if (mCurrentDate - mLastUpdated > 0 || yCurrentDate > yLastUpdated) {
        submitVersion = true;
      } else {
        submitVersion = false;
      }

      var salesIdVersion = trackVersionBox.get('salesIdVersion');

      if (submitVersion || salesIdParams.value != salesIdVersion || trackVersion != appVersion.value) {
        var connTest = await ApiClient().checkConnection();
        var arrConnTest = connTest.split("|");
        bool isConnected = arrConnTest[0] == 'true';
        String urlAPI = arrConnTest[1];

        if (isConnected) {
          try {
            var params = {
              'sales_id': salesIdParams.value,
              'version': appVersion.value,
            };

            var bodyData = jsonEncode(params);
            var resultSubmit = await ApiClient().postData(
                urlAPI,
                '/version/track',
                Utils.encryptData(bodyData),
                Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json"
                }));

            if (resultSubmit == "success") {
              change(null, status: RxStatus.success());
              Get.offAndToNamed(RouteName.homepage);
            } else {
              errorMessage.value = resultSubmit;
              openErrorDialog();
              isError(true);
              change(null, status: RxStatus.error(errorMessage.value));
            }
          } catch (e) {
            errorMessage.value = e.toString();
            openErrorDialog();
            isError(true);
            change(null, status: RxStatus.error(errorMessage.value));
          }
        } else {
          errorMessage(Message.errorConnection);
          openErrorDialog();
          isError(true);
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        change(null, status: RxStatus.success());
        Get.offAndToNamed(RouteName.homepage);
      }
    } else {
      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if (isConnected) {
        try {
          var params = {
            'sales_id': salesIdParams.value,
            'version': appVersion.value,
          };

          var bodyData = jsonEncode(params);
          var resultSubmit = await ApiClient().postData(
              urlAPI,
              '/version/track',
              Utils.encryptData(bodyData),
              Options(headers: {
                HttpHeaders.contentTypeHeader: "application/json"
              }));

          if (resultSubmit == "success") {
            trackVersionBox.put("trackVersion", appVersion.value);
            trackVersionBox.put("salesIdVersion", salesIdParams.value);
            trackVersionBox.put("lastUpdatedVersion", DateTime.now());

            change(null, status: RxStatus.success());
            Get.offAndToNamed(RouteName.homepage);
          } else {
            errorMessage.value = resultSubmit;
            openErrorDialog();
            isError(true);
            change(null, status: RxStatus.error(errorMessage.value));
          }
        } catch (e) {
          errorMessage.value = e.toString();
          openErrorDialog();
          isError(true);
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        errorMessage(Message.errorConnection);
        openErrorDialog();
        isError(true);
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  buttonAction(String moduleid) {
    if (moduleid == 'Kuis') {
      Get.toNamed(RouteName.quizDashboard);
    } else {
      String pattern = "Taking order ";
      selectedVendor.value = moduleid.substring(pattern.length);
      Get.toNamed(RouteName.takingOrderVendor);
    }
  }

  getParameterData() async {
    //SalesID;CustID;LocCheckIn
    String parameter = await Utils().readParameter();
    if (parameter != "") {
      var arrParameter = parameter.split(';');
      for (int i = 0; i < arrParameter.length; i++) {
        if (i == 0) {
          salesIdParams.value = arrParameter[i];
        } else if (i == 1) {
          customerIdParams.value = arrParameter[i];
        } else {
          isCheckInParams.value = arrParameter[2];
        }
      }
    }
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

      String encparam = Utils().encryptsalescodeforvendor(salesIdParams.value);
      var params = {
        "username" : encparam
      };
      var result = await ApiClient().postData(urlAPI,"${AppConfig.apiurlvendorpath}/api/login",
            params,
            Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      var dataresp = LoginResponse.fromJson(result);
      if(!tokenbox.isOpen){
        tokenbox = await Hive.openBox('tokenbox');
      }
      tokenbox.delete(salesIdParams.value);
      tokenbox.put(salesIdParams.value, dataresp.data!.token);
      tokenbox.close();
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() {
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    throw UnimplementedError();
  }

}
