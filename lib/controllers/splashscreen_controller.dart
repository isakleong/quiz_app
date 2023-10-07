import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/common/route_config.dart';
import 'package:sfa_tools/controllers/background_service_controller.dart';
import 'package:sfa_tools/models/customer.dart';
import 'package:sfa_tools/models/loginmodel.dart';
import 'package:sfa_tools/models/module.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/dialog.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:shimmer/shimmer.dart';
import '../models/vendorinfomodel.dart';
import '../widgets/dialoginfo.dart';
import 'package:http/http.dart' as http;

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
  late Box devicestatebox;
  bool retrypermission = false;
  GlobalKey keybanner = GlobalKey();

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
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      appVersion.value = currentVersion;
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

  managetokenbox(String action) async {
    try {
      if(action == 'open'){
        tokenbox = await Hive.openBox('tokenbox');
      } else {
        tokenbox.close();
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  managecustomerbox(String action) async {
    try {
      if(action == "open"){
        customerBox = await Hive.openBox('customerBox');
      } else {
        customerBox.close();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  manageshipbox(String action) async {
    try {
      if(action == "open"){
        shiptobox = await Hive.openBox('shiptoBox');
      } else {
        shiptobox.close();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  managedevicestatebox(String action) async{
     try {
      if(action == 'open'){
        devicestatebox = await Hive.openBox('devicestatebox');
      } else {
        devicestatebox.close();
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  managebranchinfobox(String action) async {
    try {
      if(action == 'open'){
        branchinfobox = await Hive.openBox('BranchInfoBox');
      } else {
        branchinfobox.close();
      }
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
      String salesid = await Utils().getParameterData('sales');
      String encparam = Utils().encryptsalescodeforvendor(salesid);
      var params = {
        "username" : encparam
      };
      var result = await ApiClient().postData(urlAPI,"${AppConfig.apiurlvendorpath}/api/login",
            params,
            Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      var dataresp = LoginResponse.fromJson(result);
      await managetokenbox('open');
      if(!tokenbox.isOpen){
        tokenbox = await Hive.openBox('tokenbox');
      }
      tokenbox.delete(salesid);
      tokenbox.put(salesid, dataresp.data!.token);
      await managetokenbox('close');
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

 //untuk unduh ulang data
  late dynamic jsonstate;
  RxList<String> progressdownload = <String>[].obs;
  List<Vendor> vendorlistunduhulang = <Vendor>[];

  int calculateJsonSize(dynamic jsonData) {
    String jsonString = json.encode(jsonData);
    int sizeInBytes = utf8.encode(jsonString).length;
    return sizeInBytes;
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  showloadingbanner(BuildContext ctx){
    progressdownload.clear();
    for (var i = 0; i < 4; i++) {
      progressdownload.add('');
    }
    double width = MediaQuery.of(ctx).size.width;
    double height = MediaQuery.of(ctx).size.height;
    Get.dialog(
      barrierDismissible: false,
      WillPopScope(
        onWillPop: _onWillPop,
        child: Dialog(
          key: keybanner,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: SizedBox(
                width: width * 0.8,
                height: 0.25 * height,
                child: Stack(
                  children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  const TextView(text: "Mohon Menunggu",fontSize: 18, headings: 'H2'),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Obx(()=>Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for(var k =0; k< progressdownload.length;k++)
                        progressdownload[k] == ''? 
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 0.1 * width,
                              height: 0.1 * width,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                            ),
                          ) : progressdownload[k] == 'ok'? Container(
                              width: 0.1 * width,
                              height: 0.1 * width,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ) : Container(
                              width: 0.1 * width,
                              height: 0.1 * width,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            )
                        // Lottie.asset('assets/lottie/${progressdownload[k]}', width: width * 0.25),
                  ],))
                ],
              ),
            ),
          ],
        ),
          )),
      ));
  }

  unduhdataroute() async {
    try {
      final encryptedParam = await Utils.encryptData(await Utils().getParameterData("sales"));
      var postbody = {
        'sales' : encryptedParam
      };
      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
        progressdownload[0] = 'bad';
        Navigator.pop(keybanner.currentContext!);
        return;
      }
      String urlAPI = arrConnTest[1];
      final response = await http.post(Uri.parse("$urlAPI/getcustbyroute"),headers: {"Content-Type": "application/json",}, body: jsonEncode(postbody),);
      var datajson = jsonDecode(response.body);
      progressdownload[0] = 'ok';
      unduhdatacustomer(datajson['data']);
    } catch (e) {
      //error tidak bisa update
      progressdownload[0] = 'bad';
      Navigator.pop(keybanner.currentContext!);
    }
  }

  unduhdatacustomer(dynamic listcust) async {
    try {
      String salesid = await Utils().getParameterData('sales');
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
        Navigator.pop(keybanner.currentContext!);
        progressdownload[1] = 'bad';
        return;
      }
      String urlAPI = arrConnTest[1];
      await managetokenbox('open');
      var tokenboxdata = await tokenbox.get(salesid);
      var dectoken = Utils().decrypt(tokenboxdata);
      await managetokenbox('close');
      final url = Uri.parse('$urlAPI${AppConfig.apiurlvendorpath}/api/setting/multi-customer-info');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $dectoken',
      });

      for (var i = 0; i < listcust.length; i++) {
        request.fields['customers[$i]'] = listcust[i]['CustID'];
      }
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      var datadecoded = jsonDecode(responseString);
      await managecustomerbox('open');
      await manageshipbox('open');
      for (var i = 0; i < datadecoded['customers'].length; i++) {
        Customer datacust = Customer.fromJson(datadecoded['customers'][i]['customer']);
        if(!customerBox.isOpen) await managecustomerbox('open');
        await customerBox.delete(datacust.no);
        await customerBox.put(datacust.no,datacust);
        if(datadecoded['customers'][i]['shipToAddresses'].length != 0){
          for (var j = 0; j < datadecoded['customers'][i]['shipToAddresses'].length; j++) {
            ShipToAddress dataaddr = ShipToAddress.fromJson(datadecoded['customers'][i]['shipToAddresses'][j]);
            if(!shiptobox.isOpen) await manageshipbox('open');
            await shiptobox.delete(datacust.no);
            await shiptobox.put(datacust.no,dataaddr);
          }
        }
      }
      await managecustomerbox('close');
      await manageshipbox('close');
      progressdownload[1] = 'ok';
      unduhdataitem();
      return;
    } on SocketException{
        progressdownload[1] = 'bad';
        Navigator.pop(keybanner.currentContext!);
        await managetokenbox('close');
        await managecustomerbox('close');
        return;
    } catch (e) {
        progressdownload[1] = 'bad';
        unduhdataitem();
        await managetokenbox('close');
        await managecustomerbox('close');
        return;
    }
  }

  unduhdataitem() async {
    try {
      vendorlistunduhulang.clear();
      String salesid = await Utils().getParameterData('sales');
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
        progressdownload[2] = 'bad';
        Navigator.pop(keybanner.currentContext!);
        return;
      }
      String urlAPI = arrConnTest[1];
      await managetokenbox('open');
      var tokenboxdata = await tokenbox.get(salesid);
      var dectoken = Utils().decrypt(tokenboxdata);
      await managetokenbox('close');
      final url = Uri.parse('$urlAPI${AppConfig.apiurlvendorpath}/api/setting/all-items');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $dectoken',
      });
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      var datadecoded = jsonDecode(responseString);
      for (var i = 0; i < datadecoded['vendors'].length; i++) {
        vendorlistunduhulang.add(Vendor.fromJson(datadecoded['vendors'][i]));
      }
      progressdownload[2]= "ok";
      if(vendorlistunduhulang.isNotEmpty){
        downloadConfigFile('getinfoproduk');
      } else {
        progressdownload[3] = 'bad';
        Navigator.pop(keybanner.currentContext!);
      }
    } on SocketException{
      progressdownload[2] = 'bad';
      Navigator.pop(keybanner.currentContext!);
      await managetokenbox('close');
    } catch (e) {
      progressdownload[2] = 'bad';
      Navigator.pop(keybanner.currentContext!);
      await managetokenbox('close');
    }
  }

  unduhmoduleaccess() async{
    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];
    if(!isConnected){
      for (var i = 0; i < progressdownload.length; i++) {
        progressdownload[i] = 'bad';
      }
      Navigator.pop(keybanner.currentContext!);
         Get.dialog(Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: DialogInfo(
            desc: "Tidak Ada koneksi internet !",
            judul: "Oops, Terjadi kesalahan",lottieasset: "error.json",
            ontap: () {
              Get.back();
            },
          )));
        return;
    } else {
      moduleList.clear();
      String salesid = await Utils().getParameterData('sales');
      final encryptedParam = await Utils.encryptData(salesid);
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
      await branchinfobox.delete(salesid);
      await branchinfobox.put(salesid, data['BranchInfo']);
      await branchinfobox.close();
      var idx = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order"));
      if(idx != -1){
        moduleList.removeAt(idx);
        await loginapivendor();
        await managetokenbox('open');
        var tokendata = await tokenbox.get(salesid);
        await managetokenbox('close');
        if (tokendata != null) {
          getstateunduhulang();
        } else {
          for (var i = 0; i < progressdownload.length; i++) {
            progressdownload[i] = 'bad';
          }
          Navigator.pop(keybanner.currentContext!);
        }
      }
    }
  }

  getstateunduhulang() async {
    try {
      DateTime now = DateTime.now();
      print('start time: $now');
      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
      //tidak ada koneksi tidak bisa update
        Navigator.pop(keybanner.currentContext!);
        return;
      }
      String urlAPI = arrConnTest[1];
      String saleid = await Utils().getParameterData('sales');
      String branchcode = saleid.toString().substring(0,3);
      final result = await ApiClient().getData(urlAPI, "/getstate?branch=$branchcode");
      jsonstate = jsonDecode(result);
      await managedevicestatebox('open');
      var datastatebox = await devicestatebox.get(saleid);
      await managedevicestatebox('close');
      if(datastatebox != null){
        for (var i = 0; i < jsonstate['datastate'].length; i++) {
          for (var k = 0; k < datastatebox['datastate'].length; k++) {
            if(datastatebox['datastate'][k]['name'] == jsonstate['datastate'][i]['name'] && datastatebox['datastate'][k]['Value'] != jsonstate['datastate'][i]['Value']){
              if(AppConfig().vendorstate.toLowerCase() == datastatebox['datastate'][k]['name'].toString().toLowerCase()){
                //perlu update
                // Navigator.pop(keybanner.currentContext!);
                unduhdataroute();
                return;
              }
            }
          }
        }
        //sudah terupdate
        Navigator.pop(keybanner.currentContext!);
        Get.dialog(Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: DialogInfo(
            desc: "Semua data telah diupdate !",
            judul: "Informasi",lottieasset: "done.json",
            ontap: () {
              Get.back();
            },
          )));
        return;
      }
      //belum ada data state, perlu update
      unduhdataroute();
      return;
    } catch (e) {
      //error tidak bisa update
      print(e);
      for (var i = 0; i < progressdownload.length; i++) {
        progressdownload[i] = 'bad';
      }
      return;
    }
  }

  updatestate() async{
      bool allok = true;
      String salesid = await Utils().getParameterData('sales');
      for (var i = 0; i < progressdownload.length; i++) {
        if(progressdownload[i] != 'ok'){
          allok = false;
          break;
        }
      }
      if(allok){
        DateTime now = DateTime.now();
        print('end time: $now');
        await managedevicestatebox('open');
        await devicestatebox.delete(salesid);
        await devicestatebox.put(salesid, jsonstate);
        await managedevicestatebox('close');
        Navigator.pop(keybanner.currentContext!);
        Get.dialog(Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: DialogInfo(
            desc: "Semua data telah diupdate !",
            judul: "Informasi",lottieasset: "done.json",
            ontap: () {
              Get.back();
            },
          )));
          return;
      }
      Navigator.pop(keybanner.currentContext!);
  }

  processfile(bool download,String vendor) async {
    String productdir = AppConfig().productdir;
    String informasiconfig = AppConfig().informasiconfig;
    print("download");
    //download not using await because efficiency time for parallel download
    String branchuser = "";
    String warnauser = "";
    String areauser = "";
    await managebranchinfobox('open');
    var databranch = await branchinfobox.get(await Utils().getParameterData("sales"));
    try {
      branchuser = databranch[0]['branch'];
      warnauser = databranch[0]['color'];
      areauser = databranch[0]['area'];
    // ignore: empty_catches
    } catch (e) {
      
    }
    await managebranchinfobox('close');

    if (await File('$productdir/$vendor/$informasiconfig').exists()) {
        var res = await File('$productdir/$vendor/$informasiconfig').readAsString();
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
  
  Future<void> downloadConfigFile(String url) async {
    try {
      String productdir = AppConfig().productdir;
      String informasiconfig = AppConfig().informasiconfig;
      String vendorname = "";
      for (var m = 0; m < vendorlistunduhulang.length; m++) {
        vendorname = vendorlistunduhulang[m].name.toLowerCase();
        // Create a folder if it doesn't exist
        Directory directory = Directory('$productdir/$vendorname/');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        var connTest = await ApiClient().checkConnection();
        var arrConnTest = connTest.split("|");
        bool isConnected = arrConnTest[0] == 'true';
        String urlAPI = arrConnTest[1];
        if (!isConnected) {
          progressdownload[3] = 'bad';
          if (await File('$productdir/$vendorname/$informasiconfig').exists()) {
            processfile(false,vendorname);
          }
        } else {
          // Create the file path
          String filePath = '$productdir/$vendorname/$informasiconfig';

          // Download the file
          final response = await http.get(Uri.parse('$urlAPI/$url?vendor=$vendorname'));

          if (response.statusCode == 200) {
            // Write the file
            try {
              var resp = jsonDecode(response.body);
              if(resp['error'] == 'vendor tidak ditemukan'){
                if (await File('$productdir/$vendorname/$informasiconfig').exists()) {
                  processfile(true,vendorname);
                }
              }
            } catch (e) {
              File file = File(filePath);
              await file.writeAsBytes(response.bodyBytes);
              processfile(true,vendorname);
            }
          } else {
            progressdownload[3] = 'bad';
            if (await File('$productdir/$vendorname/$informasiconfig').exists()) {
              processfile(true,vendorname);
            }
          }
        }
      }
      if(progressdownload[3] != 'bad'){
        progressdownload[3] = 'ok';
      }
      Navigator.pop(keybanner.currentContext!);
      return;
      updatestate();
    } catch (e) {
      progressdownload[3] = 'bad';
      Navigator.pop(keybanner.currentContext!);
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
